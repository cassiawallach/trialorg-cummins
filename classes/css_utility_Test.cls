/**********************************************************************
Name:css_utility
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Global Utility Class for CSS Job Functions                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Gyan Pany         0513/2016      INITIAL DEVELOPMENT      
2.0   Dinesh Yadav      08/04/2021     CT3-586- change 
***comment added for sept release 2022***

***********************************************************************/
@IsTest 
public class css_utility_Test {
    //Method to Return Time in User's Time zone from Visualforce page.
    public static testMethod void getFormattedDate () {
        DateTime dInputDate = system.Now();
        date d = date.today();
        date d1 = date.today()+1;
        string datereturn=css_utility.getFormattedDate(dInputDate);
        system.debug('datereturn****'+datereturn);
        css_utility.getFormattedDate(null);
       // css_utility.getFormattedUserLocaleDate(dInputDate);
        css_utility.CheckPhoneNoIsValid('1234567898');
        css_utility.createCase('caseComment', 'jobName', 'serviceModel', 'solutionTitle', 'solutionId');
        css_utility.validateEmail('abc@cummins.com');
        css_utility.FormatDate(d);
        css_utility.calculateYearsMonthsDays(d, d1);
        css_utility.getReconEngine(79464646);
        css_utility.getFormattedDate();
        //css_utility.getBMSEnabled('location');
        //css_utility.setSessionVariables('locationset');
        //system.assertEquals(, datereturn);
        css_utility.insertAccountPayCodes();
         String userLocaleFormat =  css_utility.getFormattedDate();
        Date doj= css_utility.formatDateIntoLocale('dInputDate');
        Date format= css_utility.formatDateFromGuidanzFormat('d');
       date formatesdate= css_utility.formatedDateOfSiebelDate('2011-01-10T00:00:00Z');
        Date con=css_utility.convertStringToDate('20/06/1988');
       //Date format=css_utility.formatDateFromGuidanzFormat('2 AUG 1999'); //input: MM/DD/YYYY (or) '2 AUG 1999'
       String remainingyear= css_utility.getRemainingYearsMonthsDays(d,d1);
        date formatedDate1=css_utility.formatedDate('2011-01-10T00:00:00Z');
        String getFormattedDateGMT1=css_utility.getFormattedDateGMT (dInputDate);
   
              
    }
   
    
    //populate a map with locale values and corresponding datetime formats
    public static testMethod void insertQSOLDocs () {
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb = CSS_TestData.createJobOrder(false);
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 1000;
        
        cjb.Failure_Point_Measure__c = 'Kilometers';
        insert cjb;
       
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c cam = new CSS_CampTsbTrp__c();
        cam.Name = 'ABC';
        cam.Job_Order__c = cjb.id;
        cam.ESN__c = '79464646';
        cam.Doc_Num__c = '1';
        insert cam;
        lstQSOLDocs.add(cam);
        system.debug('lstQSOLDocs:' + lstQSOLDocs.size());
        css_utility.insertQSOLDocs(lstQSOLDocs);
    } // Finish Insert QSOL Docs
    
