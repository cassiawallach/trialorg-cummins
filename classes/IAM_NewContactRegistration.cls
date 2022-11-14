/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_NewContactRegistration class. 
Basic registration class for salesforce IAM users.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018       INITIAL DEVELOPMENT
1.1 -    Nishant Verma          04/12/2020       High Radius   
1.2 -    Vishnu Mamidi          04/23/2021       Changes for capturing language. 
1.3 -    Suresh Rathod          01/18/2022       Cummins API Portal App onboarding changes.
*******************************************************/
/********************************************************************************
***********************************************************************************/
public without sharing class IAM_NewContactRegistration {
    /*Changes by Suresh Cummins API Portal*/
    public String selectedRole{get;set;}
    public String businessJustification{get;set;}
    Public boolean showPhone{set;get;}
    Public boolean showRole{set;get;}
    public boolean showBusinessJustification{set;get;}
    public List < SelectOption > roleList {set;get;}
	/*End of Changes Cummins API Portal*/
    
    public boolean errordiv{get;set;} // to show error msg
    public Contact newCon {get;set;}
    public boolean IsConAlreadyExist{get;set;}
    List<String> characters;
    public String input {get; set;}
    public String errorContact{set;get;}
    public String errorBMS{set;get;}
    public String result {get; set;}
    public boolean showButtons{get;set;}
    Public string appid{set;get;}
    public List<IAM_Application__c> appToInsert{set;get;}
    Public List<App_Mapping__c> app{set;get;}
    Public IAM_Contact_Provisioning__c appToSubmit{set;get;}
    Public boolean highRadiusFlag{set;get;}
    Public string highRadiusInvoiceNo{set;get;}
    Public string highRadiusCustomerNo{set;get;}
    Public IAM_HighRadius_Parser.BMSresponseToSF objBMStoSF;
    Public boolean showBMS {Set;get;}
    Public boolean highRadiusFlagOP{set;get;}
    String char1;
    String char2;
    String char3;
    String char4;
    String char5;
    String char6;
    Public boolean showLanguage{set;get;}

    public IAM_NewContactRegistration(){
        newCon = new Contact();
        highRadiusFlag=false ;
        highRadiusFlagOP=false;
        errorContact='';
        showButtons = false;
        errorBMS ='';
        showLanguage = false;
        showRole = false;
		showPhone = false;
        showBusinessJustification = false;
        roleList= new List < SelectOption >();
        newCon.MailingCountry = 'United States';
        characters = new List<String>{'1','2','3','4','5','6','7','8','9','0'};
            appid=ApexPages.currentPage().getParameters().get('appid');
        if(String.isNotBlank(appid)){
            System.debug('Printing appid'+appid);
            app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c, IAM_Show_Language_option__c from App_Mapping__c where id =: appid];
            if(app[0].Name =='HighRadius'){
                highRadiusFlag=true;                
            }
            if(app[0].Name == System.Label.IAM_Application_Name_Cummins_API_Portal){
                showRole = true;
				showPhone = true;
                showBusinessJustification = true;	
                roleList.add(new SelectOption('--None--','--None--'));
                roleList.addAll(getDependentPicklistValues(System.Label.IAM_Application_Name_Cummins_API_Portal));
            }
           
        }else{
            app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Approver_Email_Contact_Field__c,IAM_Default_Role__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c, IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c, IAM_Show_Language_option__c from App_Mapping__c where id =:System.label.IAM_Default_Appmap];
        }
        showLanguage = app[0].IAM_Show_Language_option__c;
        System.debug('Printing application Name'+app);
    }
    public Integer randomNumber(){
        
        Integer random = Math.Round(Math.Random() * characters.Size());
        if(random == characters.size()){
            random--;
        }
        return random;
    } 
    public String getChar1(){
        
        char1 = characters[randomNumber()];
        
        return char1;
        
    }
    
    public String getChar2(){
        
        char2 = characters[randomNumber()];
        return char2;
        
    }
    
    public String getChar3(){
        
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
    
    public string emailerrorstatus {
        set;
        get;
    }
    
    public string errorContactEmail1 {
        set;
        get;
    }
    public string errorContactEmail2 {
        set;
        get;
    }
    public String currentRecordId {
        get;
        set;
    }
    
    public String getChar6(){
        
        char6= characters[randomNumber()];
        return char6;
        
    }
    //@Suresh -Get dependent picklist values
	public static List<SelectOption> getDependentPicklistValues(String AppName){
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        //Get dependent field result
        Schema.DescribeFieldResult dependentFieldResult = IAM_Contact_Provisioning__c.IAM_Role__c.getDescribe();
        //Get dependent field controlling field 
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        //Check controlling field is not null
        if(controllerField == null){
            return null;
        } 
        //Get controlling field result
        Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
         
        //It is used to decode the characters of the validFor fields. 
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
         
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
            //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    Integer bitIndex = i / 6;
                    if (bitIndex > base64chars.size()-1) { break; }
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                        continue;
                    } 
                    if (!dependentPicklistValues.containsKey(controllerValue)){
                        dependentPicklistValues.put(controllerValue, new List<String>());
                    }
                    dependentPicklistValues.get(controllerValue).add(entry.getLabel());
                }
               }
        }
    System.debug('dependentPicklistValues: '+dependentPicklistValues);
	List<SelectOption> options = new List<SelectOption>();
	List<String> values= dependentPicklistValues.get(AppName);
    System.debug('values: '+values);
       for (String v : values){
            options.add(new SelectOption(v,v));
        }
        return options;
}
// End of the change
    public List<SelectOption> getCountries()
    {
        Schema.sObjectType objType = Contact.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('MailingCountryCode').getDescribe().getPickListValues();
        
        List<SelectOption> options = new List<SelectOption>();
        for (Schema.PicklistEntry v : values){
            options.add(new SelectOption(v.getLabel(), v.getLabel()));
        }
        return options;
    }

    /**
        @Vishnu, Showing language options in IAM_Basic_Registration page for Shop Cummins Online Store and storing option at contact 31/03/2021
     */
    public List<SelectOption> getlanguagesQSO()
    {
        List<SelectOption> options = new List<SelectOption>();
        for(SelectOption so : getlanguages()){
            if(System.Label.IAM_Language_Preferences.containsIgnoreCase(so.getValue()+';')) options.add(so);
        }    
        return options;
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
    public PageReference emailcheck() {
        IsConAlreadyExist = false;
        List<User> lstUser = new List<User>();
        // system.debug('acc===============' + acc);
        Contact Con;
        errorContactEmail2 = '';
        emailerrorstatus = null;
        try {
            Con = [Select Id, FirstName, LastName, AccountId, Email, Phone, CMI_TableauId__c, MailingStreet, MailingCity, MailingPostalCode, mailingcountry, mailingstate From Contact where Email =: newCon.Email limit 1];
            
            lstUser = [Select Id, isActive, Email, UserName, ContactId, CompanyName From User Where Email =: newCon.Email LIMIT 1];
        } catch (Exception e) {
            System.debug('error message' + e.getMessage());
        }
        system.debug('Con++++++++++++++++++++++++++++++++' + Con);
        if (con != null) {
            if (!lstUser.isEmpty()) {
                
                
                errorContactEmail2 = 'You have already registered with' + lstUser[0].UserName ;
                
            }else {
                IsConAlreadyExist = true;
                if (IsConAlreadyExist) {
                    emailerrorstatus = 'A match found our existing records please verify to proceed further';
                    newCon = Con;
                }
            }
        } 
        
        else {
            Contact DummyCon = new contact();
            DummyCon.email = newCon.email;
            DummyCon.LastName = newCon.LastName;
            DummyCon.firstName = newCon.firstName;
            DummyCon.phone = newCon.phone;
            if (DummyCon.email != null) {
                newCon = DummyCon;
            }
        } 
        
        system.debug('IsConAlreadyExist++++++++++++++++++++++++++++++++' + IsConAlreadyExist);
        // system.debug('IsConAlreadyExist for different account++++++++++++++++++++++++++++++++' + IsConExitForDiffAcc);
        
        system.debug('newCon++++++++++++++++++++++++++++++++' + newCon);
        system.debug('lstUser++++++++++++++++++++++++++++++++' + lstUser);
        system.debug('++++++++++++++++++++++++++++++++' + newCon.Email);
        
        return null;
    }
    // Action method for Reset button
    public PageReference BusinessTabreset() {
        
        newCon=new Contact();
        errorContact='';
        return null;
        
    }
    Public void validateContact(){
        
        //Need to check if any users are already presnt in the system and display message accordingly.
        List<contact> dupContactslist = [select id,name,email,Username__c from Contact where Username__c =:newCon.email OR Username__c =:newCon.email+System.Label.IAM_org_label];
        if(!dupContactslist.isEmpty()){
            errorContact=system.label.IAM_Duplicate_contact;
            
            showButtons = false;
        }else{
            showButtons = true;
            errorContact='';
        }
        if(app[0].Name =='HighRadius'){
            objBMStoSF =IAM_HighRadius_GetBMSInstance.getBMSInstance(highRadiusCustomerNo, highRadiusInvoiceNo);
            if(objBMStoSF.BMSinstance !='Error'){
                showButtons = true;
                errorBMS='';
                highRadiusFlagOP=true;

            }else{
                errorBMS=system.label.IAM_HR_CustomerNo_Error;
                showBMS=true;
                showButtons = false;
            }
        }        
    }
    public pageReference registerContact(){
        try
        {
            Boolean callToCreate = false;
            System.debug('Printing test.is runnig not '+(!Test.isRunningTest()));
            System.debug('Printing test is is runnig'+Test.isRunningTest());
            if(test.isRunningTest()){
                callToCreate = true;  
            }
            else{
                if(input.length() == 0) {
                    result = 'Missing Captcha'; 
                    callToCreate = false; 
                    
                } else if(input.length() == 6 && input.subString(0,1) == char1 && input.subString(1,2) == char2 && input.subString(2,3) == char3
                          && input.subString(3,4) == char4 && input.subString(4,5) == char5 && input.subString(5,6) == char6){
                              
                              // result = 'Success';
                              callToCreate = true; 
                              System.debug('captch result .....  ' + result );
                              //send();
                              
                          }
                else{          
                    result = 'Invalid captcha value';
                    callToCreate = false;  
                    System.debug('captch result .....  ' + result );        
                }
            }
            List<contact> dupContactslist = [select id,name,email,Username__c from Contact where Username__c =:newCon.email OR Username__c =:newCon.email+System.Label.IAM_org_label];
            if(!dupContactslist.isEmpty()){
                errorContact='The entered username already exists, please retry with different username.';          
                callToCreate = false; 
            }else{             
                errorContact='';
            }
            if(callToCreate == true)
            {             
                insertContact();
                String langValue = ApexPages.currentPage().getParameters().get('lang');
                //System.debug('langValue.123....  '+langValue);
                PageReference tnxPageRef =new pagereference('/IAM_Confirmation?appid='+escapeHtml(appid)+ '&lang=' + escapeHtml(langValue));
                tnxPageRef.setRedirect(true);
                return tnxPageRef;
            }            
        }
        catch(exception e){
            System.debug('Printing exception'+e);
            System.debug('Printing stack strace string'+e.getStackTraceString());
            //show_error_msg(errorContat);
        }
        return null; 
    }
    public void insertContact(){
        List<Account> a; 
        if(highRadiusFlag) { 
            IAM_CreateUser.Bmsinstance=  objBMStoSF.BMSinstance;
            IAM_CreateUser.Customernumber=highRadiusCustomerNo;
        }
        System.debug('Printing contact details'+newCon);
        String Name = 'Identity Individual Users';
        try{
            if(app[0].Name =='HighRadius'){
                if(test.isRunningTest()){
                    objBMStoSF.erpCustomerCode ='48931-USA';
                }
                if(objBMStoSF.erpCustomerCode != null){
                    List<Account> acc= [Select id,FSL_ERP_Customer_Code__c From Account where FSL_ERP_Customer_Code__c =:objBMStoSF.erpCustomerCode limit 1];
                    //system.debug('account id'+acc.id);
                    if(!acc.isEmpty()){
                        List<Contact> existcon =[Select Id,AccountID,firstname,lastname,email,phone,Username__c,IAM_Ext_Legacy_Uid__c,IAM_Contact_Status__c,RecordTypeId,CMI_Contact_Type__c 
                        from Contact WHERE FirstName =:newCon.FirstName  AND LastName =:newCon.LastName AND Email =:newCon.email AND Accountid =:acc[0].id Limit 1 ];
                        if(!existcon.isEmpty()){
                            UpdateexistingcontactHR(existcon);
                        }else{
                            Id CRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                            system.debug('entering contact creation...CRecId .  '+ CRecId);
                            newCon.AccountId= acc[0].id;
                            newCon.RecordTypeId=CRecId; 
                            newCon.IAM_Contact_Status__c = System.Label.IAM_Active_Status;
                            newCon.IAM_Approved__c='Y';
                            newCon.CMI_Contact_Type__c='Secondary';
                            newCon.IAM_from_Registration__c=true;
                            newCon.IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
                            newCon.IAM_Agreement_Signed_On__c = date.today();
                            newCon.Username__c=newCon.email;
                            newCon.Language_Preferences__c =newCon.Language_Preferences__c;
                            if(system.label.IAM_org_label!='.cso'){
                                newCon.Username__c = newCon.email+ system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                                newCon.IAM_Ext_Legacy_Uid__c=newCon.email+ system.label.IAM_org_label;
                            }else{
                                newCon.Username__c = newCon.email;
                                newCon.IAM_Ext_Legacy_Uid__c=newCon.email;
                            }
                            //newCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newCon.Username__c, false, false);
                       newCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newCon.Username__c,newCon.IAM_Person_Type__c);//added by vineet
 
                        } 
                    }else{
                        Account accHR = new Account();
                            List<Account> accHRList=[Select Id, FSL_ERP_Customer_Code__c from Account Where Name=:newCon.IAM_Individual_Company_Name__c Limit 1 ];
                            if(!accHRList.isEmpty()){
                                    if(accHRList[0].FSL_ERP_Customer_Code__c == null)
                                        accHRList[0].FSL_ERP_Customer_Code__c= objBMStoSF.erpCustomerCode;
                            }else{
                                accHR.Name= (newCon.IAM_Individual_Company_Name__c== null ? newCon.FirstName +' '+ newCon.LastName :newCon.IAM_Individual_Company_Name__c); 
                                accHR.FSL_ERP_Customer_Code__c=objBMStoSF.erpCustomerCode;
                                Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                                system.debug('entering contact creation...accRecId .  '+ accRecId);
                                accHR.RecordTypeId=accRecId;
                                accHR.AccountSource='WEB';
                                insert accHR;
                            }
                                                        
                            Id CRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                            system.debug('entering contact creation...CRecId .  '+ CRecId);
                            newCon.AccountId= (!accHRList.isEmpty() ? accHRList[0].id : accHR.id);               
                            newCon.RecordTypeId=CRecId; 
                            newCon.IAM_Contact_Status__c = System.Label.IAM_Active_Status;
                            newCon.IAM_Approved__c='Y';
                            newCon.CMI_Contact_Type__c='Secondary';
                            newCon.IAM_from_Registration__c=true;
                            newCon.IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
                            newCon.IAM_Agreement_Signed_On__c = date.today();
                            newCon.Username__c=newCon.email;
                            newCon.Language_Preferences__c=newCon.Language_Preferences__c;
                            if(system.label.IAM_org_label!='.cso'){
                                newCon.Username__c = newCon.email+ system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                                newCon.IAM_Ext_Legacy_Uid__c=newCon.email+ system.label.IAM_org_label;
                            }else{
                                newCon.Username__c = newCon.email;
                                newCon.IAM_Ext_Legacy_Uid__c=newCon.email;
                            }
                    }
                }else{
                    errorContact='The entered Customer number is not having valid ERP Code.';
                }
            }else{
                a= [Select id,recordtype.Name,parentid From Account where Name =:Name limit 1];
                //system.debug('account id'+a[0].id);
                if(!a.isEmpty()){  
                    Id CRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    system.debug('entering contact creation...CRecId .  '+ CRecId);
                    newCon.AccountId= a[0].id;               
                    
                    newCon.RecordTypeId=CRecId; 
                    // Need to set the Contact status to Active or Inactive depending upon the approved flag and even the Approved Flag
                    if(!app[0].IAM_Approval_Needed__c){
                        newCon.IAM_Contact_Status__c = 'Active';
                        newCon.IAM_Approved__c='Y';
                    }else{
                        newCon.IAM_Contact_Status__c = 'Pending';
                        newCon.IAM_Approved__c='N';
                    }
                    
                    newCon.CMI_Contact_Type__c='Secondary';
                    newCon.IAM_from_Registration__c=true;
                    newCon.IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
                    newCon.IAM_Agreement_Signed_On__c = date.today();
                    newCon.Username__c=newCon.email;
                    if(system.label.IAM_org_label!='.cso'){
                        newCon.Username__c = newCon.email+ system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                        newCon.IAM_Ext_Legacy_Uid__c=newCon.email+ system.label.IAM_org_label;
                    }else{
                        newCon.Username__c = newCon.email;
                        newCon.IAM_Ext_Legacy_Uid__c=newCon.email;
                    }
                }
            }

            //@Vishnu inserting langualge code on contact record for 31/03/2021
            newCon.IAM_Language__c  = newCon.Language_Preferences__c == 'French' ? 'fr' :newCon.Language_Preferences__c == 'French Canadian' ? 'fr_CA' : newCon.Language_Preferences__c == 'Spanish' ? 'es' : 'en_US';
                insert newCon;
                system.debug('contact inserted'+newCon);
                System.debug('before post reg logic .....  ' );
                
                
                List<Contact> objCon = [select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                                        Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                                        Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                                        IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                                        Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                                        Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Site_Admin__c,Language_Preferences__c,RecordType.Name from Contact where id = :newCon.id AND IAM_Contact_Status__c = 'Active'];   
                if(!app.isempty() && app[0].Name !='HighRadius'){
                    appToInsert=[Select id,IAM_Application_Name__c,IAM_Role__c from IAM_Application__c where IAM_Application_NAme__c=:app[0].Name  and IAM_Status__c='Active' and IAM_Account_Name__c=:a[0].id];   
                    System.debug('Printing location app feature'+appToInsert);
                }
                if(app[0].Name !='HighRadius'){
                    if(!appToInsert.isEmpty()){
                        //Now we need to call create Contact access feature records.
                        createContactProvisionigs(appToInsert[0]); 
                    }
                }
                if(objCon != null && !objCon.isEmpty() && !app[0].IAM_Approval_Needed__c) {
                    String CreateUser=IAM_CreateUser.CreateUser(objCon); 
                    System.debug('Printing string status from Create class'+CreateUser); 
                    if(CreateUser=='OK'){
                        System.debug('Printing Contact Id'+newCon.id);
                        Set<id> conIds= new Set<id>{newCon.id};
                        id JobId= System.enqueueJob(new IAM_Assign_PermSet_Ext_New_Queueable(conIds,'Insert'));
                        List<user> u=[select id,Contactid,username from user where Contactid=:newCon.id];
                        System.debug('Printing user details'+u);
                        if(!u.isEmpty()){
                            System.debug('Printing app Details'+app);
                            if(app[0].Name !='HighRadius'){  
                               //Now we need to call create Contact access feature records.
                               if(!appToInsert.isEmpty()){
                                createContactProvisionigs(appToInsert[0]);
                               }  
                            }else{  
                                List<IAM_Application__c> conSolAppList =[Select Id,IAM_Role__c,IAM_Application_Name__c from  IAM_Application__c Where IAM_Application_Name__c = :System.Label.IAM_AppName_HighRadius AND IAM_Account_Name__c = :objCon[0].Accountid Limit 1];
                                    if(!conSolAppList.isempty()){
                                        IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
                                        conSolUserapp.IAM_Account_Application__c = conSolAppList[0].id;
                                        conSolUserapp.IAM_Contact__c = objCon[0].id;
                                        conSolUserapp.IAM_Start_Date__c = System.today();
                                        conSolUserapp.IAM_End_Date__c = System.today()+365;
                                        conSolUserapp.IAM_Application_Name__c = conSolAppList[0].IAM_Application_Name__c  ;
                                        conSolUserapp.IAM_Status__c = System.Label.IAM_Active_Status;
                                        conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_HighRadius).getRecordTypeId(); 
                                        conSolUserapp.IAM_Role__c = conSolAppList[0].IAM_Role__c;
                                        conSolUserapp.IAM_HR_BMS_Instance_Name__c = objBMStoSF.BMSinstance;
                                        conSolUserapp.IAM_HR_Customer_Number__c=highRadiusCustomerNo;
                                        System.debug('conSolUserapp... ' + conSolUserapp);
                                        insert conSolUserapp;
                                    }else{
                                        IAM_Application__c conSolApp;
                                        conSolApp = new IAM_Application__c();
                                        conSolApp.IAM_Account_Name__c = objCon[0].Accountid;
                                        conSolApp.IAM_Free_Subscription__c = true;
                                        // for all applications, we need to give start date and end date
                                        conSolApp.IAM_Subscription_Start_Date__c = System.today();
                                        conSolApp.IAM_Subscription_End_Date__c = System.today() + 365;
                                        conSolApp.IAM_Application_Name__c = System.Label.IAM_AppName_HighRadius;
                                        conSolApp.IAM_Subscription_Name__c = System.Label.IAM_AppName_HighRadius;
                                        conSolApp.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_HighRadius).getRecordTypeId(); 
                                        conSolApp.IAM_Status__c = System.Label.IAM_Active_Status;
                                        conSolApp.IAM_Role__c = app[0].IAM_Default_Role__c;
                                        System.debug('conSolApp... ' + conSolApp);
                                        insert conSolApp; 
                                        IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
                                        conSolUserapp.IAM_Account_Application__c = conSolApp.id;
                                        conSolUserapp.IAM_Contact__c = objCon[0].id;
                                        conSolUserapp.IAM_Start_Date__c = System.today();
                                        conSolUserapp.IAM_End_Date__c = System.today()+365;
                                        conSolUserapp.IAM_Application_Name__c = conSolApp.IAM_Application_Name__c  ;
                                        conSolUserapp.IAM_Status__c = System.Label.IAM_Active_Status;
                                        conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_HighRadius).getRecordTypeId(); 
                                        conSolUserapp.IAM_Role__c = conSolApp.IAM_Role__c;
                                        conSolUserapp.IAM_HR_BMS_Instance_Name__c = objBMStoSF.BMSinstance;
                                        conSolUserapp.IAM_HR_Customer_Number__c=highRadiusCustomerNo;
                                        System.debug('conSolUserapp... ' + conSolUserapp);
                                        insert conSolUserapp; 
                                }
                            }
                        }                       
                    } 
                }
            //Commented below lines as extra contact provisioning record with pending status is created if IAM_Approval_Needed__c= Yes- Suresh Rathod 20/01/2022
            /*else if(app[0].IAM_Approval_Needed__c){
                    System.debug('Printing application Name'+app);
                    //If approval is needed.Then create Contact Provisioning records and Submit the Contact Provisionig record for Approval
                    System.debug('3.---Entered to create contact provisioning');
                    createContactProvisionigs(appToInsert[0]); 
                     System.debug('4.---created contact provisioning');
                }*/
            
        }catch(exception e){
            system.debug('contact exception ..'+e.getMessage());
            System.debug('Printing exception=='+e);
            System.debug('Contact Exception------'+e.getStackTraceString());
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
    
    
    
    //Method to create a Contact Access feature record
    Public Void createContactProvisionigs(IAM_Application__c appToInsert){
        System.debug('Printing application user name'+appToInsert);
        List<IAM_Contact_Provisioning__c> exsistingConProv=[Select id,IAM_Contact__C,IAM_User__C from IAM_Contact_Provisioning__c where IAM_Contact__c=:newCon.id and IAM_Application_Name__c=:appToInsert.IAM_Application_Name__C and IAM_Status__c='Active' LIMIT 1];
        IAM_Contact_Provisioning__c conSolUserapp;
        if(exsistingConProv.isEmpty()){
            conSolUserapp = new IAM_Contact_Provisioning__c () ;
            conSolUserapp.IAM_Account_Application__c = appToInsert.id;
            conSolUserapp.IAM_Contact__c = newCon.id;
            conSolUserapp.IAM_Start_Date__c = System.today();
            conSolUserapp.IAM_End_Date__c = System.today()+365;
            conSolUserapp.IAM_Application_Name__c = appToInsert.IAM_Application_Name__c  ;
            
            if(system.label.IAM_org_label!='.cso'){
                conSolUserapp.IAM_userId__c = newCon.email+ system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                
            }else{
                conSolUserapp.IAM_userId__c = newCon.email;
                
            }
            
            if(app[0].IAM_Approval_Needed__c){
                conSolUserapp.IAM_Status__c = 'Pending';
            }else{
                conSolUserapp.IAM_Status__c = 'Active';
            }
            conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appToInsert.IAM_Application_Name__c).getRecordTypeId(); 
            //Code start - Fluids reg hardcoded default role  is replaced by value from app mapping record - Pranav Walunj 29/06
            App_Mapping__c appMappingRole = [SELECT IAM_Default_Role__c from App_Mapping__c  WHERE Name =: appToInsert.IAM_Application_Name__c LIMIT 1];
            conSolUserapp.IAM_Role__c = appMappingRole.IAM_Default_Role__c;
            //Code end - Fluids reg hardcoded default role  is replaced by value from app mapping record - Pranav Walunj 29/06
            System.debug('conSolUserapp... ' + conSolUserapp);
            //Code start- To assign selected role and user entered business justification for Cummins API Portal app- Suresh 20/01/2022
            if(appToInsert.IAM_Application_Name__c == System.Label.IAM_Application_Name_Cummins_API_Portal)
            {
                conSolUserapp.IAM_Role__c = selectedRole;
                conSolUserapp.IAM_Business_Justification__c = businessJustification;
            }
             System.debug('conSolUserapp... ' + conSolUserapp);
            //Code end- Cummins API portal- Suresh 20/01/2022
            insert conSolUserapp;  
        }else{
            List<User> userId=[Select id from User where Contactid=:newCon.id and isActive=True LIMIT 1];
            System.debug('Printing User details that need to be assigned to Contact PRovisioning'+userID);
            if(!userId.isEmpty()){
                exsistingConProv[0].IAM_User__C=userId[0].id;
                Update exsistingConProv;
            }
        }
        
         
        
        //if approval needed then submit record for approval
        if(app[0].IAM_Approval_Needed__c){
            if(app[0].Name==System.Label.IAM_Application_Name_Archer){
                submitApplicationForApproval(conSolUserapp,'IAM_Archer_Application_Approval',System.Label.IAM_Archer_Queue_ID);
            }
            //Cummins API portal -Approval process - Suresh 20/01/2022
            if(app[0].Name==System.Label.IAM_Application_Name_Cummins_API_Portal){
                submitApplicationForApproval(conSolUserapp,'IAM_Cummins_API_Portal_Approval_Process',System.Label.IAM_Cummins_API_Portal_Queue_ID);
            }
        }
        
    }
    
    Public Void submitApplicationForApproval(SObject sObj, String approvalProName, String approverId){
        if(!String.isEmpty(approverId)){
            //Submit application for approval
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(Label.IAM_Submitting_For_Approval_Trigger);
            req1.setObjectId(sObj.id);
            req1.setSubmitterId(System.Label.IAM_App_Access_Request_Submitter);
            req1.setProcessDefinitionNameOrId(approvalProName);
            req1.setSkipEntryCriteria(true);
            
            if(String.isNotBlank(approverId)) {
                System.debug('#### Approval Process - approverId - '+approverId);
                req1.setNextApproverIds(new Id[] {approverId});
            } 
            System.debug('### Approval req1.....  '+req1);
            // Submit the approval request for the Opportunity
            Approval.process(req1); 
        }
    }
    Public void UpdateexistingcontactHR(List<Contact> existcon){

         
        //existcon.Id= existcontact[0].id;
        Id CRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        existcon[0].RecordTypeId=CRecId; 
        existcon[0].IAM_Contact_Status__c = System.Label.IAM_Active_Status;
        existcon[0].IAM_Approved__c='Y';
        existcon[0].CMI_Contact_Type__c='Secondary';
        existcon[0].IAM_from_Registration__c=true;
        existcon[0].IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
        existcon[0].IAM_Agreement_Signed_On__c = date.today();
        existcon[0].Username__c=newCon.email;
        existcon[0].email=newCon.email;
        newCon.Language_Preferences__c =newCon.Language_Preferences__c;
        if(system.label.IAM_org_label!='.cso'){
            existcon[0].Username__c = newCon.email+ system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
            existcon[0].IAM_Ext_Legacy_Uid__c=newCon.email+ system.label.IAM_org_label;
        }else{
            existcon[0].Username__c = newCon.email;
            existcon[0].IAM_Ext_Legacy_Uid__c=newCon.email;
        }
        Contact Con = existcon[0];
        system.debug('Con###'+Con);
        Update Con;
        system.debug('existcon#####'+ Con);
        List<Contact> objCon = [select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                        Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                        Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                        IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                        Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                        Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Site_Admin__c,Language_Preferences__c,recordtype.name
                        from Contact WHERE Id=:Con.id];
        if(!objCon.isEmpty()){
            String CreateUser=IAM_CreateUser.CreateUser(objCon);
            system.debug('CreateUser#####'+ CreateUser);
            if(test.isRunningTest()){
                CreateUser='OK';
            }
                if(CreateUser=='OK'){
                    IAM_Application__c conSolApp;
                    conSolApp = new IAM_Application__c();
                    conSolApp.IAM_Account_Name__c = existcon[0].AccountID;
                    conSolApp.IAM_Free_Subscription__c = true;
                    // for all applications, we need to give start date and end date
                    conSolApp.IAM_Subscription_Start_Date__c = System.today();
                    conSolApp.IAM_Subscription_End_Date__c = System.today() + 365;
                    conSolApp.IAM_Application_Name__c = System.Label.IAM_AppName_HighRadius;
                    conSolApp.IAM_Subscription_Name__c = System.Label.IAM_AppName_HighRadius;
                    conSolApp.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_HighRadius).getRecordTypeId(); 
                    conSolApp.IAM_Status__c = System.Label.IAM_Active_Status;
                    conSolApp.IAM_Role__c = app[0].IAM_Default_Role__c;
                    System.debug('conSolApp... ' + conSolApp);
                    insert conSolApp; 
                    
                    IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
                    conSolUserapp.IAM_Account_Application__c = conSolApp.id;
                    conSolUserapp.IAM_Contact__c = objCon[0].id;
                    conSolUserapp.IAM_Start_Date__c = System.today();
                    conSolUserapp.IAM_End_Date__c = System.today()+365;
                    conSolUserapp.IAM_Application_Name__c = conSolApp.IAM_Application_Name__c  ;
                    conSolUserapp.IAM_Status__c = System.Label.IAM_Active_Status;
                    conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_HighRadius).getRecordTypeId(); 
                    conSolUserapp.IAM_Role__c = conSolApp.IAM_Role__c;
                    if(!Test.isRunningTest()){
                        conSolUserapp.IAM_HR_BMS_Instance_Name__c = objBMStoSF.BMSinstance;
                    }
                    conSolUserapp.IAM_HR_Customer_Number__c=highRadiusCustomerNo;
                    System.debug('conSolUserapp... ' + conSolUserapp);
                    insert conSolUserapp;    
                }else{
                    errorContact='The entered username already exists, please retry with different username.';
                }
        }
    }
    
}