@isTest(seeAllData=false)
public class CSS_OverlapSRT_Test { 
    
    public static testMethod void testOverlapSRT(){
        String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
        
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        System.runAs(u) {
            account at = new account();
            at.name = 'TEst'+math.random();
            at.IAM_Service_Provider_Code__c = '56270';
            at.CSS_DistributorCode__c = '56720';
            at.T_C_Accepted_By__c='Customer';
            at.Region__c = 'US and Canada';
            at.CMI_Account_Status__c = 'Active';
            at.RecordTypeId = recordType_Id;
            
            insert at;
            
            CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            servjob.Account__c=at.Id;
            insert servjob;
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c = servjob.ID;
            sol.Case_Name__c = 'ABC';
            sol.Solution_Title__c='CDE';
            sol.Name='ABC';
            sol.Diagnostic_Response__c ='Most likely the solution';
            sol.Repair_Response__c = 'Most likely';
            insert sol;
            CSS_Claims__c claim = new CSS_Claims__C();
            claim.AccessCode__c='test';
            claim.CSS_Job__c=servjob.id;
            claim.Account__c=at.Id;
            insert claim;
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c='test';
            solcomp.Performed_Review__c=true;
            solcomp.Status__c='approved';
            solcomp.Complete_Indicator__c=false;
            solcomp.Multiple_Times__c=true;
            solcomp.CSS_Claims__c=claim.id;
            solcomp.Solutions__c=Sol.Id;
            insert solComp;
            
            List<CSS_SRT__c> lstSrt = new List<CSS_SRT__c>(); 
            
             CSS_SRT__c srt3 = new CSS_SRT__c();
            srt3.Solution_Number__c = sol.id;
            srt3.SRT_Title__c='test';
            srt3.SRT_Quantity__c=123;
            srt3.SRT_Time__c=123;
            srt3.SRT_Access_Code__c='test';
            srt3.SRT_Category__c='Campaign';
            srt3.CSS_Claims__c=claim.id;
            srt3.Type__c='Overlap';
            srt3.Component_Id__c=solcomp.Id;
            srt3.srt_type__c='Diag Access';
            srt3.FailCode__c='';
            srt3.Access_Code__c='';
            srt3.Extended_Hours__c=4;
            srt3.SRT_Select__c=true;
            srt3.SRT_ID__c = '123';
            srt3.SRT_Notes__c = 'ewdewew';
            srt3.Override__c=true;
            srt3.Step_Id__c = '1234';
            srt3.Job_Order__c=servjob.id;
            insert srt3;
             CSS_SRT__c srt31 = new CSS_SRT__c();
            srt31.Solution_Number__c = sol.id;
            srt31.SRT_Title__c='test';
            srt31.SRT_Quantity__c=123;
            srt31.SRT_Time__c=123;
            srt31.SRT_Access_Code__c='test';
            srt31.SRT_Category__c='Campaign';
            srt31.CSS_Claims__c=claim.id;
            srt31.Type__c='Overlap';
            srt31.Component_Id__c=solcomp.Id;
            srt31.srt_type__c='Diag Access';
            srt31.FailCode__c='';
            srt31.Access_Code__c='';
            srt31.Extended_Hours__c=4;
            srt31.SRT_Select__c=true;
            srt31.SRT_ID__c = '123';
            srt31.SRT_Notes__c = 'ewdewew';
            srt31.Override__c=true;
            srt31.Step_Id__c = '1234';
            srt31.Job_Order__c=servjob.id;
            insert srt31;
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Solution_Number__c = sol.id;
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='Campaign';
            srt.CSS_Claims__c=claim.id;
            srt.Type__c='Diag Access';
            srt.Component_Id__c=solcomp.Id;
            srt.srt_type__c='Diag Access';
            srt.FailCode__c='';
            srt.Access_Code__c='';
            srt.Extended_Hours__c=4;
            srt.SRT_Select__c=true;
            srt.SRT_ID__c = '123';
            srt.SRT_Notes__c = 'ewdewew';
            srt.Override__c=true;
            srt.Step_Id__c = '1234';
            insert srt;
            
            CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
            
            
            CSS_Integration_Details__c  inteDeta = new CSS_Integration_Details__c();
            inteDeta.Name = 'OAGOAuth';
            inteDeta.ApplicationName__c = 'OAGOAuth';
            inteDeta.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            inteDeta.IsActive__c = TRUE;
            inteDeta.Key__c = 'w0Hmq9AsCTWKOXpQFQX2BkE5DOSZh8gf2Wt8g9kB+48=';
            inteDeta.Passcode__c = 'eQlUrb2eGNv3uJ2n2CNtWTDNXTPk9vvKsTWlhETRbmJZ+XCkWQHqGrQtzdVf9zcz1IFUkBW0gJN3x9gFWCBQdw==    ';
            inteDeta.Username__c = 'bPTP8aaftM9zQDOLapSFyUG54RJ209STdrgqE2Lz5U0Y2NxFAxMcmF7xbkSaXVLEz3SyFWQ8vzKsJ8Q/Z577fg==';
            insert inteDeta; 
            
            CSS_Integration_Details__c  inteDeta1 = new CSS_Integration_Details__c();
            inteDeta1.Name = 'SRT';
            inteDeta1.ApplicationName__c = 'SRT';
            // inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
            inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTimeTest1234';
            inteDeta1.IsActive__c = TRUE;
            inteDeta1.Key__c = ' Iup5TYoP6x3Dv2wR1sRGLtufXI1EUMHr6LhGC07SK0Y=';
            inteDeta1.Passcode__c = 'ILnQ8uhxXWIrdptalCKgH1FYFA7uEHAEZsYhUTXbRsw=';
            inteDeta1.Username__c = 'bwNaPFu4kN+3JiZTVT+5moSOAdErx1+0U20WORZUtoQ=';
            insert inteDeta1; 
            
            
            //   String sDestURL = ApexPages.CurrentPage().getParameters().put('id',servjob.Id);
            //  string lang = u.LanguageLocaleKey;
            
            //Test.setMock(HttpCalloutMock.class, new CSS_getOverlapSRT_mock_Test());
            PageReference pref;
            pref = new PageReference('/'+servjob.id);
            pref.getParameters().put('id',servjob.id);
            Test.setCurrentPage(pref);
            
            CSS_OverlapSRT ovrlp = new CSS_OverlapSRT();
            ovrlp.selectedAcCode='Customer Billable';
            ovrlp.selectedSRT='123';
            ovrlp.isOverride =true;
            ovrlp.overlapsrtinvoke();
            ovrlp.enableHrsReason ();
            ovrlp.selectedAcCode='ed';
            //ovrlp.accountCodeWithOverlapMap= new map<list<accountCodeWithOverlapMap>>();
            ovrlp.savOverlapSRT();
            ovrlp.loadOverlapSRTs();
           // ovrlp.createOverlapMap();
             //ovrlp.lstOverLapSrt();
            // List<overLapSrtWrapper> lstOverLapSrt = new List<overLapSrtWrapper>();
            
           // Pagereference p1 = ovrlp.savOverlapSRT();     
            Test.stopTest();
        }
    }
    public static testMethod void testOverlapSRTNew(){
        String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
        
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        System.runAs(u) {
            account at = new account();
            at.name = 'TEst'+math.random();
            at.IAM_Service_Provider_Code__c = '56270';
            at.CSS_DistributorCode__c = '56720';
            at.T_C_Accepted_By__c='Customer';
            at.Region__c = 'US and Canada';
            at.CMI_Account_Status__c = 'Active';
            at.RecordTypeId = recordType_Id;
            
            insert at;
            
            CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            servjob.Account__c=at.Id;
            insert servjob;
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c = servjob.ID;
            sol.Case_Name__c = 'ABC';
            sol.Solution_Title__c='CDE';
            sol.Name='ABC';
            sol.Diagnostic_Response__c ='Most likely the solution';
            sol.Repair_Response__c = 'Most likely';
            insert sol;
            CSS_Claims__c claim = new CSS_Claims__C();
            claim.AccessCode__c='test';
            claim.CSS_Job__c=servjob.id;
            claim.Account__c=at.Id;
            insert claim;
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c='test';
            solcomp.Performed_Review__c=true;
            solcomp.Status__c='approved';
            solcomp.Complete_Indicator__c=false;
            solcomp.Multiple_Times__c=true;
            solcomp.CSS_Claims__c=claim.id;
            solcomp.Solutions__c=Sol.Id;
            insert solComp;
            
            List<CSS_SRT__c> lstSrt = new List<CSS_SRT__c>(); 
            
             CSS_SRT__c srt3 = new CSS_SRT__c();
            srt3.Solution_Number__c = sol.id;
            srt3.SRT_Title__c='test';
            srt3.SRT_Quantity__c=123;
            srt3.SRT_Time__c=123;
            srt3.SRT_Access_Code__c='test';
            srt3.SRT_Category__c='Campaign';
            srt3.CSS_Claims__c=claim.id;
            srt3.Type__c='Overlap';
            srt3.Component_Id__c=solcomp.Id;
            srt3.srt_type__c='Diag Access';
            srt3.FailCode__c='';
            srt3.Access_Code__c='';
            srt3.Extended_Hours__c=4;
            srt3.SRT_Select__c=true;
            srt3.SRT_ID__c = '1234';
            srt3.SRT_Notes__c = 'ewdewew';
            srt3.Override__c=true;
            srt3.Step_Id__c = '1234';
            srt3.Job_Order__c=servjob.id;
            insert srt3;
             CSS_SRT__c srt31 = new CSS_SRT__c();
            srt31.Solution_Number__c = sol.id;
            srt31.SRT_Title__c='test';
            srt31.SRT_Quantity__c=123;
            srt31.SRT_Time__c=123;
            srt31.SRT_Access_Code__c='test';
            srt31.SRT_Category__c='Campaign';
            srt31.CSS_Claims__c=claim.id;
            srt31.Type__c='Overlap';
            srt31.Component_Id__c=solcomp.Id;
            srt31.srt_type__c='Diag Access';
            srt31.FailCode__c='';
            srt31.Access_Code__c='';
            srt31.Extended_Hours__c=4;
            srt31.SRT_Select__c=true;
            srt31.SRT_ID__c = '123';
            srt31.SRT_Notes__c = 'ewdewew';
            srt31.Override__c=true;
            srt31.Step_Id__c = '1234';
            srt31.Job_Order__c=servjob.id;
            srt31.Account_Code__c='test';
            insert srt31;
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Solution_Number__c = sol.id;
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='Campaign';
            srt.CSS_Claims__c=claim.id;
            srt.Type__c='Diag Access';
            srt.Component_Id__c=solcomp.Id;
            srt.srt_type__c='Diag Access';
            srt.FailCode__c='';
            srt.Access_Code__c='';
            srt.Extended_Hours__c=4;
            srt.SRT_Select__c=true;
            srt.SRT_ID__c = '123';
            srt.SRT_Notes__c = 'ewdewew';
            srt.Override__c=true;
            srt.Step_Id__c = '1234';
            insert srt;
            
            CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
            
            
            CSS_Integration_Details__c  inteDeta = new CSS_Integration_Details__c();
            inteDeta.Name = 'OAGOAuth';
            inteDeta.ApplicationName__c = 'OAGOAuth';
            inteDeta.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            inteDeta.IsActive__c = TRUE;
            inteDeta.Key__c = 'w0Hmq9AsCTWKOXpQFQX2BkE5DOSZh8gf2Wt8g9kB+48=';
            inteDeta.Passcode__c = 'eQlUrb2eGNv3uJ2n2CNtWTDNXTPk9vvKsTWlhETRbmJZ+XCkWQHqGrQtzdVf9zcz1IFUkBW0gJN3x9gFWCBQdw==    ';
            inteDeta.Username__c = 'bPTP8aaftM9zQDOLapSFyUG54RJ209STdrgqE2Lz5U0Y2NxFAxMcmF7xbkSaXVLEz3SyFWQ8vzKsJ8Q/Z577fg==';
            insert inteDeta; 
            
            CSS_Integration_Details__c  inteDeta1 = new CSS_Integration_Details__c();
            inteDeta1.Name = 'SRT';
            inteDeta1.ApplicationName__c = 'SRT';
            // inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
            inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTimeTest1234';
            inteDeta1.IsActive__c = TRUE;
            inteDeta1.Key__c = ' Iup5TYoP6x3Dv2wR1sRGLtufXI1EUMHr6LhGC07SK0Y=';
            inteDeta1.Passcode__c = 'ILnQ8uhxXWIrdptalCKgH1FYFA7uEHAEZsYhUTXbRsw=';
            inteDeta1.Username__c = 'bwNaPFu4kN+3JiZTVT+5moSOAdErx1+0U20WORZUtoQ=';
            insert inteDeta1; 
            
            
            //   String sDestURL = ApexPages.CurrentPage().getParameters().put('id',servjob.Id);
            //  string lang = u.LanguageLocaleKey;
            
            //Test.setMock(HttpCalloutMock.class, new CSS_getOverlapSRT_mock_Test());
            PageReference pref;
            pref = new PageReference('/'+servjob.id);
            pref.getParameters().put('id',servjob.id);
            Test.setCurrentPage(pref);
            
            CSS_OverlapSRT ovrlp = new CSS_OverlapSRT();
            ovrlp.selectedAcCode='Customer Billable';
            ovrlp.selectedSRT='1234';
            ovrlp.isOverride =false;
            ovrlp.overlapsrtinvoke();
            ovrlp.enableHrsReason ();
            ovrlp.selectedAcCode='ed';
            //ovrlp.accountCodeWithOverlapMap= new map<list<accountCodeWithOverlapMap>>();
            ovrlp.savOverlapSRT();
            ovrlp.loadOverlapSRTs();
           // ovrlp.createOverlapMap();
             //ovrlp.lstOverLapSrt();
            // List<overLapSrtWrapper> lstOverLapSrt = new List<overLapSrtWrapper>();
            
           // Pagereference p1 = ovrlp.savOverlapSRT();     
            Test.stopTest();
        }
    }
    public static testMethod void testOverlapSRT123(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
        servjob.overlap_time__c = 0.1;
        servjob.adjusted_time__c = 5.5;
        servjob.AccessCode__c = 'A';
        servjob.Claim_No__c = 1;
        insert servjob;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = servjob.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=servjob.id;
        claim.Account__c=acc.Id;
        insert claim;
        
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srt.SRT_ID__c = '123';
        srt.SRT_Notes__c = 'ewdewew';
        srt.Override__c=true;
        srt.Step_Id__c = '1234';
        insert srt;
        CSS_OverlapSRT ovrlp1 = new CSS_OverlapSRT();
        ApexPages.CurrentPage().getParameters().put('id',servjob.Id);
        //ovrlp1.savOverlapSRT();
        
    }
    public static testMethod void testOverlapSRT1(){
        Test.startTest();
        String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        System.runAs(u) {
            
            CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            insert servjob;
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c = servjob.ID;
            sol.Case_Name__c = 'ABC';
            sol.Solution_Title__c='CDE';
            sol.Name='ABC';
            sol.Diagnostic_Response__c ='Most likely the solution';
            sol.Repair_Response__c = 'Most likely';
            insert sol;
            List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
            
            account acc = new account();
            acc.name = 'TEst'+math.random();
            acc.IAM_Service_Provider_Code__c = '56270';
            acc.CSS_DistributorCode__c = '56720';
            acc.Region__c = 'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
            acc.Type='Customer';
            acc.RecordTypeId=recordType_Id;
            insert acc;
            
            
            CSS_Claims__c claim = new CSS_Claims__C();
            claim.AccessCode__c='test';
            claim.CSS_Job__c=servjob.id;
            claim.Account__c=acc.Id;
            insert claim;
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c='test';
            solcomp.Performed_Review__c=true;
            solcomp.Status__c='approved';
            solcomp.Complete_Indicator__c=false;
            solcomp.Multiple_Times__c=true;
            solcomp.CSS_Claims__c=claim.id;
            solcomp.Solutions__c=Sol.Id;
            insert solComp;
            
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Solution_Number__c = sol.id;
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='Campaign';
            srt.CSS_Claims__c=claim.id;
            srt.Type__c='Diag Access';
            srt.Component_Id__c=solcomp.Id;
            srt.srt_type__c='Diag Access';
            srt.FailCode__c='';
            srt.Access_Code__c='';
            srt.Extended_Hours__c=4;
            srt.SRT_Select__c=true;
            srt.SRT_ID__c = '123';
            srt.SRT_Notes__c = 'ewdewew';
            srt.Override__c=true;
            srt.Step_Id__c = '1234';
            insert srt;
            
            CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
            
            
            
            CSS_Integration_Details__c  inteDeta = new CSS_Integration_Details__c();
            inteDeta.Name = 'OAGOAuth';
            inteDeta.ApplicationName__c = 'OAGOAuth';
            inteDeta.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            inteDeta.IsActive__c = TRUE;
            inteDeta.Key__c = 'w0Hmq9AsCTWKOXpQFQX2BkE5DOSZh8gf2Wt8g9kB+48=';
            inteDeta.Passcode__c = 'eQlUrb2eGNv3uJ2n2CNtWTDNXTPk9vvKsTWlhETRbmJZ+XCkWQHqGrQtzdVf9zcz1IFUkBW0gJN3x9gFWCBQdw==    ';
            inteDeta.Username__c = 'bPTP8aaftM9zQDOLapSFyUG54RJ209STdrgqE2Lz5U0Y2NxFAxMcmF7xbkSaXVLEz3SyFWQ8vzKsJ8Q/Z577fg==';
            insert inteDeta;
            
            
            CSS_Integration_Details__c  inteDeta1 = new CSS_Integration_Details__c();
            inteDeta1.Name = 'SRT';
            inteDeta1.ApplicationName__c = 'SRT';
            inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
            inteDeta1.IsActive__c = TRUE;
            inteDeta1.Key__c = ' Iup5TYoP6x3Dv2wR1sRGLtufXI1EUMHr6LhGC07SK0Y=';
            inteDeta1.Passcode__c = 'ILnQ8uhxXWIrdptalCKgH1FYFA7uEHAEZsYhUTXbRsw=';
            inteDeta1.Username__c = 'bwNaPFu4kN+3JiZTVT+5moSOAdErx1+0U20WORZUtoQ=';
            insert inteDeta1;
            
            
            ApexPages.CurrentPage().getParameters().put('id',servjob.Id);
            string lang = u.LanguageLocaleKey;
            
            CSS_OverlapSRT ovrlp2 = new CSS_OverlapSRT();
            ovrlp2.overlapsrtinvoke();
            
            /*             CSS_OverlapSRT.overLapSrtWrapper wrapperRef = new CSS_OverlapSRT.overLapSrtWrapper();
wrapperRef.SRT_Code = '1234';
wrapperRef.SRT_Description = 'test';
wrapperRef.OverlapSRTTime =1.2;
wrapperRef.overide = true;
wrapperRef.SRT_Time = 'te';
wrapperRef.SRT_Notes = 'test';
wrapperRef.SRT_OverrideReason = 'tets';
wrapperRef.SRT_Overlap = 1.2;
wrapperRef.Id = 'test';
// insert wrapperRef;*/
            Test.stopTest();
        }
    }
    public static testMethod void testOverlapSRT2(){
        Test.startTest();
        String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        System.runAs(u) {
            
            CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            insert servjob;
             CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = servjob.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
		
		account acc = new account();
            acc.name = 'TEst'+math.random();
            acc.IAM_Service_Provider_Code__c = '56270';
            acc.CSS_DistributorCode__c = '56720';
            acc.Region__c = 'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
            acc.Type='Customer';
            acc.RecordTypeId=recordType_Id;
            insert acc;
		
		CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=servjob.id;
        claim.Account__c=acc.Id;
        insert claim;
		
		
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
		
		
		CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;
            
           CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
            
            
            
            CSS_Integration_Details__c  inteDeta = new CSS_Integration_Details__c();
            inteDeta.Name = 'OAGOAuth';
            inteDeta.ApplicationName__c = 'OAGOAuth';
            inteDeta.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            inteDeta.IsActive__c = TRUE;
            inteDeta.Key__c = 'w0Hmq9AsCTWKOXpQFQX2BkE5DOSZh8gf2Wt8g9kB+48=';
            inteDeta.Passcode__c = 'eQlUrb2eGNv3uJ2n2CNtWTDNXTPk9vvKsTWlhETRbmJZ+XCkWQHqGrQtzdVf9zcz1IFUkBW0gJN3x9gFWCBQdw==    ';
            inteDeta.Username__c = 'bPTP8aaftM9zQDOLapSFyUG54RJ209STdrgqE2Lz5U0Y2NxFAxMcmF7xbkSaXVLEz3SyFWQ8vzKsJ8Q/Z577fg==';
            insert inteDeta;
            
            
            CSS_Integration_Details__c  inteDeta1 = new CSS_Integration_Details__c();
            inteDeta1.Name = 'SRT';
            inteDeta1.ApplicationName__c = 'SRT';
            inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
            inteDeta1.IsActive__c = TRUE;
            inteDeta1.Key__c = ' Iup5TYoP6x3Dv2wR1sRGLtufXI1EUMHr6LhGC07SK0Y=';
            inteDeta1.Passcode__c = 'ILnQ8uhxXWIrdptalCKgH1FYFA7uEHAEZsYhUTXbRsw=';
            inteDeta1.Username__c = 'bwNaPFu4kN+3JiZTVT+5moSOAdErx1+0U20WORZUtoQ=';
            insert inteDeta1;
            
            
            ApexPages.CurrentPage().getParameters().put('id',servjob.Id);
            string lang = u.LanguageLocaleKey;
            
            CSS_OverlapSRT ovrlp2 = new CSS_OverlapSRT();
            ovrlp2.overlapsrtinvoke();
            
            /*    CSS_OverlapSRT.overLapSrtWrapper wrapperRef = new CSS_OverlapSRT.overLapSrtWrapper();
wrapperRef.SRT_Code = '123456';
wrapperRef.SRT_Description = 'test';
wrapperRef.OverlapSRTTime =1.2;
wrapperRef.overide = true;
wrapperRef.SRT_Time = 'te';
wrapperRef.SRT_Notes = 'test';
wrapperRef.SRT_OverrideReason = 'tets';
wrapperRef.SRT_Overlap = 1.2;
wrapperRef.Id = 'test';
ovrlp2.saveOverlapSRTs();*/
            
            // insert wrapperRef;
            Test.stopTest();
        }
    }
    public static testMethod void testOverlapSRT3(){
        CSS_OverlapSRT ovrlp = new CSS_OverlapSRT();
        ovrlp.getOverrideReasonList();
        //ovrlp.createOverlapMap();
        // ovrlp.loadOverlapSRTs();
        
    }
    static testmethod void  overlap4(){
        CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            insert servjob;
         CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = servjob.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
		
		Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
		
		CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=servjob.id;
        claim.Account__c=acc.Id;
        insert claim;
		
		
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
		
		
		CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;
        CSS_OverlapSRT overlap = new CSS_OverlapSRT();
        
        account at = new account();
        at.name = 'TEst'+math.random();
        at.IAM_Service_Provider_Code__c = '56270';
        at.CSS_DistributorCode__c = '56720';
        at.T_C_Accepted_By__c='Customer';
        at.Region__c = 'US and Canada';
        at.CMI_Account_Status__c = 'Active';
        
        
        insert at;
        CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
        list<CSS_OverlapSRT.overLapSrtSubWrapper> sublist=new list<CSS_OverlapSRT.overLapSrtSubWrapper>();
        CSS_OverlapSRT.overLapSrtSubWrapper sub=new CSS_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT',10.0,true,'SRT_AdjOverlapHrs','SRT_OverrideReason',srt2.id,true,'overrideReason',true,true,true,2,'test','test');
        sublist.add(sub);
        list<CSS_OverlapSRT.overLapSrtWrapper> srtwlist=new list<CSS_OverlapSRT.overLapSrtWrapper>();
        CSS_OverlapSRT.overLapSrtWrapper srtw=new CSS_OverlapSRT.overLapSrtWrapper('SRT_Code','accCode',sublist,'SRT_Code','accCode');
        srtwlist.add(srtw);
        overlap.selectedAcCode = 'Customer Billable';
        overlap.createOverlapMap();
        overlap.loadOverlapSRTs();
        overlap.enableHrsReason();
    }  
    public static testMethod void testOverlapSRT5(){
        String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        System.runAs(u) {
            account at = new account();
            at.name = 'TEst'+math.random();
            at.IAM_Service_Provider_Code__c = '56270';
            at.CSS_DistributorCode__c = '56720';
            at.T_C_Accepted_By__c='Customer';
            at.Region__c = 'US and Canada';
            at.CMI_Account_Status__c = 'Active';
            at.RecordTypeId = recordType_Id;
            
            insert at;
            
            CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
            servjob.overlap_time__c = 0.1;
            servjob.adjusted_time__c = 5.5;
            servjob.AccessCode__c = 'A';
            servjob.Claim_No__c = 1;
            insert servjob;
             CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = servjob.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
		
		
		
		CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=servjob.id;
        claim.Account__c=at.Id;
        insert claim;
		
		
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
		
		
		CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;
            List<CSS_SRT__c> lstSrt = new List<CSS_SRT__c>(); 
            
            lstSrt.add(srt);
            
            CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.Solution_Number__c = sol.id;
            srt2.SRT_Title__c='test';
            srt2.SRT_Quantity__c=123;
            srt2.SRT_Time__c=123;
            srt2.SRT_Access_Code__c='test';
            srt2.SRT_Category__c='Campaign';
            srt2.CSS_Claims__c=claim.id;
            srt2.Type__c='Diag Access';
            srt2.Component_Id__c=solcomp.Id;
            srt2.srt_type__c='Diag Access';
            srt2.FailCode__c='';
            srt2.Access_Code__c='';
            srt2.Extended_Hours__c=4;
            srt2.SRT_Select__c=true;
            srt2.SRT_ID__c = '123';
            srt2.SRT_Notes__c = 'ewdewew';
            srt2.Override__c=true;
            srt2.Step_Id__c = '1234';
            insert srt2;
            
            CSS_Integration_Details__c  inteDeta = new CSS_Integration_Details__c();
            inteDeta.Name = 'OAGOAuth';
            inteDeta.ApplicationName__c = 'OAGOAuth';
            inteDeta.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            inteDeta.IsActive__c = TRUE;
            inteDeta.Key__c = 'w0Hmq9AsCTWKOXpQFQX2BkE5DOSZh8gf2Wt8g9kB+48=';
            inteDeta.Passcode__c = 'eQlUrb2eGNv3uJ2n2CNtWTDNXTPk9vvKsTWlhETRbmJZ+XCkWQHqGrQtzdVf9zcz1IFUkBW0gJN3x9gFWCBQdw==    ';
            inteDeta.Username__c = 'bPTP8aaftM9zQDOLapSFyUG54RJ209STdrgqE2Lz5U0Y2NxFAxMcmF7xbkSaXVLEz3SyFWQ8vzKsJ8Q/Z577fg==';
            insert inteDeta; 
            
            CSS_Integration_Details__c  inteDeta1 = new CSS_Integration_Details__c();
            inteDeta1.Name = 'SRT';
            inteDeta1.ApplicationName__c = 'SRT';
            inteDeta1.End_Point__c = 'https://services-dev.cummins.com/css/RetrieveStandardRepairTimeTest1234';
            inteDeta1.IsActive__c = TRUE;
            inteDeta1.Key__c = ' Iup5TYoP6x3Dv2wR1sRGLtufXI1EUMHr6LhGC07SK0Y=';
            inteDeta1.Passcode__c = 'ILnQ8uhxXWIrdptalCKgH1FYFA7uEHAEZsYhUTXbRsw=';
            inteDeta1.Username__c = 'bwNaPFu4kN+3JiZTVT+5moSOAdErx1+0U20WORZUtoQ=';
            insert inteDeta1; 
            
            
            PageReference pref;
            pref = new PageReference('/'+servjob.id);
            pref.getParameters().put('id',servjob.id);
            Test.setCurrentPage(pref);
            
            CSS_OverlapSRT ovrlp = new CSS_OverlapSRT();
            ovrlp.selectedAcCode='Customer Billable';
            ovrlp.selectedSRT='123';
            ovrlp.isOverride =false;
            ovrlp.overlapsrtinvoke();
            ovrlp.enableHrsReason ();
            ovrlp.selectedAcCode='ed';
            ovrlp.savOverlapSRT();
            ovrlp.loadOverlapSRTs();
            ovrlp.lineItemStepIdClaimsOlap='123';
            ovrlp.StepDescriptionOlap='123';
            ovrlp.callJobsAccessStepDetailsOlap();
             ovrlp.ClaimsOlapNotesPopupOk();
            Test.stopTest();
        }
    }
}