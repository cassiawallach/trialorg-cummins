/************************************************************
Name:  IAM_RequestAccessController
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_RequestAccessController class. 
Request access for salesforce IAM users.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018       INITIAL DEVELOPMENT 
1.1 -    Shubhangi Sardar       23/03/2020       MAde Changes for Legacy User  
1.2 -    Nishant Verma          10/02/2020       Made changes for High Radius application
1.3 -    Anupam Adhikari        03/22/2021       Changes made for Global dealer portal.
1.4 -    Anupam Adhikari        09/24/2021       Changes made for RSW...
1.5 -    Anupam Adhikari        11/02/2021       Global Dealer Portal changes...
1.6 -    Sandeep Vuyyuru        17/11/2021       Changes added for Powerspec
1.7 -    Chetan Gaikwad         25/03/2022       SP code validation for RSW
1.8 -    Suresh Rathod          20/04/2022       Added changes Guidanz Service Portal Enhancements 
*****************************************************/
/********************************************************************************
***********************************************************************************/

Public class IAM_RequestAccessController {
    
    Public App_Mapping__c app{get;set;}
    public String currentRecordId {get;set;}
    public user currentloginUser {get;set;}//added get,set for POwerspec
    public Contact con;
    public Account acc {set;get;}
    public list<IAM_Contact_Provisioning__c> lstContactApps;
    public list<IAM_Application__c> lstAccApps;
    public string requestedApp {get;set;}
    public boolean sumbitFlag{get;set;}
    public IAM_Application__c appToInsert{get;set;}
    public boolean pendingappInactive;
    public boolean pendingappactive;
    public boolean pendingapp;
    public IAM_Application__c appToFinal;
    public IAM_Contact_Provisioning__c conAppInsert;
    public Id approverLocationadmin;
    public Id approverInternalAdmin;
    public PageReference pageRef;
    Public boolean conAppPending{set;get;}//WE need ot see pending once in order to display pending message.
    public boolean ConAppActive{set;get;}//If there are active Contact Provisionings then they should login directly.
    public boolean isRSWsection{get;set;} //property for RSW fields section
    public boolean isPowerSpecFlag{get;set;} //property for Powerspec fields section
    public String rswPreferCode{get;set;} //property for storing prefer serive code.
    public String rswAdditionalCode{get;set;} //property for storing additional code
    public String rswAdditionalCode1{get;set;} //property for storing additional code
    public String rswAdditionalCode2{get;set;} //property for storing additional code
    public String rswAdditionalCode3{get;set;} //property for storing additional code
    public String rswAdditionalCode4{get;set;} //property for storing additional code
    public String companyName{get;set;} //property for storing com code
    public String rswReason{get;set;} //property for storing reason
    public String occList{get;set;} //property for storing occList powerspec
    public String rswOtherReason{get;set;} //property for storing other reason 
    public String errorPrefercode{get;set;}
    public String errorRswReason{get;set;}
    public String errorOccList{get;set;}//property of powerspec for showing error
    public String errorAddcode1{get;set;}
    public String errorAddcode2{get;set;}
    public String errorAddcode3{get;set;}
    public String errorAddcode4{get;set;}
    public String errorAddcode5{get;set;}
    public string errorPostalcode {set;get;}
    public boolean errorfound{set;get;}
    Public IAM_Application__c appActive{set;get;}
    public string additionalCodefinal{set;get;}
    Public String uid{set;get;}
    public List < SelectOption > reasonsList {
        set;
        get;
    }
    public List < SelectOption > occupationList {
        set;
        get;
    }//property of powerspec
    public boolean HighradiusFlag{get;set;}
    Public string HighRadiuscustomerNumber{get;set;}
     Public string HighRadiuslanguage{get;set;}
    Public string highRadiusInvoiceNo{get;set;}
    Public IAM_HighRadius_Parser.BMSresponseToSF objBMStoSF;
    Public string Username{get;set;}
    Public string errorBMS{get;set;}
    Public string Language{get;set;}
            
    /* Guidanz Service Portal Variables */
    public String erpCustomerCode {get;set;}
    public String errorERPCustcode {get;set;}
    public String errorState {get;set;}
	public String errorCountry {get;set;} 
    
    public IAM_RequestAccessController(ApexPages.StandardController controller) {
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        requestedApp = ApexPages.CurrentPage().getparameters().get('reqAppName');
        uid=ApexPages.currentPage().getParameters().get('uid');
        sumbitFlag = false;
        HighradiusFlag = false;
        additionalCodefinal='';
        pendingappInactive = false;
        pendingappactive = false;
        pendingapp = false;
        ConAppActive=false;
        ConAppPending=false;
        errorBMS='';
        

        /* Get Reasons */
        reasonsList = new List < SelectOption >();
        reasonsList.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult = IAM_Contact_Provisioning__c.IAM_RSW_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)  {           
            reasonsList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        } 
        
        /* Get Occupations */
        occupationList = new List < SelectOption >();
        occupationList.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult2 = IAM_Contact_Provisioning__c.IAM_Occupation_List__c.getDescribe();
        List<Schema.PicklistEntry> pleas = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : pleas)  {           
            occupationList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        } 

        errorfound=false;   
        rswAdditionalCode = null;
        rswAdditionalCode1 =null;
        rswAdditionalCode2 = null;
        rswAdditionalCode3 = null;
        rswAdditionalCode4 = null;
        rswPreferCode = null;

        /*Guidanz Service Portal Variables */
        erpCustomerCode = null;

        appActive=new IAM_Application__c();
        if(currentRecordId != null) {
            app = [select AppId__c,Name,CMI_Internal_URL__c,IAM_Skip_Contact_Type_Check__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c, 
                   Registration_Link__c,CMI_External_Start_Url__c,IAM_Request_Access__c,IAM_Paid_Subscription__c,IAM_Default_Approver__c,IAM_Default_Role__c from App_Mapping__c where id=: currentRecordId  ];
            system.debug('Id'+app);
        }
        //checking if app name is Rapid serve
        
        
        currentloginUser = [Select id,Name,Contactid,username,IAM_HR_Customer_Number__c,IAM_HR_BMS_Instance_Name__c from user where id=:userinfo.getuserid()];
        Username=currentloginUser.Username;
        //con = [select id,IAM_Internal__c,CMI_Contact_Type__c,Accountid,IAM_HR_Customer_Number__c,IAM_HR_BMS_Instance_Name__c from Contact where id=:currentloginUser.Contactid];
        con = [select id,IAM_Internal__c,CMI_Contact_Type__c,Accountid from Contact where Username__c=:uid and IAM_Contact_Status__c='Active' LIMIT 1];
        if(currentRecordId  != null) {
            
            lstContactApps = [select id,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Contact__c,IAM_Role__c,IAM_Status__c,IAM_User__c from IAM_Contact_Provisioning__c
                              where IAM_Contact__r.id =:con.id and IAM_Application_Name__c =:app.Name AND IAM_Status__c != 'Inactive']; 
            lstAccApps = [ select id,IAM_Account_Name__c,IAM_Application_Name__c,IAM_Subscription_Name__c,IAM_Role__c,IAM_Status__c,IAM_Free_Subscription__c,IAM_Subscription_Start_Date__c 
                          from IAM_Application__c where IAM_Account_Name__r.id =:con.Accountid and IAM_Application_Name__c =:app.Name and IAM_Status__c != 'Inactive'];
            system.debug('Contact Apps*****'+lstContactApps );
            system.debug('Account apps*****'+lstAccApps );                
            
        }
        
        requestApp();
    }
    public List<SelectOption> getlanguages()
    {
        Schema.sObjectType objType = Contact.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('Language_Preferences__c').getDescribe().getPickListValues();
        
        List<SelectOption> options = new List<SelectOption>();
        for (Schema.PicklistEntry v : values){
            options.add(new SelectOption(v.getLabel(), v.getLabel()));
        }
        return options;
    }
    public pageReference requestApp() {
        System.debug('Printing request app');
        if(!lstContactApps.isEmpty()){
            for(IAM_Contact_Provisioning__c cp:lstContactApps){
                if(cp.IAM_Status__c=='Pending')
                {
                    conAppPending=true;
                }else if(cp.IAM_Status__c=='Active'){
                    conAppActive=true;
                }
            }
        }

        if(app.Name.equalsIgnoreCase(Label.IAM_AppName_GuidanzServicePortal)) {
            
            /*Start-Guidanz Portal enhancements-@Suresh*/
            acc=[
                SELECT Id, BillingStreet, BillingCity, BillingState, BillingStateCode, BillingCountry, BillingCountryCode, BillingPostalCode, CMI_Address2__c, RecordType.Name
                FROM Account
                WHERE Id = :con.AccountId Limit 1
                 ];   // Added this query to get Country and State picklist from Account
            acc.BillingCountryCode =null;
            acc.BillingStateCode =null;
                            
            /*End-Guidanz Portal enhancements-@Suresh*/ 

            if(conAppPending){
                sumbitFlag = false;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for access is still pending, you will receive further instructions via email once approved.'));
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
                sumbitFlag = true;
            }
            return null;
        }
        
        if(lstAccApps.size() > 0 && !lstAccApps.isEmpty()&& app.Name!='Rapid Serve Web' && app.Name!=System.Label.IAM_AppName_HighRadius) {//Checking if there are any applicaitons at location level 
            //checking there is any pending approvals
            for(IAM_Application__c pendApp : lstAccApps) {
                if(pendApp.IAM_Status__c == 'Pending') {
                    pendingapp = true;//Setting pending to true if any pending apps are present
                }
                else if(pendApp.IAM_Status__c == 'Active') {
                    // pendingappActive = true;
                    pendingappInactive = true;
                    appToFinal = pendApp;
                    appActive=pendApp;//Generally there should be only one Active record with this Criteria.
                }
            } 
        }
        else if(lstAccApps.size() > 0 && !lstAccApps.isEmpty()&& app.Name=='Rapid Serve Web'){
            
            for(IAM_Application__c pendApp : lstAccApps) {
                
                if(pendApp.IAM_Status__c == 'Active') {
                    appActive=pendApp;//Generally there should be only one Active record with this Criteria.
                }
            }
            if(conAppPending){
                System.debug('RSW pending Status'); 
                isRSWsection=false; 
                sumbitFlag = false;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for access is still pending, you will receive further instructions via email once approved.'));
            }else{
                system.debug('Submit flag trueRSW application');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
                sumbitFlag = true; //need to go to other page to enter required fields
                if(app.Name == 'Rapid Serve Web'){
                    isRSWsection = true;
                }
            } 
        }
        else if(lstAccApps.size() > 0 && app.Name==System.Label.IAM_AppName_HighRadius){
            system.debug('');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.label.IAM_Access_request));
                sumbitFlag = true;  
              HighradiusFlag=true;
            
        }
        

        if(lstAccApps.size() > 0 && !lstAccApps.isEmpty()&& app.Name!='Rapid Serve Web' && app.Name!='PowerSpec'){
            if(conAppPending){
                sumbitFlag = false;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for access is still pending, you will receive further instructions via email once approved.'));
            }
        }
        else { // there is no location apps in Account
            if(!app.IAM_Paid_Subscription__c) { //Paid subscription false
                if(!app.IAM_Request_Access__c) {//if application does not have permission to request access 
                    System.debug('paid subscription true with secondary');    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please contact your Distributor or Cummins Contact to get access to application.'));
                }else {//Has access to request application
                    if(con.CMI_Contact_Type__c == 'Primary') { //if contact is Primary and has access to application request and not paid then need to redirect to required fields page
                        //Display required fields with submit button
                        system.debug('Submit flag true');
                        if(app.Name == 'Rapid Serve Web'){
                            isRSWsection = true;
                        }

                        else if(app.Name == 'PowerSpec'){
                            isPowerSpecFlag = true;                            
                        }
                        else{
                            isRSWsection = false;
                        }
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
                        sumbitFlag = true; //need to go to other page to enter required fields
                    } else { //contact type is secondary
                        if(app.Name != 'Rapid Serve Web') {
                            if (app.Name == 'PowerSpec'){
                                isPowerSpecFlag = true;                             
                                sumbitFlag = true; 
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please enter below information to get access'));ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please enter below information to get access'));
                            }
                                else{
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please contact your site/location admin for requesting application access to your location'));
                            } 
                        } else {
                            /* Added condition for secondary user - Dec12*/
                            if(!conAppPending){// if condition added - Chetan Gaikwad
                                isRSWsection = true;
                                sumbitFlag = true; 
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
                            }
                        }                   
                    } 
                }
            }else {
                //Paid subscription true
                System.debug('paid subscription true');
                if(con.CMI_Contact_Type__c == 'Primary') {
                    // inform users to go to Cummins market place with link for subscription purchase
                    //string link='<a href="https://www.google.com"/>';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please go to Cummins market place with link for subscription purchase'));
                    System.debug('paid subscription true with primary');
                } else { 
                    System.debug('paid subscription true with secondary');    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please contact your site/location admin for purchasing application subscriptions and related access'));  
                }   
            }
        } 
        
        System.debug('App Active is in request app method'+appActive);
        return null;    
    }
    
    public pageReference submitApp() {
        //code start - RSW sp code duplicate validation - Chetan Gaikwad 
        errorPrefercode = '';
    	errorAddcode1 = '';
    	errorAddcode2 = '';
        errorAddcode3 = '';
        errorAddcode4 = '';
        errorAddcode5 = '';
        errorfound = false;
        //code end - RSW sp code duplicate validation - Chetan Gaikwad   
        try{
            if(app.Name.equalsIgnoreCase(Label.IAM_AppName_GuidanzServicePortal)) {
                guiServicePortalAppRequest();
            }
            if(app.name == 'Rapid Serve Web') {
                if(rswAdditionalCode != null && rswAdditionalCode !='') {
                    additionalCodefinal = rswAdditionalCode;
                }
                if(rswAdditionalCode1 != null && rswAdditionalCode1 !='') {
                    additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode1;
                }
                if(rswAdditionalCode2 != null && rswAdditionalCode2 !='') {
                    additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode2;
                }
                if(rswAdditionalCode3 != null && rswAdditionalCode3 !='') {
                    additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode3;
                }
                if(rswAdditionalCode4 != null && rswAdditionalCode4 !='') {
                    additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode4;
                }
                system.debug('-----RSW method---additionalCodefinal----'+additionalCodefinal);
                system.debug('-----RSW method---Prefer code----'+rswPreferCode);
                system.debug('-----RSW method---reason----'+rswReason);
                if(rswPreferCode == '' || rswPreferCode == null || rswPreferCode == '--None--') {
                    errorPrefercode = 'Missing Prefered Service Provider';
                    errorfound = true;
                }else{//code start - Chetan Gaikwad RSW SP Validation
                    errorfound = false;
                }
                if(!errorfound){
                    system.debug('Inside validate sp code');
                    errorfound = ValidateNumericSPcodeList(rswPreferCode, rswAdditionalCode, rswAdditionalCode1, rswAdditionalCode2, 
                                                   rswAdditionalCode3, rswAdditionalCode4, Label.IAM_ErrorMsg_Validate_SP_Code);
                    system.debug('@errorPrefercode'+errorPrefercode);
                }
                if(!errorfound){
                    system.debug('Inside duplicate rsw validate');               
                    errorfound = validateDuplicateRSWSPCode(rswPreferCode, rswAdditionalCode, rswAdditionalCode1, rswAdditionalCode2, 
                                                    rswAdditionalCode3, rswAdditionalCode4, Label.IAM_ErrorMsg_Duplicate_SP_Code);
                }
                if(!errorfound){//code end - Chetan Gaikwad RSW SP Validation
                    List<IAM_Application__c> applicationList = new List<IAM_Application__c>();
                    List<Account> accAppsList = new List<Account>();
                    set<id> accIds = new Set<id>();                
                    applicationList = [Select id,IAM_Account_Name__r.id,IAM_Application_Name__c,IAM_Status__c,IAM_Free_Subscription__c, 
                                       IAM_Role__c from IAM_Application__c where IAM_Application_Name__c = 'Rapid Serve Web' AND IAM_Status__c = 'Active'];
                    for(IAM_Application__c appAcc : applicationList) {
                        accIds.add(appAcc.IAM_Account_Name__r.id);
                    }
                    system.debug('&&&%%%% RSW accounts >>>>>>>>>'+accIds);                                      
                    accAppsList = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                   (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND id IN :accIds AND IAM_Service_Provider_Code__c = :rswPreferCode]; 
                    system.debug('&&&%%%% RSW accounts size>>>>>>>>>'+accAppsList.size()); 
                    if(accAppsList.size() > 0 && !accAppsList.isEmpty()) {
                        errorPrefercode = null;
                        errorfound = false;
                    } else {
                        errorPrefercode = 'Invaild Prefer Service provider code';
                        errorfound = true;
                    }             
                }
                if(rswAdditionalCode != null && rswAdditionalCode !='' && !errorfound) {//if statement update - Chetan
                    List<Account> accAppsList1 = new List<Account>();
                    accAppsList1 = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                    (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND IAM_Service_Provider_Code__c = :rswAdditionalCode limit 1]; 
                    if(accAppsList1.size() > 0 && !accAppsList1.isEmpty()) {
                        errorAddcode1 = null;
                        errorfound = false;
                    } else {
                        errorAddcode1 = 'Invaild Additional Service provider code';
                        errorfound = true;
                    }                
                    
                }
                if(rswAdditionalCode1 != null && rswAdditionalCode1 !='' && !errorfound) {//if statement update - Chetan
                    List<Account> accAppsList2 = new List<Account>();
                    accAppsList2 = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                    (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND IAM_Service_Provider_Code__c = :rswAdditionalCode1 limit 1]; 
                    if(accAppsList2.size() > 0 && !accAppsList2.isEmpty()) {
                        errorAddcode2 = null;
                        errorfound = false;
                    } else {
                        errorAddcode2 = 'Invaild Additional Service provider code';
                        errorfound = true;
                    }  
                }
                if(rswAdditionalCode2 != null && rswAdditionalCode2 !='' && !errorfound) {//if statement update - Chetan
                    List<Account> accAppsList3 = new List<Account>();
                    accAppsList3 = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                    (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND IAM_Service_Provider_Code__c = :rswAdditionalCode2 limit 1]; 
                    if(accAppsList3.size() > 0 && !accAppsList3.isEmpty()) {
                        errorAddcode3 = null;
                        errorfound = false;
                    } else {
                        errorAddcode3 = 'Invaild Additional Service provider code';
                        errorfound = true;
                    }  
                }
                if(rswAdditionalCode3 != null && rswAdditionalCode3 !='' && !errorfound) {//if statement update - Chetan
                    List<Account> accAppsList4 = new List<Account>();
                    accAppsList4 = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                    (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND IAM_Service_Provider_Code__c = :rswAdditionalCode3 limit 1]; 
                    if(accAppsList4.size() > 0 && !accAppsList4.isEmpty()) {
                        errorAddcode4 = null;
                        errorfound = false;
                    } else {
                        errorAddcode4 = 'Invaild Additional Service provider code';
                        errorfound = true;
                    } 
                }
                if(rswAdditionalCode4 != null && rswAdditionalCode4 !='' && !errorfound) {//if statement update - Chetan
                    List<Account> accAppsList5 = new List<Account>();
                    accAppsList5 = [select id,name,IAM_Service_Provider_Code__c,CMI_Account_Status__c from Account where IAM_Service_Provider_Code__c !=null AND 
                                    (CMI_Account_Status__c = 'Active' OR CMI_Account_Status__c ='Expired') AND IAM_Service_Provider_Code__c = :rswAdditionalCode4 limit 1]; 
                    if(accAppsList5.size() > 0 && !accAppsList5.isEmpty()) {
                        errorAddcode5 = null;
                        errorfound = false;
                    } else {
                        errorAddcode5 = 'Invaild Additional Service provider code';
                        errorfound = true;
                    } 
                }
                if(rswReason == '' || rswReason == null || rswReason == '--None--') {           
                    errorRswReason = 'Missing Reason for requesting';
                    errorfound = true;
                }
            }
            if(app.Name == 'PowerSpec'){
                if(occList == '' || occList == null || occList == '--None--' ) {           
                        errorOccList = 'Missing occupation';
                        errorfound = true;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please enter below information to get access'));ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please enter below information to get access'));
                    }
                    else{
                        errorOccList='';
                        errorfound = false;
                    }
                    
                }
            //Code to check rsw fields.
            System.debug('Printing error flag'+errorfound);
            if(app.Name!='Rapid Serve Web' && !HighradiusFlag && app.Name!='Global Dealer Portal'
            && app.Name!=Label.IAM_AppName_GuidanzServicePortal && app.Name!='PowerSpec'){ 
                Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Application__c'].Id;
                appToInsert = new IAM_Application__c();
                appToInsert.IAM_Account_Name__c = con.accountid;
                appToInsert.IAM_Application_Name__c = app.Name;
                appToInsert.IAM_Role__c =app.IAM_Default_Role__c;
                appToInsert.IAM_Status__c = 'Pending';
                appToInsert.IAM_Subscription_Start_Date__c = system.today();
                appToInsert.recordtypeid = RecIdpro1;  
                insert appToInsert; 
                
                parentInternalAdmin();
                
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(appToInsert.id);
                req1.setSubmitterId(appToInsert.ownerid);
                req1.setProcessDefinitionNameOrId('IAM_Application_approval_request');
                req1.setNextApproverIds(new Id[] {approverInternalAdmin});
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);
                sumbitFlag = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Location Application is created and submitted for approval'));
            }
            if(app.Name =='Global Dealer Portal' && app.IAM_Skip_Contact_Type_Check__c){
                system.debug('Inside Global Dealer Portal if--->');
                Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Application__c'].Id;
                appToInsert = new IAM_Application__c();
                appToInsert.IAM_Account_Name__c = con.accountid;
                appToInsert.IAM_Application_Name__c = app.Name;
                appToInsert.IAM_Role__c =app.IAM_Default_Role__c;
                appToInsert.IAM_Status__c = 'Active';
                appToInsert.IAM_Subscription_Start_Date__c = system.today();
                appToInsert.IAM_Subscription_End_Date__c = system.today() + 36500;
                appToInsert.recordtypeid = RecIdpro1;  
                insert appToInsert;
                
                Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                    conAppInsert = new IAM_Contact_Provisioning__c();
                    conAppInsert.IAM_Account_Application__c = appToInsert.id;
                    conAppInsert.IAM_Application_Name__c = app.Name;
                    conAppInsert.IAM_Role__c = 'Non-Dealer User';
                    conAppInsert.IAM_Start_Date__c = system.today();
                	conAppInsert.IAM_End_Date__c = system.today() + 36500;
                    conAppInsert.IAM_Status__c = 'Pending';
                    conAppInsert.IAM_User__c = currentloginUser.id;
                    conAppInsert.recordtypeid = RecIdpro;
                    conAppInsert.IAM_Contact__c = con.id;
                	insert conAppInsert;
                
                submitForApproval(conAppInsert.id,'IAM_Global_Dealer_Portal_App_Approval');
                sumbitFlag = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for application access is submitted for approval'));
            }
            if(app.Name=='Rapid Serve Web'&&errorfound==false){
                System.debug('Printing RSW web insert');
                if(lstAccApps.isEmpty()){
                    Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Application__c'].Id;
                    appToInsert = new IAM_Application__c();
                    appToInsert.IAM_Account_Name__c = con.accountid;
                    appToInsert.IAM_Application_Name__c = app.Name;
                    appToInsert.IAM_Role__c =System.Label.IAM_RSW_Roles;
                    appToInsert.IAM_Status__c = 'Active';
                    appToInsert.IAM_Subscription_Start_Date__c = system.today();
                    appToInsert.recordtypeid = RecIdpro1;  
                    appToInsert.Ownerid=System.Label.IAM_RSW_Queue_ID;
                    insert appToInsert; 
                    
                    Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                    conAppInsert = new IAM_Contact_Provisioning__c();
                    conAppInsert.IAM_Account_Application__c = appToInsert.id;
                    conAppInsert.IAM_Application_Name__c = app.Name;
                    conAppInsert.IAM_Role__c = 'BASIC';
                    conAppInsert.IAM_Start_Date__c = system.today();
                    conAppInsert.IAM_Status__c = 'Pending';
                    conAppInsert.IAM_User__c = currentloginUser.id;
                    conAppInsert.recordtypeid = RecIdpro;
                    conAppInsert.IAM_Contact__c = con.id;
                    //conAppInsert.OwnerId=System.Label.IAM_RSW_Queue_ID;
                    if(rswPreferCode!=''||rswPreferCode!=null){
                        conAppInsert.IAM_RSW_Preferred_Service_Code__c=rswPreferCode;
                    }
                    conAppInsert.IAM_RSW_Reason__c = rswReason;
                    if(additionalCodefinal != '' && additionalCodefinal != null)
                        conAppInsert.IAM_Additional_Service_Provider__c = additionalCodefinal;
                    if(rswOtherReason != '' && rswOtherReason != null)
                        conAppInsert.IAM_RSW_Other_Reason__c = rswOtherReason;
                    insert conAppInsert;
                    isRSWsection=false;
                    sumbitFlag = false;
                    //submitforApproval(System.Label.IAM_ConApp_Approval_Process_Name,System.Label.IAM_RSW_Queue_ID,conAppInsert.id,con.id);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for application access is submitted for approval'));
                }
                else if(!lstAccApps.isEmpty()&&conAppActive==false&&conAppPending==false){
                    System.debug('else if condition where account level recrd is present and active and active app'+appActive);
                    Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:appActive.IAM_Application_Name__c and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                    conAppInsert = new IAM_Contact_Provisioning__c();
                    conAppInsert.IAM_Account_Application__c = appActive.id;
                    conAppInsert.IAM_Application_Name__c = appActive.IAM_Application_Name__c ;
                    conAppInsert.IAM_Role__c = 'BASIC';
                    conAppInsert.IAM_Start_Date__c = system.today();
                    conAppInsert.IAM_Status__c = 'Pending';
                    conAppInsert.IAM_User__c = currentloginUser.id;
                    conAppInsert.recordtypeid = RecIdpro;
                    conAppInsert.IAM_Contact__c = con.id;
                    if(rswPreferCode!=''||rswPreferCode!=null){
                        conAppInsert.IAM_RSW_Preferred_Service_Code__c=rswPreferCode;
                    }
                    // conAppInsert.ownerId=System.Label.IAM_RSW_Queue_ID;
                    conAppInsert.IAM_RSW_Reason__c = rswReason;
                    if(additionalCodefinal != '' && additionalCodefinal != null)
                        conAppInsert.IAM_Additional_Service_Provider__c = additionalCodefinal;
                    if(rswOtherReason != '' && rswOtherReason != null)
                        conAppInsert.IAM_RSW_Other_Reason__c = rswOtherReason;
                    insert conAppInsert;
                    isRSWsection=false;
                    sumbitFlag = false;
                    //for RSW there is no need for approval. 
                    //  submitforApproval(System.Label.IAM_ConApp_Approval_Process_Name,System.Label.IAM_RSW_Queue_ID,conAppInsert.id,currentloginUser.id); 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for application access is submitted for approval'));
                }
            } 
            if(app.name == 'PowerSpec' &&errorfound==false){
                System.debug('entered Powerspec');
                if(lstAccApps.isEmpty()){
                    System.debug('enetered account Powerspec');
                Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Application__c'].Id;
                appToInsert = new IAM_Application__c();
                appToInsert.IAM_Account_Name__c = con.accountid;
                appToInsert.IAM_Application_Name__c = app.Name;
                appToInsert.IAM_Role__c = 'PowerSpec_Basic';
                appToInsert.IAM_Status__c = 'Active';
                appToInsert.IAM_Subscription_Start_Date__c = system.today();
                appToInsert.recordtypeid = RecIdpro1;  
                insert appToInsert;
                    
                Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                    conAppInsert = new IAM_Contact_Provisioning__c();
                    conAppInsert.IAM_Account_Application__c = appToInsert.id;
                    conAppInsert.IAM_Application_Name__c = app.Name;
                    conAppInsert.IAM_Role__c = 'PowerSpec_Basic';
                    conAppInsert.IAM_Start_Date__c = system.today();
                    conAppInsert.IAM_Status__c = 'Active';
                    conAppInsert.IAM_User__c = currentloginUser.id;
                    conAppInsert.recordtypeid = RecIdpro;
                    conAppInsert.IAM_Contact__c = con.id;
                    conAppInsert.IAM_Occupation_List__c = occList;
                    insert conAppInsert;
                    sumbitFlag = false;
                    isPowerSpecFlag= false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your account with Your \nUsername: '+currentloginUser.Username+' \n has received PowerSpec Website access.<br/><br/><u>Step 1</u> : First, please click on the below mentioned <u>logout link</u><br/><u> Step 2</u> : Only after logging out successfully, please try accessing<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://powerspecweb.cummins.com link on a different tab to access the website</p><br/><u>Logout Link</u>: <a href="' + Label.IAM_PowerSpec_Logout +'">Click Here</a>'));
                }
                else{
                    System.debug('Entered into Powerspec Else');
                    Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:app.Name and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                    conAppInsert = new IAM_Contact_Provisioning__c();
                    conAppInsert.IAM_Account_Application__c = appActive.id;
                    conAppInsert.IAM_Application_Name__c = appActive.IAM_Application_Name__c;
                    conAppInsert.IAM_Role__c = 'PowerSpec_Basic';
                    conAppInsert.IAM_Start_Date__c = system.today();
                    conAppInsert.IAM_Status__c = 'Active';
                    conAppInsert.IAM_User__c = currentloginUser.id;
                    conAppInsert.recordtypeid = RecIdpro;
                    conAppInsert.IAM_Contact__c = con.id;
                    conAppInsert.IAM_Occupation_List__c = occList;
                    insert conAppInsert;
                    sumbitFlag = false;
                    isPowerSpecFlag= false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your account with Your \nUsername: '+currentloginUser.Username+' \n has received PowerSpec Website access.<br/><br/><u>Step 1</u> : First, please click on the below mentioned <u>logout link</u><br/><u> Step 2</u> : Only after logging out successfully, please try accessing<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://powerspecweb.cummins.com link on a different tab to access the website</p><br/><u>Logout Link</u>: <a href="' + Label.IAM_PowerSpec_Logout +'">Click Here</a>'));
            
                    
                }
            }
            if(app.name == System.Label.IAM_AppName_HighRadius){
                objBMStoSF =IAM_HighRadius_GetBMSInstance.getBMSInstance(HighRadiuscustomerNumber, highRadiusInvoiceNo);
                 if(test.isRunningTest()){
                objBMStoSF.BMSinstance ='ONEBMS';
            objBMStoSF.erpCustomerCode = '48931-USA';
            }
                if(objBMStoSF.BMSinstance !='Error'){
                    errorBMS='';
                    Con.Language_Preferences__c= HighRadiuslanguage;             
                    update con;
                    //----User update -----
                    currentloginUser.IAM_HR_BMS_Instance_Name__c=objBMStoSF.BMSinstance;
                    currentloginUser.IAM_HR_Customer_Number__c=HighRadiuscustomerNumber;
                    if(HighRadiuslanguage=='English'){
                        currentloginUser.IAM_HR_Language__c='en_US';
                    }else if(HighRadiuslanguage=='Canadian French'){
                        currentloginUser.IAM_HR_Language__c='fr_CA';
                    }
                    update currentloginUser;
                    createContactProvisionigs(lstAccApps[0], Label.IAM_Status_Active);
                    sumbitFlag = false;  
                    HighradiusFlag=false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for application access is submitted'));
                    
                }else{
                    errorBMS=system.label.IAM_HR_CustomerNo_Error;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The Customer Number or Invoice number is incorrect.'));
                }
            }
        }catch(exception e){
            System.debug('Printing exception'+e.getMessage());
            System.debug('Printing exception Stack Trace String'+e.getStackTraceString());
        }   
        return null;  
    }

    //code start - Chetan Gaikwad
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
    
    system.debug('All sp code values '+ rswPreferSPCode +' '+ rswAddSPCode+' '+rswAddSPCode1 +' '+ rswAddSPCode2+' '+rswAddSPCode3+' '+ rswAddSPCode4);
                                                  
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
     
   system.debug('All error code values '+ errorAddcode1 +' '+ errorAddcode2+' '+errorAddcode3 +' '+ errorAddcode4+' '+errorAddcode5);
                                                  if(String.isBlank(errorAddcode1) && String.isBlank(errorAddcode2) && String.isBlank(errorAddcode3) && String.isBlank(errorAddcode4) && String.isBlank(errorAddcode5)) {
                                                      return false;
                                                  } else {
                                                      return true;
                                                  }
                                              }
    //Method for approval submission.
    /*Public Static Void submitforApproval(String approvalName,id approvalId,id objectId,id Submiter){
        
        System.debug('Submission for approval');
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(objectId);
        //req1.setSubmitterId(conAppInsert.Ownerid);
        req1.setSubmitterId(submiter);
        req1.setNextApproverIds(new Id[] {approvalId});
        req1.setProcessDefinitionNameOrId(approvalName);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        
    }*/
    
    public PageReference checkApprovalsRedirect(){
        try{
            System.debug('Printing all the applicaitons that are coming into this method appToFinal'+appToFinal);
            System.debug('Printing all the applicaitons that are coming into this method appToFinal'+appToFinal);
            System.debug('Printing pendingappAcitve'+pendingappActive);
            System.debug('Printing pendingInactive'+pendingappInactive);
            System.debug('Printing pendingapp'+pendingapp);
            System.debug('Printing Con App Pending'+conAppPending);
            
            if(pendingappActive) {
                
                //Active location applications
                if(app.CMI_External_Start_Url__c !=null)
                {
                    system.debug('External url'+app.CMI_External_Start_Url__c);
                    pageRef =new pageReference(app.CMI_External_Start_Url__c);
                }
                
            }
            
            if(pendingappInactive&&app.Name!='Rapid Serve Web'&& app.Name!='HighRadius'&&!conAppPending&&app.Name!='PowerSpec'){
                //inserting user application
                System.debug('Printing if it comes down to line 539');
                Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name =:appToFinal.IAM_Application_Name__c and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                conAppInsert = new IAM_Contact_Provisioning__c();
                conAppInsert.IAM_Account_Application__c = appToFinal.id;
                conAppInsert.IAM_Application_Name__c = appToFinal.IAM_Application_Name__c ;
                conAppInsert.IAM_Role__c = appToFinal.IAM_Role__c ;
                conAppInsert.IAM_Start_Date__c = system.today();
                conAppInsert.IAM_Status__c = 'Pending';
                conAppInsert.IAM_User__c = currentloginUser.id;
                conAppInsert.recordtypeid = RecIdpro;
                conAppInsert.IAM_Contact__c = con.id;
                insert conAppInsert;
                System.debug('Printing the number'+conAppInsert);
                if(!app.IAM_Skip_Contact_Type_Check__c){
                    if(con.CMI_Contact_Type__c == 'Primary') {
                        // sending approval to parent location admin
                        parentLocationadmin();
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval.');
                        req1.setObjectId(conAppInsert.id);
                        //req1.setSubmitterId(conAppInsert.Ownerid);
                        req1.setSubmitterId(approverLocationadmin);
                        req1.setNextApproverIds(new Id[] {approverLocationadmin});
                        req1.setProcessDefinitionNameOrId('IAM_Approval_User_Application_Rest');
                        req1.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req1);
                    } else {
                        System.debug('Printing the value if it is in else clause');
                        //sending approval to Location/site Admin
                        List<Contact> lstContOwner1 = [select id, accountid, Username__c from contact where AccountId =:con.Accountid and CMI_Contact_Type__c =: 'Primary'];
                        if(lstContOwner1.size() > 0 ) {
                            List<User> lstUser1 = [select id from user where username =: lstContOwner1[0].Username__c];
                            If(lstUser1.size() > 0)
                                approverLocationadmin = lstUser1[0].id;
                        }
                        if(approverLocationadmin==null){
                            approverLocationadmin =[select id,Username from user where id= :Label.IAM_Location_Admin_Karthik_G].id;
                        }
                        System.debug('Printing application'+approverLocationadmin);
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval.');
                        req1.setObjectId(conAppInsert.id);
                        req1.setSubmitterId(appToInsert.Ownerid);
                        req1.setProcessDefinitionNameOrId('IAM_Approval_User_Application_Rest');
                        req1.setNextApproverIds(new Id[] {approverLocationadmin});
                        req1.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req1);
                    }
                }else{
                    System.debug('Printing skip validation');
                    submitForApproval(conAppInsert.id,'IAM_Global_Dealer_Portal_App_Approval');
                }
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'You do not have sufficient access to login. Your request for getting access to this application has now been submitted for approval.'));
                
            }
            
            if(pendingapp) {
                if(con.CMI_Contact_Type__c == 'Primary') {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your request for access is still pending, you will receive further instructions via email once approved'));
                    
                } else {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Your Location Admin request for access is still pending. Once it is approved, either he can give you access or you need to request access again'));
                    
                }
            }
        }catch(exception ex){
            System.debug('Printing exceptoin'+ex.getMessage());
            System.debug('Printing Excpetion stack trace'+ex.getStackTraceString());
        }
        return null; 
    } 
 
 //Commenting the extra location hierarchy. In IAM we will hae atleast 4 levels of Hierarchy.   
    public void parentLocationadmin() {
        
        List<Account> lstParentId1 = [select id,ParentId from account where id =:con.AccountId];
        if(lstParentId1.size() > 0 ){
            List<Contact> lstContOwner1 = [select id, accountid, Username__c from contact where AccountId =: lstParentId1[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
            if(lstContOwner1.size() > 0 ){
                List<User> lstUser1 = [select id from user where username =: lstContOwner1[0].Username__c];
                If(lstUser1.size() > 0)
                    approverLocationadmin = lstUser1[0].id;
                system.debug('Approver*************'+approverLocationadmin );
            }else{
                List<Account> lstParentId2 = [select id,ParentId from account where id =: lstParentId1[0].ParentId];
                if(lstParentId2.size() > 0 ){
                    List<Contact> lstContOwner2 = [select id, accountid, Username__c from contact where AccountId =: lstParentId2[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                    if(lstContOwner2.size() > 0 ){
                        List<User> lstUser2 = [select id from user where username =: lstContOwner2[0].Username__c];
                        If(lstUser2.size() > 0)
                            approverLocationadmin = lstUser2[0].id;
                        system.debug('Approver*************'+approverLocationadmin );
                    }else{
                        List<Account> lstParentId3 = [select id,ParentId from account where id =: lstParentId2[0].ParentId];
                        if(lstParentId3.size() > 0 ){
                            List<Contact> lstContOwner3 = [select id, accountid, Username__c from contact where AccountId =: lstParentId3[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                            if(lstContOwner3.size() > 0 ){
                                List<User> lstUser3 = [select id from user where username =: lstContOwner3[0].Username__c];
                                If(lstUser3.size() > 0)
                                    approverLocationadmin = lstUser3[0].id;
                                system.debug('Approver*************'+approverLocationadmin );
                            }else{
                                List<Account> lstParentId4 = [select id,ParentId from account where id =: lstParentId3[0].ParentId];
                                if(lstParentId4.size() > 0 ){
                                    List<Contact> lstContOwner4 = [select id, accountid, Username__c from contact where AccountId =: lstParentId4[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                                    if(lstContOwner4.size() > 0 ){
                                        List<User> lstUser4 = [select id from user where username =: lstContOwner4[0].Username__c];
                                        If(lstUser4.size() > 0)
                                            approverLocationadmin = lstUser4[0].id;
                                        system.debug('Approver*************'+approverLocationadmin );
                                    }/*else{
                                        List<Account> lstParentId5 = [select id,ParentId from account where id =: lstParentId4[0].ParentId];
                                        if(lstParentId4.size() > 0 ){
                                            List<Contact> lstContOwner5 = [select id, accountid, Username__c from contact where AccountId =: lstParentId5[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                                            if(lstContOwner5.size() > 0 ){
                                                List<User> lstUser5 = [select id from user where username =: lstContOwner5[0].Username__c];
                                                If(lstUser5.size() > 0)
                                                    approverLocationadmin = lstUser5[0].id;
                                                system.debug('Approver*************'+approverLocationadmin );
                                            }else{
                                                List<Account> lstParentId6 = [select id,ParentId from account where id =: lstParentId5[0].ParentId];
                                                if(lstParentId4.size() > 0 ){
                                                    List<Contact> lstContOwner6 = [select id, accountid, Username__c from contact where AccountId =: lstParentId6[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                                                    if(lstContOwner6.size() > 0 ){
                                                        List<User> lstUser6 = [select id from user where username =: lstContOwner6[0].Username__c];
                                                        If(lstUser6.size() > 0)
                                                            approverLocationadmin = lstUser6[0].id;
                                                        system.debug('Approver*************'+approverLocationadmin );
                                                    }else{
                                                        List<Account> lstParentId7 = [select id,ParentId from account where id =: lstParentId6[0].ParentId];
                                                        if(lstParentId4.size() > 0 ){
                                                            List<Contact> lstContOwner7 = [select id, accountid, Username__c from contact where AccountId =: lstParentId7[0].ParentId and CMI_Contact_Type__c =: 'Primary'];
                                                            if(lstContOwner7.size() > 0 ){
                                                                List<User> lstUser7 = [select id from user where username =: lstContOwner7[0].Username__c];
                                                                If(lstUser7.size() > 0)
                                                                    approverLocationadmin = lstUser7[0].id;
                                                                system.debug('Approver*************'+approverLocationadmin );
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
        
    }
     
    public void parentInternalAdmin() {
        
        List<Account> lstParentId1 = [select id,ParentId from account where id =:con.AccountId];
        if(lstParentId1.size() > 0 ){
            List<Contact> lstContOwner1 = [select id, accountid, Username__c from contact where AccountId =: lstParentId1[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
            if(lstContOwner1.size() > 0 ){
                List<User> lstUser1 = [select id from user where IAM_UID__c =: lstContOwner1[0].Username__c AND IAM_Final_Approver__c='Y'];
                If(lstUser1.size() > 0)
                    approverInternalAdmin = lstUser1[0].id;
            }else{
                List<Account> lstParentId2 = [select id,ParentId from account where id =: lstParentId1[0].ParentId];
                if(lstParentId2.size() > 0 ){
                    List<Contact> lstContOwner2 = [select id, accountid, Username__c from contact where AccountId =: lstParentId2[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                    if(lstContOwner2.size() > 0 ){
                        List<User> lstUser2 = [select id from user where IAM_UID__c =: lstContOwner2[0].Username__c  AND IAM_Final_Approver__c='Y'];
                        If(lstUser2.size() > 0)
                            approverInternalAdmin = lstUser2[0].id;
                    }else{
                        List<Account> lstParentId3 = [select id,ParentId from account where id =: lstParentId2[0].ParentId];
                        if(lstParentId3.size() > 0 ){
                            List<Contact> lstContOwner3 = [select id, accountid, Username__c from contact where AccountId =: lstParentId3[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                            if(lstContOwner3.size() > 0 ){
                                List<User> lstUser3 = [select id from user where IAM_UID__c =: lstContOwner3[0].Username__c  AND IAM_Final_Approver__c='Y'];
                                If(lstUser3.size() > 0)
                                    approverInternalAdmin = lstUser3[0].id;
                            }else{
                                List<Account> lstParentId4 = [select id,ParentId from account where id =: lstParentId3[0].ParentId];
                                if(lstParentId4.size() > 0 ){
                                    List<Contact> lstContOwner4 = [select id, accountid, Username__c from contact where AccountId =: lstParentId4[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                                    if(lstContOwner4.size() > 0 ){
                                        List<User> lstUser4 = [select id from user where IAM_UID__c =: lstContOwner4[0].Username__c  AND IAM_Final_Approver__c='Y'];
                                        If(lstUser4.size() > 0)
                                            approverInternalAdmin = lstUser4[0].id;
                                    }/*else{
                                        List<Account> lstParentId5 = [select id,ParentId from account where id =: lstParentId4[0].ParentId];
                                        if(lstParentId4.size() > 0 ){
                                            List<Contact> lstContOwner5 = [select id, accountid, Username__c from contact where AccountId =: lstParentId5[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                                            if(lstContOwner5.size() > 0 ){
                                                List<User> lstUser5 = [select id from user where IAM_UID__c =: lstContOwner5[0].Username__c  AND IAM_Final_Approver__c='Y'];
                                                If(lstUser5.size() > 0)
                                                    approverInternalAdmin = lstUser5[0].id;
                                            }else{
                                                List<Account> lstParentId6 = [select id,ParentId from account where id =: lstParentId5[0].ParentId];
                                                if(lstParentId4.size() > 0 ){
                                                    List<Contact> lstContOwner6 = [select id, accountid, Username__c from contact where AccountId =: lstParentId6[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                                                    if(lstContOwner6.size() > 0 ){
                                                        List<User> lstUser6 = [select id from user where IAM_UID__c =: lstContOwner6[0].Username__c  AND IAM_Final_Approver__c='Y'];
                                                        If(lstUser6.size() > 0)
                                                            approverInternalAdmin = lstUser6[0].id;
                                                    }else{
                                                        List<Account> lstParentId7 = [select id,ParentId from account where id =: lstParentId6[0].ParentId];
                                                        if(lstParentId4.size() > 0 ){
                                                            List<Contact> lstContOwner7 = [select id, accountid, Username__c from contact where AccountId =: lstParentId7[0].ParentId and CMI_Contact_Type__c =: 'Primary' AND IAM_Internal__c = true];
                                                            if(lstContOwner7.size() > 0 ){
                                                                List<User> lstUser7 = [select id from user where IAM_UID__c =: lstContOwner7[0].Username__c AND IAM_Final_Approver__c='Y'];
                                                                If(lstUser7.size() > 0)
                                                                    approverInternalAdmin = lstUser7[0].id;
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
        
    }
    
    Public Void createContactProvisionigs(IAM_Application__c appToInsert, String status){
        System.debug('Printing application user name'+appToInsert);
        IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
        conSolUserapp.IAM_Account_Application__c = appToInsert.id;
        conSolUserapp.IAM_Contact__c = con.id;
        conSolUserapp.IAM_Start_Date__c = System.today();
        conSolUserapp.IAM_End_Date__c = System.today()+365;
        conSolUserapp.IAM_Application_Name__c = appToInsert.IAM_Application_Name__c  ;
        conSolUserapp.IAM_Subscription_Name__c = appToInsert.IAM_Application_Name__c  ;   
        conSolUserapp.IAM_Status__c = status;
        conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appToInsert.IAM_Application_Name__c).getRecordTypeId(); 
        conSolUserapp.IAM_Role__c = appToInsert.IAM_Role__c;
        System.debug('conSolUserapp... ' + conSolUserapp);
        if(appToInsert.IAM_Application_Name__c==System.Label.IAM_AppName_HighRadius){
            conSolUserapp.IAM_HR_BMS_Instance_Name__c = objBMStoSF.BMSinstance;
            conSolUserapp.IAM_HR_Customer_Number__c=HighRadiuscustomerNumber;
        }
        insert conSolUserapp;   
    }
    

    /*Method Added by Karthik for submitting approval*/
    Public void submitForApproval(id idOfRecord,String approvalProcessName){
        determineChannelAdmin();
        System.debug('Entered approval process submission'+approverLocationadmin);
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(conAppInsert.id);
        req1.setSubmitterId(UserInfo.getUserId());
        req1.setProcessDefinitionNameOrId(approvalProcessName);
        if(String.isNotEmpty(approverLocationadmin)){
            req1.setNextApproverIds(new Id[] {approverLocationadmin});    
        }else{
            req1.setNextApproverIds(new Id[] {app.IAM_Default_Approver__c}); 
        }
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);   
    }
    
    
     //get channel admin Id for particular region. Requirement for Global Dealer Portal App - @Anupam - 12/03/2021
     //Since we are taking this from the metadata we do not need this many locations. Only one is sufficient 
    public void determineChannelAdmin() {
        system.debug('inside determineChannelAdmin method--->');
        List<Account> acctDistCodeList1 = [select Id, ParentId, CSS_DistributorCode__c,IAM_Service_Provider_Code__c from account where id =:con.AccountId];
        system.debug('acctDistCodeList1--->'+acctDistCodeList1);
        if(acctDistCodeList1.size() > 0 && String.isNotBlank(acctDistCodeList1[0].CSS_DistributorCode__c)){
            //String sChannelAdminData1 = [Select WWID__c from IAM_Channel_Admin_Code__mdt where Distributor_Code__c =: acctDistCodeList1[0].CSS_DistributorCode__c].WWID__c;
            List<IAM_Channel_Admin_Code__mdt> metadatList = [Select Id, WWID__c from IAM_Channel_Admin_Code__mdt where Distributor_Code__c =: acctDistCodeList1[0].CSS_DistributorCode__c];
            //system.debug('sChannelAdminData1--->'+sChannelAdminData1);
            if(metadatList.size() > 0){
                String sChannelAdminData1 = metadatList[0].WWID__c;
                system.debug('sChannelAdminData1--->'+sChannelAdminData1);
                List<User> lstUser1 = [select id from user where FederationIdentifier =: sChannelAdminData1];
                if(lstUser1.size() > 0){
                    approverLocationadmin = lstUser1[0].Id;
                }
            }
        }
        /*else if(acctDistCodeList1.size() > 0 && String.isBlank(acctDistCodeList1[0].CSS_DistributorCode__c)){
            List<Account> acctDistCodeList2 = [select id,ParentId,IAM_Service_Provider_Code__c from account where id =: acctDistCodeList1[0].ParentId];
            if(acctDistCodeList2.size() > 0 && String.isNotBlank(acctDistCodeList2[0].IAM_Service_Provider_Code__c)){
                String sChannelAdminData2 = [Select WWID__c from IAM_Channel_Admin_Code__mdt where Distributor_Code__c =: acctDistCodeList2[0].CSS_DistributorCode__c].WWID__c;
                if(String.isNotBlank(sChannelAdminData2)){
                    List<User> lstUser2 = [select id from user where FederationIdentifier =: sChannelAdminData2];
                    if(lstUser2.size() > 0){
                        approverLocationadmin = lstUser2[0].Id;
                    }
                } 
            }
            else if(acctDistCodeList2.size() > 0 && String.isBlank(acctDistCodeList2[0].IAM_Service_Provider_Code__c)){
                List<Account> acctDistCodeList3 = [select id,ParentId,IAM_Service_Provider_Code__c from account where id =: acctDistCodeList2[0].ParentId];
                if(acctDistCodeList3.size() > 0 && String.isNotBlank(acctDistCodeList3[0].IAM_Service_Provider_Code__c)){
                    String sChannelAdminData3 = [Select WWID__c from IAM_Channel_Admin_Code__mdt where Distributor_Code__c =: acctDistCodeList3[0].IAM_Service_Provider_Code__c].WWID__c;
                    if(String.isNotBlank(sChannelAdminData3)){
                        List<User> lstUser3 = [select id from user where FederationIdentifier =: sChannelAdminData3];
                        if(lstUser3.size() > 0){
                            approverLocationadmin = lstUser3[0].Id;
                        }
                    } 
                }
                else if(acctDistCodeList3.size() > 0 && String.isBlank(acctDistCodeList3[0].IAM_Service_Provider_Code__c)){
                    List<Account> acctDistCodeList4 = [select id,ParentId,IAM_Service_Provider_Code__c from account where id =: acctDistCodeList3[0].ParentId];
                    if(acctDistCodeList4.size() > 0 && String.isNotBlank(acctDistCodeList4[0].IAM_Service_Provider_Code__c)){
                        String sChannelAdminData4 = [Select WWID__c from IAM_Channel_Admin_Code__mdt where Distributor_Code__c =: acctDistCodeList4[0].IAM_Service_Provider_Code__c].WWID__c;
                        if(String.isNotBlank(sChannelAdminData4)){
                            List<User> lstUser4 = [select id from user where FederationIdentifier =: sChannelAdminData4];
                            if(lstUser4.size() > 0){
                                approverLocationadmin = lstUser4[0].Id; 
                            }
                        } 
                    } 
                }
            }           
        }*/
        
    }

    /* Request Access - Guidanz Service Portal */
    public PageReference guiServicePortalAppRequest() {
        errorERPCustcode=null;
        errorState=null;
        errorCountry=null;
        if(String.isBlank(erpCustomerCode)||String.isBlank(acc.BillingStateCode)||String.isBlank(acc.BillingCountryCode)) {
            if(String.isBlank(erpCustomerCode))
            {
            errorERPCustcode = 'Missing Customer Code';
            errorfound = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
            }
            if(String.isBlank(acc.BillingStateCode))
            {
            errorState = 'Missing State';
            errorfound = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
            }
            if(String.isBlank(acc.BillingCountryCode))
            {
            errorCountry = 'Missing Country';
            errorfound = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
            }
            
        } else {
            List<Account> guidanzServiceAccList = [
                SELECT Id
                     , Name
                     , IAM_Service_Provider_Code__c
                     , FSL_ERP_Customer_Code__c
                	 ,FSL_ERP_Customer_Code_Split__c
                  FROM Account
                 WHERE FSL_ERP_Customer_Code_Split__c = :erpCustomerCode
                   AND CMI_Account_Status__c = :Label.IAM_Status_Active
                   AND BillingStateCode =:acc.BillingStateCode 
               	   AND BillingCountryCode=:acc.BillingCountryCode
                   AND RecordType.DeveloperName IN ('Guidanz','Guidanz_Cash') 
            ];
            if(guidanzServiceAccList.isEmpty()) {
                errorERPCustcode = Label.IAM_ERP_CustomerCode_NotPresent_Error;
            	errorfound = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));
            } else {
                /* @Suresh - Added below code for Duplicate Account check and return error*/
                if(guidanzServiceAccList.size()>1)
                {
                errorERPCustcode = Label.IAM_GSP_DuplicateAccountError;
            	errorfound = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IAM_Enter_Information));

                }
                else
                {
                createAccess(guidanzServiceAccList[0].Id);
                sumbitFlag = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, Label.IAM_Access_Request_Submitted));
                }
            }
        }
        return null;
    }
    
    /* Create Access - Guidanz Service Portal */
    public void createAccess(Id guidanzAccountId) {
        if(!lstAccApps.isEmpty()) {
            /*Create User Feature Access */
            createContactProvisionigs(lstAccApps[0], Label.IAM_Status_Pending);
        } else {
            /* Create Account Feature & Access */
            appToInsert = new IAM_Application__c();
            appToInsert.IAM_Account_Name__c = con.AccountId;
            appToInsert.IAM_Application_Name__c = app.Name;
            appToInsert.IAM_Subscription_Name__c = app.Name;
            appToInsert.IAM_Role__c = app.IAM_Default_Role__c;
            appToInsert.IAM_Status__c = 'Active';
            appToInsert.IAM_Subscription_Start_Date__c = System.today();
            appToInsert.IAM_Subscription_End_Date__c = System.today() + 36500;
            appToInsert.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(app.Name).getRecordTypeId();  
            insert appToInsert;
            /* Create User Feature & Access */
            List<IAM_Application__c> gspAppList = [
                SELECT Id
                     , IAM_Account_Name__c
                     , IAM_Application_Name__c
                     , IAM_Subscription_Name__c
                     , IAM_Role__c
                     , IAM_Status__c
                     , IAM_Free_Subscription__c
                     , IAM_Subscription_Start_Date__c 
                  FROM IAM_Application__c
                 WHERE Id = :appToInsert.Id
            ];
            if(!gspAppList.isEmpty()) {
                createContactProvisionigs(gspAppList[0], Label.IAM_Status_Pending);
            }
        }
        sendEmailToCPSTeam(con.Id, guidanzAccountId);
    }

    /* Send Email To CPS Team */
    public void sendEmailToCPSTeam(Id contactId, Id accountId) {
        EmailTemplate template = [
            SELECT Id 
             FROM EmailTemplate
            WHERE Name = 'IAM_ReqAccess_ERP_CPS'
        ];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        for(OrgWideEmailAddress owa : [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress]) {
            if(owa.Address.contains('noreply')) 
            mail.setOrgWideEmailAddressId(owa.id); 
        }
        
        String[] toaddr = new List<String> {Label.IAM_CPS_Team_Email_Address};
        mail.setTargetObjectId(contactId);
        mail.setTemplateId(template.Id);
        mail.setTreatTargetObjectAsRecipient(false); 
        mail.setWhatId(accountId);
        mail.setToAddresses(toaddr);   
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}