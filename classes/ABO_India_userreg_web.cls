global class ABO_India_userreg_web{
    Global String encrypt;
    public Contact newCon{get;set;}
    Public Account acc{get;set;}
    public List<Contact> conId{set; get;}
    // public List<Object> countryLst{set; get;}
    public List<User> lstUser{set; get;}
    public List<SelectOption> countries{get;set;}
    public List<SelectOption> states {get;set;}
    public List<SelectOption> Districts {get;set;}
    public List<SelectOption> Cities {get;set;}
    public Boolean isActivate{get; set;}
    public Boolean isDeActivate{get; set;}
    public Boolean ins {set; get;}
    public Boolean upd {set; get;}
    public String OTP1{get;set;}
    public String OTP{get;set;}
    public Boolean maxLengthIndia{get;set;}
    public String uId{get;set;}
    public String errorAddress{set;get;}
    public String errorDistrict{set;get;}
    public String errorCity{set;get;}
    public String errorContactFirstName{set;get;}
    public String errorContactLastName{set;get;}
    public String errorContactEmail{set;get;}
    public String errorContactEmail1{set;get;}
    public String errorContactEmail2{set;get;}
    public String errorContactPhone{set;get;}
    public String errorStateerror{set;get;}
    public String errorStateCountry{set;get;}
    public String errorMobilePhone{set;get;}
    public String errorPostalcode{set;get;}
    public String errrorotp{get;set;}
    public String err{get;set;}
    public String ziperr{get;set;}
    public String errorCustomerName{get;set;}
    public String otpstatus{get;set;}
    public String sourceID{get;set;}
    public String country{get;set;}
    public String errorCumminsValidEmail{get; set;}
    public String a;
    public String mobchk {get;set;}
    private final ApexPages.StandardController controller;
    public ABO_India_userreg_web(ApexPages.StandardController controller) {
        this.controller= controller;
        acc=new Account();
        newCon=new Contact();
        ins = false;
        upd = false;
        maxLengthIndia=true;
        getStates();
        getDistricts();
        getCities();
                //Source ID is used to display the fields based on the value.
        sourceID = System.currentPageReference().getParameters().get('sid');
        if(sourceID==NULL || sourceID=='')
        sourceID = 'BLANK';
        sourceID = sourceID.toUpperCase();
        if(ApexPages.currentPage().getParameters().get('userId') != null && ApexPages.currentPage().getParameters().get('userId') != '') {
            String userId = ApexPages.currentPage().getParameters().get('userId');
            if(userId != null) {
                lstUser = [Select Id, isActive, Email, ContactId, CompanyName From User Where Id =: userId LIMIT 1];
                uId = lstUser[0].Id;
                if(lstUser.size() > 0) {
                    conId = [Select Id, Email, AccountId FROM Contact Where Id =: lstUser[0].ContactId];
                    if(lstUser[0].isActive == true){
                        isDeActivate = true;
                    } else {
                        isActivate = true;
                    }
                }
                if(conId.size() > 0) {
                    newCon = [Select Id,FirstName ,LastName ,Email,Phone,MailingStreet,MailingCity,MailingPostalCode,
                    mailingcountry,mailingstate,Customer_Name__c,District_ABO__c From Contact Where Id =: conId[0].Id];
                    System.debug('postalcode'+newCon.MailingPostalCode+'country'+newCon.Phone);
                    acc = [Select Id,Name,BillingStreet,BillingCity,BillingPostalCode,billingcountry, billingstate FROM Account Where Id =: conId[0].AccountId];
                    upd = true;
                    ins = false;
                }
            }
        }
        if(!upd) {
            ins = true;
            upd = false;
        }
        countries=getCountries();
    }
    public void actUpdate() {
        if(lstUser[0].isActive == true){
            lstUser[0].isActive = false;
        } else {
            lstUser[0].isActive = true;
        }
        update lstUser[0];
    }
    public String getURL() {
        String URL = ApexPages.CurrentPage().GetURL();
        return URL.substring(0,URL.indexOf('?'));
    }
    public PageReference SendEmail() {
        OTP1 = null;
        errrorotp='';
        mobchk = '';
        err ='';
        otpstatus ='';
        errorContactEmail2 ='';
        String phregx = '[0-9]{10}';
        Pattern MyPattern = Pattern.compile(phregx );
        Matcher MyMatcher = MyPattern.matcher(newCon.phone);
        if (!MyMatcher.matches()||newCon.phone.length()<10)
        {
            mobchk = 'Invalid Mobile Number';
        } else {
            if(!test.isrunningtest())
            {
                ABO_OTPGeneration otpgen1 = new ABO_OTPGeneration();
                OTP =otpgen1.web_generateOTP(newCon.email);
                ABO_SeibelWebservice.SendSMS(newCon.phone,'Your Validation Code is '+OTP);
            } else {
                OTP = '123456';
            }
            System.debug('Calling webservice from Ctrl with input phone number '+newCon.phone);
            if(OTP !=Null)
            {
                otpstatus = 'A Validation Code has been sent to your mobile and email';
            }
            system.debug('####################################'+OTP );
        }
        return null;
    }
    public PageReference emailcheck() {
        Contact Con;
        otpstatus = '';
        errorContactEmail2 ='';
        try {
            Con = [Select Id,FirstName ,LastName ,Email,Phone,CMI_TableauId__c,MailingStreet,MailingCity,MailingPostalCode, mailingcountry,mailingstate From Contact where Email=:newCon.Email limit 1];
        }
        catch(Exception e)
        {
        }
        if(con!=null)
        {
            errorContactEmail2 = 'Email already registered';
        }
        system.debug('++++++++++++++++++++++++++++++++'+newCon.Email);
        return null;
    }
    public List<SelectOption> getCountries() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));
        options.add(new SelectOption('India','India'));
        options.add(new SelectOption('Nepal','Nepal'));
        options.add(new SelectOption('Bhutan','Bhutan'));
       
        return options;
    }
    public void getStates() {
        system.debug('========'+newcon.mailingcountry);
        states= new List<SelectOption>();
        states.add(new SelectOption('None','--- None ---'));
         if(newCon.mailingcountry=='India')
        {
            States.add(new SelectOption('Andaman & Nicobar Islands','Andaman & Nicobar Islands'));
            States.add(new SelectOption('Andhra Pradesh','Andhra Pradesh'));
            States.add(new SelectOption('Arunachal Pradesh','Arunachal Pradesh'));
            States.add(new SelectOption('Assam','Assam'));
            States.add(new SelectOption('Bihar','Bihar'));
            States.add(new SelectOption('Chandigarh','Chandigarh'));
            States.add(new SelectOption('Chattisgarh','Chattisgarh'));
            States.add(new SelectOption('Dadra & Nagar Haveli','Dadra & Nagar Haveli'));
            States.add(new SelectOption('Delhi','Delhi'));
            States.add(new SelectOption('Goa','Goa'));
            States.add(new SelectOption('Gujarat','Gujarat'));
            States.add(new SelectOption('Haryana','Haryana'));
            States.add(new SelectOption('Himachal Pradesh','Himachal Pradesh'));
            States.add(new SelectOption('Jammu & Kashmir','Jammu & Kashmir'));
            States.add(new SelectOption('Jharkhand','Jharkhand'));
            States.add(new SelectOption('Karnataka','Karnataka'));
            States.add(new SelectOption('Kerala','Kerala'));
            States.add(new SelectOption('Lakshadweep','Lakshadweep'));
            States.add(new SelectOption('Madhya Pradesh','Madhya Pradesh'));
            States.add(new SelectOption('Maharashtra','Mahasrashtra'));
            States.add(new SelectOption('Manipur','Manipur'));
            States.add(new SelectOption('Meghalaya','Meghalaya'));
            States.add(new SelectOption('Mizoram','Mizoram'));
            States.add(new SelectOption('Nagaland','Nagaland'));
            States.add(new SelectOption('Odisha','Odisha'));
            States.add(new SelectOption('Pondicherry','Pondicherry'));
            States.add(new SelectOption('Punjab','Punjab'));
            States.add(new SelectOption('Rajasthan','Rajasthan'));
            States.add(new SelectOption('Sikkim','Sikkim'));
            States.add(new SelectOption('Tamil Nadu','Tamil Nadu'));
            States.add(new SelectOption('Telangana','Telangana'));
            States.add(new SelectOption('Tripura','Tripura'));
            States.add(new SelectOption('Uttar Pradesh','Uttar Pradesh'));
            States.add(new SelectOption('Uttarakhand','Uttarakhand'));
            States.add(new SelectOption('West Bengal','West Bengal'));
        }
        if(newCon.mailingcountry=='Nepal')
        {
            system.debug('====options===='+states);
            States.add(new SelectOption('Nepal','Nepal'));
        }
        if(newCon.mailingcountry=='Bhutan')
        {
            States.add(new SelectOption('Bhutan','Bhutan'));
        }
        system.debug('====options===='+states);
      
        newCon.mailingstate = null;
        newCon.District_ABO__c=null;
        newcon.mailingcity=null;
        
    }
    public void getDistricts() {
        system.debug('========'+newcon.mailingstate);
        Districts = new List<SelectOption>();
        Districts.add(new SelectOption('None','--- None ---'));
        if(newCon.mailingstate != 'None' && newCon.mailingstate != null )
            { List<Object> Districtlst;
            if(!test.isrunningtest() && true)
            {
                ABO_Azure_Service gt = new ABO_Azure_Service();
                Districtlst=gt.getDistricts(newCon.mailingCountry,newCon.mailingstate);
            } else {
                String jsonstr ='[{"OutputData":"Prakasam"},{"OutputData":"Guntur"},{"OutputData":"Krishna"}]';
                Districtlst=(List<Object>) JSON.deserializeUntyped(jsonstr);
            }
            for(Object obj:Districtlst)
            {
                Map<String,Object> reqReportWrpr=(Map<String,Object>) obj;
                Districts.add(new SelectOption(String.valueOf(reqReportWrpr.get('OutputData')),String.valueOf(reqReportWrpr.get('OutputData'))));
            }
        }
        newCon.District_ABO__c=null;
        newcon.mailingcity=null;
    }
    public void getCities() {
        system.debug('========'+newCon.District_ABO__c);
        Cities = new List<SelectOption>();
        Cities.add(new SelectOption('None','--- None ---'));
        if(newCon.District_ABO__c != 'None' && newCon.District_ABO__c != null )
        {
            List<Object> Citylst;
            if(!test.isrunningtest() && true)
            {
                ABO_Azure_Service gt = new ABO_Azure_Service();
                Citylst=gt.getCity(newCon.mailingCountry,newCon.mailingstate,newCon.District_ABO__c );
            } else {
                String jsonstr ='[{"OutputData":"Ongole"},{"OutputData":"Guntur"},{"OutputData":"Vijayawada"}]';
                Citylst=(List<Object>) JSON.deserializeUntyped(jsonstr);
            }
            for(Object obj:Citylst)
            {
                Map<String,Object> reqReportWrpr=(Map<String,Object>) obj;
                Cities.add(new SelectOption(String.valueOf(reqReportWrpr.get('OutputData')),String.valueOf(reqReportWrpr.get('OutputData'))));
            }
        }
    }
    public PageReference reset() {
        acc=new Account();
        newCon=new Contact();
        //user u=new user();
        PageReference pageRef = new PageReference(getURL());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pagereference send(){
        system.debug('test==');
        String strteleService='';
        Boolean errofound = false;
    Contact Con;
        errrorotp='';
        errorAddress='';
        errorCity='';
        errorCumminsValidEmail = '';
        errorContactFirstName='';
        errorContactLastName='';
        errorContactEmail='';
        errorContactEmail1='';
        errorContactEmail2 ='';
        errorContactPhone='';
        errorStateerror='';
        errorStateCountry='';
        errorPostalcode='';
        errorDistrict='';
        errorMobilePhone='';
        err='';
        ziperr = '';
        errorCustomerName = '';
        if(newCon.FirstName == '' ||newCon.FirstName == Null ){
            errorContactFirstName='Missing First Name';
            errofound = true;
        }
        if(newCon.LastName == '' ||newCon.LastName == Null ){
            errorContactLastName='Missing Last Name';
            errofound = true;
        }
        if(newCon.Email == ''||newCon.Email == Null ){
            errorContactEmail='Missing Email';
            errofound = true;
        } else if(newCon.Email!=null && newCon.Email.contains('@') ){
            list<String > lstMail=newCon.Email.split('@');
            if(lstMail==null || lstMail.size()!=2 || !lstMail[1].contains('.') || lstMail[0].contains(',') || lstMail[1].contains(',')){
                errorContactEmail='Invalid Email';
                errofound = true;
            }
        } else {
            errorContactEmail='Invalid Email';
            errofound = true;
        }
    
     try {
        
            Con = [Select Id,FirstName ,LastName ,Email,Phone,CMI_TableauId__c,MailingStreet,MailingCity,MailingPostalCode, mailingcountry,mailingstate From Contact where Email=:newCon.Email limit 1];
        }
        
        catch(Exception e)
        {
        }
       
        if(con!=null)
        {
            errorContactEmail2 = 'Email already registered';
            errofound = true;
        system.debug('!!!!!!!!!!!!!!!!!!!!!'+con);
    
        }
        if(newCon.phone == '' ||newCon.phone == Null ){
            errorContactPhone='Missing Mobile Number';
            errofound = true;
        }
        if(newCon.Customer_Name__c==''||newCon.Customer_Name__c==NULL)
        {
            errorCustomerName='Missing Customer Name';
            errofound=true;
        }
        if(newCon.MailingStreet == '' ||newCon.MailingStreet == Null ){
            errorAddress='Missing Address';
            errofound = true;
        }
        if(newCon.mailingcity == 'None' ||newCon.mailingcity == Null ){
            errorCity='Missing City';
            errofound = true;
        }
        if(newCon.District_ABO__c == 'None' ||newCon.District_ABO__c == Null ){
            errorDistrict='Missing District';
            errofound = true;
        }
        if(newCon.mailingcountry =='None'){
            errorStateCountry='Missing Country';
            errofound = true;
        }
        if(newCon.mailingstate == 'None' ||newCon.mailingstate == Null ){
            errorStateerror='Missing State';
            errofound = true;
        }
        if(newCon.MailingPostalCode == '' ||newCon.MailingPostalCode == Null ){
            errorPostalcode='Missing Pin Code';
            errofound = true;
        }
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+newCon.mailingcountry);
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+newCon.MailingPostalCode);
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++'+OTP1) ;
        if(OTP1==''||OTP1==Null)
        {
            err = 'Missing Validation Code';
            errofound = true;
        } else if(OTP != OTP1) {
            errrorotp = 'Invalid Validation Code';
            errofound = true;
        }
        if(newCon.mailingcountry == 'India' && newCon.MailingPostalCode.length() < 6)
        {
            ziperr = 'Please Enter 6 digit postal code';
            errofound=true;
        }
        else if((newCon.mailingcountry == 'Bhutan' || newCon.mailingcountry == 'Nepal') && newCon.MailingPostalCode.length()<5)
        {
            ziperr = 'Please Enter 5 digit postal code';
            errofound=true;
        }
        if(errofound == true){
            return null;
        } else {
            try{
                Savepoint sp = Database.setSavepoint();
                try{
                    /* Check to make sure that user is there in present accounts or not*/
                    profile objProfile=[select id from profile where name='EIDM_Community_India' limit 1];
                    acc.Name=newCon.FirstName+ ' '+newCon.LastName;
                    system.debug(':::::+account name is last and first'+acc.name);
                    Id recId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    list<account> Accname=[select id,name from account where RecordTypeId=:recId1 AND name=:acc.name LIMIT 1];
                    system.debug('Accname details'+Accname);
                    if(Accname.isEmpty())
                    {
                        System.debug('if name is not found then details of same company');
                        user u1= [select username from user where id='00561000000rPnZ'];
                        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                        System.debug('Record Id is'+recId);
                        acc.OwnerId='00561000000rPnZ';
                        acc.RecordTypeId=recId;
                        acc.CMI_CId__c=OTP1;
                        insert acc;
                        system.debug('Printing details'+acc);
                        newCon.AccountId= acc.Id;
                        Id ConrecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Cummins India Contacts').getRecordTypeId();
                        System.debug('Contact Record Id is'+ConrecId);
                        newCon.RecordTypeId=ConrecId;
                        insert newCon;
                    } else if(!Accname.isEmpty() && newCon.id==null) {
                        System.debug('Accname ID is====='+Accname[0].Id);
                        newCon.AccountId= Accname[0].Id;
                        Id ConrecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Cummins India Contacts').getRecordTypeId();
                        System.debug('Contact Record Id is'+ConrecId);
                        newCon.RecordTypeId=ConrecId;
                        insert newCon;
                    } else {
                        System.debug('Acc name is'+acc.name);
                        update acc;
                        newCon.AccountId=acc.Id;
                        update newCon;
                    }
                    String name =UserInfo.getFirstName()+' '+UserInfo.getLastName();
                    user u=new user();
                    u.email=newCon.email;
                    if(system.label.css_org!='.cso'){
                        u.Username=newCon.email+system.label.css_org;
                        }
                       else{
                           u.Username=newCon.email;
                           }
                    u.firstName=newCon.FirstName;
                    u.LastName=newCon.LastName;
                    u.Phone = newCon.phone;
                    u.Street = newCon.MailingStreet;
                    u.Country=newCon.mailingcountry;
                    u.State=newCon.mailingstate;
                    u.City = newcon.mailingcity;
                    u.Customer_Name__c = newcon.Customer_Name__c;
                    u.District__c = newCon.District_ABO__c;
                    u.PostalCode =newCon.MailingPostalCode;
                    if(newCon.LastName.length()>=4){
                        U.alias=newCon.FirstName.substring(0,1)+''+newCon.LastName.substring(0,4);
                    } else if(newCon.LastName.length()<=2&&newCon.FirstName.length()<=2) {
                        U.alias=newCon.FirstName+''+newCon.LastName;
                    } else {
                        U.alias=newCon.FirstName.substring(0,4-newCon.LastName.length())+''+newCon.LastName;
                    }
                    u.profileId=objProfile.id;
                    u.ContactId =newCon.id;
                    u.CommunityNickname=newCon.CMI_TableauId__c;
                    u.LanguageLocaleKey='en_US';
                    u.CompanyName=acc.Name;
                    u.EmailEncodingKey='ISO-8859-1';
                    u.LocaleSidKey='en_US';
                    u.TimeZoneSidKey='America/Los_Angeles';
                    //u.Admin_User_Name__c=Name;
                    try{
                        System.debug('upd=========='+upd);
                        if(upd) {
                            System.debug('::::user Id'+lstUser[0].Id+'::::accountId'+acc.Id+'::::account Id'+newCon.Id);
                            UserUpd(lstUser[0].Id, acc.Id, newCon.Id);
                            System.debug('update done*********');
                        } else if((u.id!=null||u.id!='') && ins) {
                            System.debug('Insert done*********');
                            insert u;
                            System.debug('user id send to password'+u.id);
                            doResetPassword(u.id);
                        }
                    } catch(exception e) {
                        sendmailToAdmin(newCon,e.getMessage());
                    }
                } catch(exception e) {
                    system.debug('error message===='+e);
                    Database.rollback(sp);
                    acc= acc.clone(false);
                    return null;
                }
                pagereference ref = Page.ABO_web_userreg_confirmation;
                ref.setRedirect(true);
                return ref;
            } catch(DMLException ex) {
                ApexPages.addMessages(ex);
            }
            return null;
        }
    }
    public PageReference back() {
        PageReference p = new PageReference('/ABO_web_userreg_confirmation');
        p.setredirect(true);
        return p;
    }
    //Class for email to Administrator
    public static void sendmailToAdmin(contact lstCon,String e){
        user u=[select Email from user where profile.name='System Administrator' limit 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {u.Email};
        String[] ccAddresses = new String[] {'oh611@cummins.com'};
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Salesforce Support');
        e=e.replace('<br>',' ');
        mail.setSubject('user not created because'+e);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody('User Details:<br/><b> FirstName:</b>' + lstCon.FirstName +' <br/><b>LastName:</b>'+lstCon.LastName+' </b><br/><b>MailId:</b>'+lstCon.email+' <br/><b>UserName:</b>'+lstCon.email+
        '<br/><br/><br/> Thanks,<br/> Salesforce');
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    @future
    public Static void UserUpd(Id uid, Id accId, Id newConId) {
        User u = [Select Id FROM User Where Id =: uid];
        Contact newCon1 = [Select Id,Customer_Name__c,FirstName ,LastName ,Email,Phone,CMI_TableauId__c,MailingStreet,MailingCity,MailingPostalCode, mailingcountry,mailingstate From Contact Where Id =: newConId];
        Account acc1 = [Select Id,Name,BillingStreet,BillingCity,BillingPostalCode,billingcountry, billingstate FROM Account Where Id =: accId];
        try{
            String name =UserInfo.getFirstName()+' '+UserInfo.getLastName();
            u.email=newCon1.email;
           if(system.label.css_org!='.cso'){
                        u.Username=newCon1.email+system.label.css_org;
                        }
                       else{
                           u.Username=newCon1.email;
                           }
            u.firstName=newCon1.FirstName;
            u.LastName=newCon1.LastName;
            if(newCon1.LastName.length()>=4){
                U.alias=newCon1.FirstName.substring(0,1)+''+newCon1.LastName.substring(0,4);
            } else if (newCon1.LastName.length()<=2&&newCon1.FirstName.length()<=2){
                U.alias=newCon1.FirstName+''+newCon1.LastName;
            } else {
                U.alias=newCon1.FirstName.substring(0,4-newCon1.LastName.length())+''+newCon1.LastName;
            }
            u.CommunityNickname=newCon1.CMI_TableauId__c;
            u.CompanyName=acc1.Name;
            //u.Admin_User_Name__c=Name;
            Update u;
        }catch(exception e){
            //nothing
        }
    }
    @future
    public static Void doResetPassword(id userIds) {
        String result ;
        try {
            System.debug('user id send to password'+userIds);
            system.resetpassword(userIds,true);
        } catch (Exception ce) {
            //nothing
        }
    }
}