    /* Private static testMethod void mpLocaleValues() {
         css_utility.mpLocaleValues();
    }*/
    Public static testMethod Id CreateTestUser()
    {       id UserId;
     
        // Setup test data
        // This code runs as the system user
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
 //       System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            UserId = UserInfo.getUserId();
  //      }
            return UserId;
    }
    public static testMethod void getOrgType () {
    // Method to return whether user belongs to Distributor(DIST) or Dealer (DLR)
        //Id duserid = '0053B000000Hp8Y'; 
        /*system.runas(UserInfo.getUserId()){
        Account objAcc = new Account(name ='Test Account8',CSS_DealerCode__c='56270',CSS_DBCode__c='56270',CSS_DistributorCode__c='56255',Type = 'Customer');
        insert objAcc; 
Contact objContact = new Contact(LastName ='testCon8',AccountId = objAcc.Id,CMI_Contact_Type__c = 'Secondary', IAM_Cummins_login_ID__c='Danielakanksha@truck.com',IAM_Contact_Status__c = 'Active',Email = 'akanksha.p@gmail.com',FirstName ='akanksha8',Phone='000-000-0000');
        insert objContact;  
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',user_Location__c = '56270-56255',UserRoleId = empRole.id,ContactId=objContact.id);
        insert u;*/

       // id UserId = u.Id;
        id UserId = UserInfo.getUserId();
        system.debug('UserId:' +UserId);
        /*test.startTest();*/
        css_utility.getOrgType(UserId);
       boolean getclaims=css_utility.getclaimsapprove(UserId);
       boolean showquote= css_utility.showQuotePage(UserId,'02400-02400');
       Decimal custom= css_utility.getCustomRoundValue(000.00 );
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced']; 
        string getprofile=css_utility.getProfileName(p.Id);
        string unittype= css_utility.getUnitype('makeName' ,'modelName','config','engineFamilyCode','equipmentId' );
        string unittype1=css_utility.getUnitype('makeName' , 'modelName','engineFamilyCode','equipmentId');
          // test.stoptest();         
    //}
    }
    
   public static testMethod void getFederationId () {
    // Method to return whether user belongs to Distributor(DIST) or Dealer (DLR)

       Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser3@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser3@testorg.com');
        insert u;

       id UserId = u.id;
       system.debug('UserId:' +UserId);
        css_utility.getFederationId(UserId);
        
    }
    
    public static testMethod void createJobhistory(){
        
        List<CSS_JobHistory__c> jobHistoryList1 = new List<CSS_JobHistory__c>();
        CSS_JobHistory__c jh = new CSS_JobHistory__c();
        jh.CSS_Field_Name__c = 'uii';
        jh.CSS_New_Value__c = 'jdjj';
        insert jh;
        //jobHistoryList1.add(jh);
        css_utility.createJobhistory(jobHistoryList1);
        system.debug('jh>>>>'+jh);
        system.debug('jhlist>>>>'+jobHistoryList1);
        
        }  
        
         public static testMethod void languag(){
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
         User u =  new User(Alias = 'standt', Email='standarduser4@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com');
        insert u;
        id UserId = u.id;

           css_utility.setUserLang(UserId,'en_US');
             css_utility.dealerUserLocation(null);
        
       
        }  
        
        public static testMethod void actlanguag(){
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u =  new User(Alias = 'standt', Email='standarduser4@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com');
        insert u;
        id UserId = u.id;
             css_utility.getLanguage('en_US');
           //User user12 = [select UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user limit 1 ];
       //insert user12;
       
         //css_utility.setSessionVariables('02850-03735');
            
        
       
        }
            
    
    public static testMethod void getUserAttributes(){

       Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com' , User_Location__c='Bnag-alore', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com');
        insert u;
        // Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode', u.User_Location__c==null?'':u.User_Location__c);
        system.debug('userlocation>>>>'+u.User_Location__c);
        //css_utility.setSessionVariables(u.User_Location__c);
        
//IF(IAM_Service_Provider_Code__c == '' || IAM_Service_Provider_Code__c == null, CSS_DistributorCode__c + '-' + IAM_Service_Provider_Code__c, CSS_DistributorCode__c + '-' + IAM_Service_Provider_Code__c)
        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        Account acc = new Account();
        //acc.Location__c = u.User_Location__c;
        acc.Name = 'bangalore';
        acc.BMS_Enabled__c = false;
        acc.Region__c = 'KOREA';
        acc.Territory__c = 'SOUTH KOREA';
        //acc.IAM_Service_Provider_Code__c = '';
        acc.CSS_DistributorCode__c = 'Bnag';
        acc.IAM_Service_Provider_Code__c = 'alore';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
       // acc.IAM_Service_Provider_Code__c = '';
        insert acc;
        system.debug('acc.Location__c>>>>'+acc.Location__c); 
       List<Account> nameId =[select id,name,Location__c from Account where id=:acc.Id ];
        system.debug('nameId>>>>'+nameId);
        
        //Creating Make Model List and object
        List<CSS_Make_Model_Access__c> mm = new List<CSS_Make_Model_Access__c>();
        CSS_Make_Model_Access__c mo = new CSS_Make_Model_Access__c();
            mo.Make__c = 'ACE';
            mo.Model__c = 'QSB-44-T2';
           // mo.Name = 'make';
            insert mo;
        CSS_Make_Model_Access__c mo1 = new CSS_Make_Model_Access__c();
          //  mo1.Name = 'model';
            mo1.Make__c = 'ACG';
            mo1.Model__c = 'FS40';
            insert mo1;
        mm.add(mo);
        mm.add(mo1);
        
        css_utility.getMake('ACG');
        string getmake1= css_utility.getMake('makeName','engineFamilyCode','equipmentId' );
        css_utility.getModel('ACG', 'FS40');
       string getmodel1=css_utility.getModel('makeName','modelName','engineFamilyCode','equipmentId');
        css_utility.getUserAttributes(UserId);
       // css_utility.mpLocaleDateValues();
        css_utility.getFormattedDate();
        
        //Creating Country State Values object
        CSS_CountryStateValues__c cs = new CSS_CountryStateValues__c();
            cs.Name = 'countrystate';
            cs.StateName__c = 'NA';
            cs.CountryName__c = 'ind';
            cs.CountryCode__c = '45';
            cs.StateCode__c = '2';
            insert cs;
        css_utility.getDEEnabled(UserId);
        css_utility.getFSLEnabled(UserId);
        css_utility utii = new css_utility();
        utii.getAttachment(null);
        utii.getInsiteImageAzureFile(null,null);
        utii.createAttachment(null,null,null);
        css_utility.getStateDesc('45', '2');
        css_utility.getCountryDesc('45');
        css_utility.getStdPicklistCode('pObjName', 'pFieldName', 'pPickVal', 'pLBLorCD');
        css_utility.GetDependentOptions('CSS_Claims__c', 'Claims_Category__c', 'Claims_Category__c');
        css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'recordTypeName');
        
        css_utility.getRegionTerritory(u.User_Location__c);
        //css_utility.getBMSEnabled(UserId);
        css_utility.prepareRESTResponse(acc, 200);
        css_utility.convertStrToMin('23:24');
        css_utility.convertStrToMin('23.24');
        //css_utility.convertStrToMin('23.24');
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        Integer size = myBlob.size();
        css_utility.getSubStringValue('input', 6, 7);
        css_utility.BlobToBytes(myBlob);
        css_utility.cnvBits(myString);
        CSS_UserLocation__c userloc=new CSS_UserLocation__c();
       // userloc.BMS_Enabled__c=true;
        userloc.Location_code__c='locCode';
        insert userloc;
        boolean getbms1= css_utility.getBMSEnabled('locCode');
        //Method to cover inner class
        css_utility.TPicklistEntry ut = new css_utility.TPicklistEntry();
        ut.active = 'true';
        ut.defaultValue = 'fault';
        ut.label = 'label';
        ut.validFor = 'vdd';
        ut.value = 'vd';
        Map<String, Object> inputMap= new Map<String, Object>();  
        Boolean Res =css_utility.isMapContainsKey(inputMap,'Test');
        css_utility ut1 = new css_utility();
            

        String[]  lstStr = new List<string>{'name', 'Assigned__c', 'ESN__c', 
                                        'additional_tech1__r.firstname','additional_tech1__r.lastname',
                                        'Add_tech1__c','Customer_name__c','add_tech2__c','assigned_to__c','createdBy.name','Additional_Tech1__r.Name','Additional_Tech2__r.Name','Additional_Tech3__r.Name',
                                        'Additional_Tech4__r.Name','Additional_Tech5__r.Name','Additional_Tech6__r.Name','Additional_Tech7__r.Name','Additional_Tech8__r.Name','Additional_Tech9__r.Name','Status__c','Shop_Work_Order__c','Service_Model__c',
                                        'Unit_Number__c','Date_In__c'};
        
  
        List<sObject> res1=ut1.runQuery('CSS_Job_Order__c',lstStr, 'model__c', 'Test', 'CFSE', '', '');
        //List<sObject> res2=ut1.runQuery('CSS_Job_Order__c',lstStr, 'model__c', 'Test', 'DFSE', '', '');
    }
    public static testMethod void getCodesTest1(){
       string scode1=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator','ALTERNATOR MALFUNCTIONING');
    } 
        public static testMethod void getCodesTest2(){
        string scode2=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator',null);
    }
        public static testMethod void getCodesTest3(){
       string scode3=css_utility.getCodes('Application Code','Automotive',null,null);
    }
       public static testMethod void getCodesTest4(){
       string scode3=css_utility.getCodes('Application Code',null,null,null);
    }
    
     public static testMethod void getCodesTest5(){
       string scode3=css_utility.getCodes('Application Code','Component / Part Specific Issue',null,'ALTERNATOR MALFUNCTIONING');
    }
    
     public static testMethod void getCodesTest6(){
       string scode3=css_utility.getCodes('Application Code', null,'Alternator',null);
     }
     
    public static testMethod void LogInbIntError(){
        css_utility.LogInbIntError('CSSResp', 'sysError', 'SrcMsg', 'sSource');
     }
    public static testMethod void LogOutIntError(){
       css_utility.LogOutIntError('CSSResp', 'sysError', 'SrcMsg', 'sSource'); 
    }
     public static testMethod void updateDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        css_utility.updateDSID('dsi', 'fedID', 'custName', 'make', 'model', 'accessC', 'equipID', 0.0, 'fMeasure', 'uNum', 'esn', 'wOrder');
    }
    public static testMethod void dsidIndicator(){
         Test.setMock(HttpCalloutMock.class, new CSS_DetailsDsid_Test());
        css_utility.getDSIDEditIndicator(userinfo.getUserId(), 'DSBDT4730', 'A');
    }
      public static testMethod void dsidIndi(){
         Test.setMock(HttpCalloutMock.class, new CSS_DetailsDsid_Test());
        css_utility.getDSIDEditIndicator(userinfo.getUserId(), 'DSBDT4630', 'A');
    }
    
    public static testmethod void TestforCheckPhoneNoIsValid(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        
        User u = new User(
            Alias = 'IAbdu', 
            Email='ibrahim.abdur-raqib=cummins.com@example.com', 
            User_Location__c='02860-29550', 
            EmailEncodingKey='UTF-8',
            LastName='Abdur-Raqib',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='ibrahim.abdur-raqib56@cummins.com.cso.test');
            insert u;
           
        system.debug('userlocation>>>>'+u.User_Location__c);
        

        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        
        CSS_UserLocation__c userloc=new CSS_UserLocation__c();
        userloc.Location_code__c='02860-29550';
        insert userloc;
        
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.BMS_Enabled__c = false;
        acc.Region__c = 'KOREA';
        acc.Territory__c = 'SOUTH KOREA';
        acc.IAM_Service_Provider_Code__c = '';
        acc.IAM_Service_Provider_Code__c = '';
        acc.CSS_DistributorCode__c = '02860';
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
        insert acc;
        system.debug('acc.Location__c>>>>'+acc.Location__c);
        
        Account acc1 = new Account();
        acc1.Name = 'Freightliner of Arizona LLC';
        acc1.BMS_Enabled__c = false;
        acc1.Region__c = 'KOREA';
        acc1.Territory__c = 'SOUTH KOREA';
        //acc1.IAM_Service_Provider_Code__c = '';
        //acc1.IAM_Service_Provider_Code__c ='';
        acc1.CSS_DistributorCode__c = '02860';
        acc1.IAM_Service_Provider_Code__c = '29550';
        acc1.Type='Dealer Account';
        acc1.Region__c = 'US and Canada';
        acc1.CMI_Account_Status__c = 'Active';
        //acc1.IAM_Service_Provider_Code__c = '562551';
        insert acc1;
        system.debug('acc.Location__c>>>>'+acc1.Location__c);
        css_utility.setSessionVariables('02860-29550');
        css_utility.getFormattedDateGMT(null);
        css_utility.CheckPhoneNoIsValid('(12-345678) )');
        
    }
    
    public static testmethod void TestForPhoneNull(){
        
        css_utility.CheckPhoneNoIsValid(null);
         css_utility.getSubStringValue('input', 2, 3);
    }
    
    public static testMethod void TestfordsidNew(){
        // Test.setMock(HttpCalloutMock.class, new CSS_DetailsDsid_Test());
        css_utility.getDSIDEditIndicator(userinfo.getUserId(), null, 'A');
    }
    
   
     public static testmethod void TestforDate1(){
        date d0 = date.today()-5;
        date d = date.today()-2;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 dec 2018');
        css_utility.formatDateIntoLocale('07 dec 2018');
        css_utility.calculateYearsMonthsDays(d0, d);
        
    }
    
     public static testmethod void TestforDate2(){
        
        date d = date.today()+60;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 jan 2019');
        css_utility.formatDateIntoLocale('07 jan 2019');
       
    }
     public static testmethod void TestforDate3(){
        
        date d = date.today()+90;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 feb 2019');
        css_utility.formatDateIntoLocale('07 feb 2019');
    }
     public static testmethod void TestforDate4(){
        
        date d = date.today()+120;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 mar 2019');
        css_utility.formatDateIntoLocale('07 mar 2019');
    }
    
     public static testmethod void TestforDate5(){
        
        date d = date.today()+150;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 apr 2019');
        css_utility.formatDateIntoLocale('07 apr 2019');
    }
     public static testmethod void TestforDate6(){
        
        date d = date.today()+180;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 may 2019');
        css_utility.formatDateIntoLocale('07 may 2019');
     }
     public static testmethod void TestforDate7(){
        
        date d = date.today()+210;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 jun 2019');
        css_utility.formatDateIntoLocale('07 jun 2019');
    }
    
     public static testmethod void TestforDate8(){
        
        date d = date.today()+240;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 jul 2019');
        css_utility.formatDateIntoLocale('07 jul 2019');
    }
     public static testmethod void TestforDate9(){
        
        date d = date.today()+270;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 aug 2019');
        css_utility.formatDateIntoLocale('07 aug 2019');
    }
     public static testmethod void TestforDate10(){
        
        date d = date.today()+300;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 sep 2019');
        css_utility.formatDateIntoLocale('07 sep 2019');
    }
    public static testmethod void TestforDate11(){
        
        date d = date.today()+330;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat('07 oct 2019');
        css_utility.formatDateIntoLocale('07 oct 2019');
    }
    
    public static testmethod void TestforDate12(){
        
        css_utility.formatDateFromGuidanzFormat('07 nov 2019');
        css_utility.formatDateIntoLocale('07 nov 2019');
    }
   public static testmethod void TestforDate13(){
        
        date d = null;
        css_utility.FormatDate(d);
        css_utility.formatDateFromGuidanzFormat(null);
        css_utility.getAccounttype('Acctype');
        test.startTest();
        css_utility.webserviceExecutionTest('accessToken');
		
        //css_utility.getUserRecords();
        /*Account obj = new Account();
         obj.CSS_DBCode__c = 'Loca';
         obj.CSS_DistributorCode__c = 'tion';
        insert obj;
       css_utility.dealerUserLocation('Location');*/
	   test.stopTest();
    }
    public static testmethod void TestforcustomRoundValue1(){
        
      Decimal custom = css_utility.getCustomRoundValue(3.14159265898228);
    }
    public static testmethod void TestforcustomRoundValue2(){

        Decimal custom = css_utility.getCustomRoundValue(-3);
}
   
}