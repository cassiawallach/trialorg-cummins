/**********************************************************************
Name:CG_CL_ClaimsSRTs_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsSRTs Controller.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Abhishek      1/29/2018           INITIAL DEVELOPMENT                    
***********************************************************************/

@isTest
public class CG_CL_ClaimsSRTs_Test {
    
    static testmethod void testmethod1()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.Location__c ='test';
        insert acc;
        
        
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        List<css_claims__c> clmList = new List<css_claims__c>();
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=jo1.Id;
        clams.account__c = acc.id;
        clams.Multi_PSN_Claim__c =true;
        clams.Actual_Technician_Time__c=2.0;
        clams.Multi_PSN_Claim__c = false;
        clams.Location_Code__c = '03520-04892';
        clmList.add(clams);
        
        css_claims__c clams12 = new css_claims__c();
        clams12.Customer_Name__c='Gopal';
        clams12.Customer_Code__c='123';
        clams12.ESN__c='53426754';
        clams12.CSS_Job__c=jo1.Id;
        clams12.Multi_PSN_Claim__c =false;
        clams12.Actual_Technician_Time__c=2.0;
        clmList.add(clams12);
        
        insert clmList;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=clams.Id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jo1.Id);
        list<css_srt__c> lstSrt1= new list<css_srt__c>();    
        css_srt__c srt12 = new css_srt__c();
        srt12.CSS_Claims__c=clams.Id;
        srt12.SRT_Quantity__c = 12;
        srt12.Step_Id__c='1';
        srt12.Type__c='Diagnosis';
        //srt12.SRT_Category__c='AdditionalDiag';
        srt12.SRT_AccessiblityCheck__c=true;
        srt12.isPerformed__c=true;
        srt12.SRT_ID__c='4-011';
        srt12.Solution_Number__c=solRef.Id;
        srt12.Account_Code__c='test';
        srt12.Override__c=True;
        insert srt12;
        lstSrt1.add(srt12);
        css_srt__c srt13 = new css_srt__c();
        srt13.CSS_Claims__c=clams.Id;
        srt13.Step_Id__c='1';
        srt13.Type__c='Repair';
        //srt13.SRT_Category__c='AdditionalRep';
        srt13.SRT_AccessiblityCheck__c=true;
        srt13.isPerformed__c=true;
        srt13.Account_Code__c='test';
        srt13.Assignment__c='Diagnostic';
        srt13.SRT_ID__c='4-01';
        insert srt13;
        lstSrt1.add(srt13);
        
        css_srt__c srt15 = new css_srt__c();
        srt15.CSS_Claims__c=clams.Id;
        srt15.Step_Id__c='1';
        srt15.Type__c='Field Action';
        srt15.SRT_Category__c='AdditionalDiag';
        srt15.SRT_AccessiblityCheck__c=true;
        srt15.isPerformed__c=true;
        srt15.Account_Code__c='test';
        srt15.Solution_Number__c=solRef.Id;
        srt15.SRT_ID__c='4';
        insert srt15;
        lstSrt1.add(srt15);
        css_srt__c srt16 = new css_srt__c();
        srt16.CSS_Claims__c=clams.Id;
        srt16.Step_Id__c='1';
        srt16.Type__c='Repair';
        //srt13.SRT_Category__c='AdditionalRep';
        srt16.SRT_AccessiblityCheck__c=true;
        srt16.isPerformed__c=true;
        srt16.Account_Code__c='test';
        srt16.Assignment__c='Primary';
        srt16.Solution_Number__c=solRef.Id;
        srt16.SRT_ID__c='4-01';
        insert srt16;
        lstSrt1.add(srt16);
        css_srt__c srt17 = new css_srt__c();
        srt17.CSS_Claims__c=clams.Id;
        srt17.Step_Id__c='1';
        srt17.Type__c='Repair';
        //srt13.SRT_Category__c='AdditionalRep';
        srt17.SRT_AccessiblityCheck__c=true;
        srt17.isPerformed__c=true;
        srt17.Account_Code__c='test';
        srt17.Assignment__c='Primary';
        srt17.SRT_ID__c='4-01';
        insert srt17;
        lstSrt1.add(srt17);
        css_srt__c srt18 = new css_srt__c();
        srt18.CSS_Claims__c=clams.Id;
        srt18.Step_Id__c='1';
        srt18.Type__c='Field Action';
        srt18.SRT_Category__c='AdditionalDiag';
        srt18.SRT_AccessiblityCheck__c=true;
        srt18.isPerformed__c=true;
        srt18.Account_Code__c='test';
        srt18.Solution_Number__c=solRef.Id;
        srt18.SRT_ID__c='4';
        insert srt18;
        lstSrt1.add(srt18); 
        css_srt__c srt19 = new css_srt__c();
        srt19.CSS_Claims__c=clams.Id;
        srt19.Step_Id__c='1';
        srt19.Type__c='Overlap';
        srt19.SRT_Category__c='AdditionalDiag';
        srt19.SRT_AccessiblityCheck__c=true;
        srt19.isPerformed__c=true;
        srt19.Account_Code__c='test';
        srt19.Solution_Number__c=solRef.Id;
        srt19.SRT_ID__c='4';
        insert srt19;
        lstSrt1.add(srt19);
        css_srt__c srt191 = new css_srt__c();
        srt191.CSS_Claims__c=clams.Id;
        srt191.Step_Id__c='1';
        srt191.Type__c='Overlap';
        srt191.SRT_Category__c='AdditionalDiag';
        srt191.SRT_AccessiblityCheck__c=true;
        srt191.isPerformed__c=true;
        srt191.Account_Code__c='test';
        srt191.Solution_Number__c=solRef.Id;
        srt191.SRT_ID__c='4';
        srt191.SRT_Quantity__c=3;
        srt191.SRT_Warrantable__c='50';
        srt191.SRT_Time__c=9;
        insert srt191;
        lstSrt1.add(srt191);
        css_claims__c clams1=[Select Id,(select id,Step_Id__c,name from CSS_SRTS__r limit 1) from css_claims__c limit 1];
        List<css_srt__c> srts = [select id,SRT_Time__c,SRT_Quantity__c,SRT_Warrantable__c,name,Assignment__c,solution_number__r.Diagnostic_Response__c,Solution_Number__c,SRT_ID__c,Account_Code__c,AccountCode_Formula__c,isPerformed__c,SRT_AccessiblityCheck__c,SRT_Category__c,Type__c,Step_Id__c,CSS_Claims__c from css_srt__c];
        CSS_Job_Order__c JO11 = new CSS_Job_Order__c();
        JO11.Customer_Name__c = 'CumminsTnD';
        JO11.Equipment_ID__c = 'EQ7667';
        JO11.Qsol_Engine_Family_Code__c ='56';
        JO11.AccessCode__c = 'A';
        insert JO11;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO11.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        CSS_Solution_Component__c solCom = CSS_TestData.createSRT(true,JO11.ID , solAdd.id);
        solCom.CSS_Claims__c =clams.Id;
        solCom.Selected_Component__c = true;
        solCom.Status__c='Approved';
        solCom.Type__c='Campaign';
        update solCom;        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Data_ExChange_Admin'];
        Account objAcc = new Account(name ='Test Account',IAM_Service_Provider_Code__c='03742',Type='Dealer Account');
        insert objAcc; 
        
        Contact objContact = new Contact(LastName ='testCon' ,IAM_Cummins_login_ID__c = 'test@cummins.com' ,FirstName='testCon1' ,AccountId = objAcc.Id);
        objContact.Username__c ='UtilityTestUser2@testorg.com';
        insert objContact;  
        Account acc1 = new Account();
        acc1.id = objAcc.id;
        acc1.name='Rtest';
        acc1.CSS_DistributorCode__c='03742';
        //acc1.IAM_Service_Provider_Code__c='03742';
        acc1.Region__c = 'US and Canada';
        acc1.CMI_Account_Status__c = 'Active';
        //  acc.Location__c = '12345-12345';
        
        upsert acc1;
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '03742-03742',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc1.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        css_utility.getOrgType(UserId);
        
        apexpages.currentPage().getparameters().put('id',clams.Id);
        
        
        test.startTest();
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        srt1.showErrorPopup=false;
        System.runAs(u){
            srt1.buildDuplicateAccessCodesLogic(srts);
            srt1.calculateExtendedHours(srts);
            srt1.TotalSRTHrs = 12.00;
            srt1.getExtendedHours(srts[7],true,3,3);
        }
        test.stopTest();
    }
    
    static Testmethod void testmethod1a()
    {
        Test.startTest();
        CG_CL_ClaimsSRTs claims = new CG_CL_ClaimsSRTs();
        //claims.nvClaimsFC();
        //claims.nvClaimsWC();
        //claims.nvClaimsIntake(); 
        /*claims.nvClaimsCC();
claims.nvClaimsVS();
claims.nvClaimsVH();
claims.nvClaimsSRTs();
claims.nvClaimsPOC();
claims.nvClaimsJobNotes();*/
        claims.claimsSRTAction();
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsSRTs;
        Test.setCurrentPage(pageRef); 
        String id = ApexPages.currentPage().getParameters().get('id');
        //claims.pgSave();
        Test.stopTest();
    }
    
    static testmethod void testmethod2()
    {
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=jo1.Id;
        clams.account__c = acc.id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=clams.Id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Primary__c=true;
        insert psn1;
        List<css_srt__c> lstsrt123 = new List<css_srt__c>();
        css_srt__c srt12 = new css_srt__c();
        srt12.CSS_Claims__c=clams.Id;
        srt12.Step_Id__c='1';
        srt12.Type__c='Diagnosis';
        lstsrt123.add(srt12);
        css_srt__c srt13 = new css_srt__c();
        srt13.CSS_Claims__c=clams.Id;
        srt13.Step_Id__c='1';
        srt13.Type__c='Repair';
        insert srt13;
        lstsrt123.add(srt13);
        css_srt__c srt14 = new css_srt__c();
        srt14.CSS_Claims__c=clams.Id;
        srt14.Step_Id__c='1';
        srt14.Type__c='Overlap';
        insert srt14;
        lstsrt123.add(srt14);
        css_srt__c srt15 = new css_srt__c();
        srt15.CSS_Claims__c=clams.Id;
        srt15.Step_Id__c='1';
        srt15.Type__c='Field Action';
        insert srt15;
        lstsrt123.add(srt15);
        css_claims__c clams1=[Select Id,(select id,Step_Id__c,name from CSS_SRTS__r limit 1) from css_claims__c limit 1];
        
        apexpages.currentPage().getparameters().put('id',clams.Id);
        test.startTest();
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        srt1.claimsOverlap=clams;
        srt1.nvClaimsIntake();
        srt1.nvClaimsWC();
        srt1.nvClaimsVH();
        srt1.nvClaimsCC();
        srt1.nvClaimsFC();
        srt1.nvClaimsPOC();
        srt1.nvClaimsSRTs();
        srt1.nvClaimsJobNotes();
        srt1.nvClaimsVS();
        //srt1.pgSave();
        srt1.resolveErrorNow();
        srt1.continueNext();
        srt1.saveTechTime();
        srt1.createOverlapSRT(null,null,lstsrt123);
        //srt1.loadRequestData();
        srt1.claimsSRTAction();
        srt1.populateMap(clams1);
        
        test.stopTest();
    }
    
    static testmethod void testmethod3()
    {
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
          CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'FSL_GETCampaignServices';
        conDetail1.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
        conDetail1.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
        conDetail1.IsActive__c = true;
        conDetail1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com';
        conDetail1.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
        insert conDetail1;  
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        conDetails.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
        conDetails.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
        conDetails.IsActive__c = true;
        conDetails.Method_Type__c = 'POST';
        conDetails.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.Region__c = ' KOREA';
        clams.CSS_Job__c=jo1.Id;
        clams.FieldActionWebServiceResult__c = 'Error';
        clams.Account__c = acc.id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=clams.Id;
        psn1.Failure_Date__c = system.today() +1;
        psn1.Warranty_Start_Date__c=system.today();
        insert psn1;
        css_srt__c srt12 = new css_srt__c();
        srt12.CSS_Claims__c=clams.Id;
        srt12.Step_Id__c='1';
        srt12.Type__c='Overlap';
        insert srt12;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        solCompObj.Service_Job__c = jo1.Id;
        solCompObj.Type__c = 'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        //solCompObj.CSS_Account_Formula__c ='123';
        solCompObj.Pay_Code__c='testPay';   
        solcompobj.CampaignLaborPercentage__c = '1';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        
        css_claims__c clams1=[Select Id,(select id,Step_Id__c,name from CSS_SRTS__r limit 1) from css_claims__c limit 1];
        apexpages.currentPage().getparameters().put('id',clams.Id);
        test.startTest(); 
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        //srt1.nvClaimsIntake();
        srt1.nvClaimsWC();
        srt1.nvClaimsVH();
        srt1.nvClaimsCC();
        srt1.nvClaimsFC();
        srt1.nvClaimsPOC();
        srt1.nvClaimsSRTs();
        srt1.nvClaimsJobNotes();
        srt1.nvClaimsVS();
        //srt1.pgSave();
        srt1.resolveErrorNow();
        srt1.continueNext();
        srt1.populateMap(clams1);
        //srt1.loadRequestData();
        srt1.claimsSRTAction();
        pagereference ref = new pagereference('/apex/CG_IntakeCustomer');
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',clams.Id);
        srt1.cId=clams.Id;
        srt1.techtime='2.0';
        srt1.saveTechTime();
        CG_BL_Campaigns camp = new CG_BL_Campaigns();
        CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger(psn1.id,'6/6/2019', 'Bangalore','', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', clams.Id);
        srt1.CampaignsWSCall();
        //srt1.claimSRTAction();
        test.stopTest();
    }
   
    static testmethod void testmethod4()
    {
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        test.startTest();
        
        Test.stopTest();
        
    }
    
    static testmethod void testmethod5()
    {
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        //clams.CSS_Job__c=jo1.Id;
        clams.Multi_PSN_Claim__c =true;
        clams.Actual_Technician_Time__c=2.0;
        clams.Information_Only_Claim__c = true;
        clams.Dealer_Service_Job__c = jo1.id;
        insert clams;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Data_ExChange_Admin'];
        Account objAcc = new Account(name ='Test Account',IAM_Service_Provider_Code__c='03742');
        insert objAcc; 
        
        Contact objContact = new Contact(LastName ='testCon', IAM_Cummins_login_ID__c = 'test@cummins.com' ,FirstName='testCon1' ,AccountId = objAcc.Id);
        objContact.Username__c ='UtilityTestUser2@testorg.com';
        insert objContact;  
        /* Account acc = new Account();
acc.name='Rtest';
acc.CSS_DistributorCode__c='03742';
acc.IAM_Service_Provider_Code__c='03742';
//  acc.Location__c = '12345-12345';

insert acc;*/
        User u = new User(Alias = 'standkal', Email='standarduser02@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser02@testorg.com',User_Location__c = '03742-03742',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=objAcc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        css_utility.getOrgType(UserId);
        
        apexpages.currentPage().getparameters().put('id',clams.Id);
        test.startTest();
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        srt1.showErrorPopup=true;
        System.runAs(u){
            //srt1.nvClaimsIntake();
            Test.stopTest();
        }
    }
    
    static testmethod void testmethod8()
    {
        CG_CL_ClaimsIntake cl = new CG_CL_ClaimsIntake();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        
        claim.Customer_Name__c='';
        claim.Customer_Code__c='';
        claim.Status__c='';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        cl.claimsRec=claim;
        ///apex/CG_ClaimsSRTs
        
        apexpages.currentPage().getparameters().put('id',claim.Id);
        CG_CL_ClaimsSRTs clamsrt = new CG_CL_ClaimsSRTs();
        //clamsrt.nvClaimsIntake();
        clamsrt.nvClaimsWC();
        clamsrt.nvClaimsVH();
        clamsrt.nvClaimsCC();
        clamsrt.nvClaimsFC();
        clamsrt.nvClaimsPOC();
        clamsrt.nvClaimsSRTs();
        clamsrt.nvClaimsJobNotes();
        clamsrt.nvClaimsVS();
        //clamsrt.pgSave();
        clamsrt.resolveErrorNow();
        clamsrt.continueNext();
        clamsrt.saveTechTime();
        CSS_OverlapSRTReq OverlapSRTReq1;
        //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq1);
        //srt1.loadRequestData();
        clamsrt.claimsSRTAction();
        
        
        
    }
    
    static testmethod void testmethod9()
    {
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        
        claim1.Customer_Name__c='Gopal';
        claim1.Customer_Code__c='123';
        claim1.CSS_Job__c = JO.id;
        claim1.Account__c= acc.id;
        claim1.Status__c='Draft';
        claim1.Actual_Technician_Time__c=1.2;
        claim1.ODM_Penalty__c='90';
        insert claim1;
        //c2.claimsRec=claim1;
        ///apex/CG_ClaimsSRTs
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        CSS_SRT__C diagSRT = new CSS_SRT__C();
        diagSRT.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT.Type__c='Diagnosis';
        diagSRT.SRT_Type__c='Diagnosis';
        diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT.SRT_ID__c='asd';
        diagSRT.SRT_Access_Code__c='asdf';
        diagSRT.Step_Description__c='Step Number-00';
        diagSRT.SRT_Quantity__c=1;
        diagSRT.isPerformed__c=True;
        diagSRT.SRT_Time__c=1.1;
        diagSRT.SRT_ORDER__C = 1;
        diagSRT.Assignment__c = 'PRIMARY';
        diagSRT.css_claims__c = claim1.id;
        SRTs.add(diagSRT);
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='99Time';
        diagSRT1.SRT_Type__c='99Time';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Step_Description__c='hgfr';
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        diagSRT1.srt_warrantable__c = '50';
        diagSRT1.isUserEntered__c = false;
        diagSRT1.css_claims__c = claim1.id;
        SRTs.add(diagSRT1);
        insert SRTs;
        
        apexpages.currentPage().getparameters().put('id',claim1.Id);
        CG_CL_ClaimsSRTs clamsrt1 = new CG_CL_ClaimsSRTs();
        //clamsrt1.nvClaimsIntake();
        clamsrt1.nvClaimsWC();
        clamsrt1.nvClaimsVH();
        clamsrt1.nvClaimsCC();
        clamsrt1.nvClaimsFC();
        clamsrt1.nvClaimsPOC();
        clamsrt1.nvClaimsSRTs();
        clamsrt1.nvClaimsJobNotes();
        clamsrt1.nvClaimsVS();
        //clamsrt1.pgSave();
        clamsrt1.resolveErrorNow();
        clamsrt1.continueNext();
        clamsrt1.saveTechTime();
        CSS_OverlapSRTReq OverlapSRTReq2;
        //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq2);
        //srt1.loadRequestData();
        clamsrt1.claimsSRTAction();
    }
    
    static testmethod void testmethod10()
    {
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        
        claim1.Customer_Name__c='Gopal';
        claim1.Customer_Code__c='123';
        claim1.CSS_Job__c = JO.id;
        claim1.Account__c = acc.id;
        
        claim1.Status__c='Draft';
        claim1.Actual_Technician_Time__c=1.2;
        claim1.ODM_Penalty__c='90';
        insert claim1;
        //c2.claimsRec=claim1;
        ///apex/CG_ClaimsSRTs
        CSS_JobEventTemporary__c jETPW = new CSS_JobEventTemporary__c();
        jETPW.Attribute1__c = 'NPW';
        jETPW.Attribute2__c = '62';
        jETPW.Attribute3__c = 'NEW PARTS WARRANTY';
        jETPW.key__C = 'AccountCodes';
        Insert JETPW;
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.css_claims__c = claim1.id;
        solComp.Action__c = '';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        solcomp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.CoveredLaborHrs__c = '2';
        solcomp.system_code__c = 'TH';
        solcomp.component_code__c = 'AC';
        solcomp.ODM_Penalty__c = '50';
        insert solcomp;
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        CSS_SRT__C diagSRT = new CSS_SRT__C();
        diagSRT.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT.Type__c='Diagnosis';
        diagSRT.SRT_Type__c='Diagnosis';
        diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT.SRT_ID__c='asd';
        diagSRT.SRT_Access_Code__c='asdf';
        diagSRT.Step_Description__c='Step Number-00';
        diagSRT.SRT_Quantity__c=1;
        diagSRT.isPerformed__c=True;
        diagSRT.SRT_Time__c=1.1;
        diagSRT.SRT_ORDER__C = 1;
        diagSRT.Assignment__c = 'PRIMARY';
        diagSRT.css_claims__c = claim1.id;
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT.isUserEntered__c = false;
        SRTs.add(diagSRT);
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='99Time';
        diagSRT1.SRT_Type__c='99Time';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Step_Description__c='hgfr';
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        diagSRT1.srt_warrantable__c = '50';
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT.failcode__c = 'TH-AC';
        diagSRT1.isUserEntered__c = true;
        diagSRT1.css_claims__c = claim1.id;
        SRTs.add(diagSRT1);
        insert SRTs;
        
        apexpages.currentPage().getparameters().put('id',claim1.Id);
        test.starttest();
        CG_CL_ClaimsSRTs clamsrt1 = new CG_CL_ClaimsSRTs();
        //clamsrt1.nvClaimsIntake();
        clamsrt1.nvClaimsWC();
        clamsrt1.nvClaimsVH();
        clamsrt1.nvClaimsCC();
        clamsrt1.nvClaimsFC();
        clamsrt1.nvClaimsPOC();
        clamsrt1.nvClaimsSRTs();
        clamsrt1.nvClaimsJobNotes();
        clamsrt1.nvClaimsVS();
        //clamsrt1.pgSave();
        clamsrt1.resolveErrorNow();
        clamsrt1.continueNext();
        clamsrt1.saveTechTime();
        CSS_OverlapSRTReq OverlapSRTReq2;
        //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq2);
        //srt1.loadRequestData();
        clamsrt1.claimsSRTAction();
        test.stoptest();
    }
    
    static testmethod void testmethod11()
    {
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        
        claim1.Customer_Name__c='Gopal';
        claim1.Customer_Code__c='123';
        claim1.Status__c='Draft';
        claim1.CSS_Job__c = JO.id;
        claim1.Account__c = acc.id;
        claim1.Actual_Technician_Time__c=1.2;
        claim1.ODM_Penalty__c='90';
        insert claim1;
        //c2.claimsRec=claim1;
        ///apex/CG_ClaimsSRTs
        CSS_JobEventTemporary__c jETPW = new CSS_JobEventTemporary__c();
        jETPW.Attribute1__c = 'NPW';
        jETPW.Attribute2__c = '62';
        jETPW.Attribute3__c = 'NEW PARTS WARRANTY';
        jETPW.key__C = 'AccountCodes';
        Insert JETPW;
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.css_claims__c = claim1.id;
        solComp.Action__c = '';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        solcomp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.CoveredLaborHrs__c = '2';
        solcomp.system_code__c = 'TH';
        solcomp.component_code__c = 'AC';
        solcomp.ODM_Penalty__c = '';
        insert solcomp;
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        CSS_SRT__C diagSRT = new CSS_SRT__C();
        diagSRT.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT.Type__c='Diag Access';
        diagSRT.SRT_Type__c='Diagnosis';
        diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT.SRT_ID__c='asd';
        diagSRT.SRT_Access_Code__c='asdf';
        diagSRT.SRT_AccessiblityCheck__c = true;
        diagSRT.Step_Description__c='Step Number-00';
        diagSRT.SRT_Quantity__c=1;
        diagSRT.isPerformed__c=True;
        diagSRT.SRT_Time__c=1.1;
        diagSRT.SRT_ORDER__C = 1;
        diagSRT.Assignment__c = 'PRIMARY';
        diagSRT.css_claims__c = claim1.id;
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT.failcode__c = 'THAC';
        diagSRT.isUserEntered__c = true;
        SRTs.add(diagSRT);
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='Access';
        diagSRT1.SRT_Type__c='99Time';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Step_Description__c='hgfr';
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        diagSRT1.srt_warrantable__c = '50';
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT1.failcode__c = 'THAC';
        diagSRT1.isUserEntered__c = true;
        diagSRT1.css_claims__c = claim1.id;
        SRTs.add(diagSRT1);
        insert SRTs;
        
        apexpages.currentPage().getparameters().put('id',claim1.Id);
        test.starttest();
        CG_CL_ClaimsSRTs clamsrt1 = new CG_CL_ClaimsSRTs();
        //clamsrt1.nvClaimsIntake();
        clamsrt1.nvClaimsWC();
        clamsrt1.nvClaimsVH();
        clamsrt1.nvClaimsCC();
        clamsrt1.nvClaimsFC();
        clamsrt1.nvClaimsPOC();
        clamsrt1.nvClaimsSRTs();
        clamsrt1.nvClaimsJobNotes();
        clamsrt1.nvClaimsVS();
        //clamsrt1.pgSave();
        clamsrt1.resolveErrorNow();
        clamsrt1.continueNext();
        clamsrt1.saveTechTime();
        CSS_OverlapSRTReq OverlapSRTReq2;
        //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq2);
        //srt1.loadRequestData();
        clamsrt1.claimsSRTAction();
        test.stoptest();
    }
    
    static testmethod void testmethod12()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        List<css_claims__c> clmList = new List<css_claims__c>();
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=jo1.Id;
        clams.Account__c =  acc.id;
        clams.Multi_PSN_Claim__c =true;
        clams.Actual_Technician_Time__c=2.0;
        clams.Location_Code__c = '03520-04892';
        clmList.add(clams);
        
        css_claims__c clams12 = new css_claims__c();
        clams12.Customer_Name__c='Gopal';
        clams12.Customer_Code__c='123';
        clams12.ESN__c='53426754';
        clams12.CSS_Job__c=jo1.Id;
        clams12.Multi_PSN_Claim__c =false;
        clams12.Actual_Technician_Time__c=2.0;
        clmList.add(clams12);
        
        insert clmList;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=clams.Id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jo1.Id);
        list<css_srt__c> lstSrt1= new list<css_srt__c>();    
        css_srt__c srt12 = new css_srt__c();
        srt12.CSS_Claims__c=clams.Id;
        srt12.Step_Id__c='1';
        srt12.Type__c='Overlap';
        srt12.SRT_Category__c='AdditionalDiag';
        srt12.SRT_AccessiblityCheck__c=true;
        srt12.isPerformed__c=true;
        srt12.SRT_ID__c='4-011';
        srt12.Solution_Number__c=solRef.Id;
        srt12.Account_Code__c='1';
        srt12.Override__c=True;
        //insert srt12;
        lstSrt1.add(srt12);
        css_srt__c srt13 = new css_srt__c();
        srt13.CSS_Claims__c=clams.Id;
        srt13.Step_Id__c='1';
        srt13.Type__c='Overlap';
        srt13.SRT_Category__c='AdditionalRep';
        srt13.SRT_AccessiblityCheck__c=true;
        srt13.isPerformed__c=true;
        srt13.SRT_ID__c='4-01';
        //insert srt13;
        lstSrt1.add(srt13);
        
        css_srt__c srt14 = new css_srt__c();
        srt14.CSS_Claims__c=clams.Id;
        srt14.Step_Id__c='1';
        srt14.Type__c='Overlap';
        srt14.SRT_Category__c='Campaign';
        srt14.SRT_AccessiblityCheck__c=true;
        srt14.isPerformed__c=true;
        srt14.SRT_ID__c='4-01';
        //insert srt13;
        lstSrt1.add(srt14);
        
        css_srt__c srt112 = new css_srt__c();
        srt112.CSS_Claims__c=clams.Id;
        srt112.Step_Id__c='1';
        srt112.Type__c='Overlap';
        srt112.SRT_Category__c='TRP';
        srt112.SRT_AccessiblityCheck__c=true;
        srt112.isPerformed__c=true;
        srt112.SRT_ID__c='4-01';
        //insert srt13;
        lstSrt1.add(srt112);
        
        css_srt__c srt113 = new css_srt__c();
        srt113.CSS_Claims__c=clams.Id;
        srt113.Step_Id__c='1';
        srt113.Type__c='Overlap';
        srt113.SRT_Category__c='ATC';
        srt113.SRT_AccessiblityCheck__c=true;
        srt113.isPerformed__c=true;
        srt113.SRT_ID__c='4-01';
        //insert srt13;
        lstSrt1.add(srt113);
        
        css_srt__c srt15 = new css_srt__c();
        srt15.CSS_Claims__c=clams.Id;
        srt15.Step_Id__c='1';
        srt15.Type__c='Field Action';
        srt15.SRT_Category__c='AdditionalDiag';
        srt15.SRT_AccessiblityCheck__c=true;
        srt15.isPerformed__c=true;
        srt15.SRT_ID__c='4';
        //insert srt15;
        lstSrt1.add(srt15);
        css_claims__c clams1=[Select Id,(select id,Step_Id__c,name from CSS_SRTS__r limit 1) from css_claims__c limit 1];
        
        CSS_Job_Order__c JO11 = new CSS_Job_Order__c();
        JO11.Customer_Name__c = 'CumminsTnD';
        JO11.Equipment_ID__c = 'EQ7667';
        JO11.Qsol_Engine_Family_Code__c ='56';
        JO11.AccessCode__c = 'A';
        insert JO11;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO11.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        CSS_Solution_Component__c solCom = CSS_TestData.createSRT(true,JO11.ID , solAdd.id);
        solCom.CSS_Claims__c =clams.Id;
        solCom.Selected_Component__c = true;
        solCom.Status__c='Approved';
        solCom.Type__c='Campaign';
        update solCom;        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Data_ExChange_Admin'];
        Account objAcc = new Account(name ='Test Account',IAM_Service_Provider_Code__c='03742',Type='Dealer Account');
        insert objAcc; 
        
        Contact objContact = new Contact(LastName ='testCon',IAM_Cummins_login_ID__c = 'test@cummins.com' ,FirstName='testCon1' ,AccountId = objAcc.Id);
        objContact.Username__c ='UtilityTestUser2@testorg.com';
        insert objContact;  
        Account acc1 = new Account();
        acc1.id = objAcc.id;
        acc1.name='Rtest';
        acc1.CSS_DistributorCode__c='03742';
        acc1.IAM_Service_Provider_Code__c='03742';
        acc1.Region__c = 'US and Canada';
        acc1.CMI_Account_Status__c = 'Active';
        //  acc.Location__c = '12345-12345';
        
        upsert acc1;
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '03742-03742',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc1.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        css_utility.getOrgType(UserId);
        
        apexpages.currentPage().getparameters().put('id',clams.Id);
        
        
        test.startTest();
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        srt1.showErrorPopup=false;
        System.runAs(u){
            String locationcode ='19134';
            //srt1.nvClaimsIntake();
            // srt1.nvClaimsWC();
            //srt1.nvClaimsVH();
            //srt1.nvClaimsCC();
            //srt1.nvClaimsFC();
            //srt1.nvClaimsPOC();
            //srt1.nvClaimsSRTs();
            //srt1.nvClaimsJobNotes();
            // srt1.nvClaimsVS();
            //srt1.pgSave();
            srt1.resolveErrorNow();
            srt1.continueNext();
            srt1.saveTechTime();
            CSS_OverlapSRTReq OverlapSRTReq;
            //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq);
            // srt1.loadRequestData();
            srt1.claimsSRTAction();
            srt1.populateMap(clams1);
            //srt1.claimSRTAction();
            //srt1.nvClaimsPSN();
            srt1.overlapSRTCallout('AccTest',lstSrt1);
            srt1.checkDuplicateSRTs();
        }
        test.stopTest();
    }
    
    static testmethod void testmethod13()
    {
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        
        CSS_Claims__c claim5 = new CSS_Claims__c();
        claim5.Customer_Name__c='Gopal';
        claim5.CSS_Job__c=JO.id;
        claim5.Account__c = acc.id;
        claim5.Customer_Code__c='123';
        //claim5.Total_PSN_Count__c = 12;
        claim5.Status__c='Draft';
        claim5.Actual_Technician_Time__c=1.2;
        insert claim5;
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=claim5.Id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Primary__c=true;
        insert psn1;
        
        
        
        List<css_srt__c> lstSrt13=new List<css_srt__c>();
        css_srt__c srt13 = new css_srt__c();
        srt13.CSS_Claims__c=claim5.Id;
        srt13.Step_Id__c='1';
        srt13.Type__c='Overlap';
        srt13.SRT_Category__c='AdditionalRep';
        srt13.SRT_AccessiblityCheck__c=true;
        srt13.isPerformed__c=true;
        srt13.SRT_ID__c='00-901-00';
        srt13.SRT_Warrantable__c='100';
        lstSrt13.add(srt13);
        insert lstSrt13;
        
        //apexpages.currentPage().getparameters().put('id',claim5.Id);
        test.startTest();
        CG_CL_ClaimsSRTs srt134 = new CG_CL_ClaimsSRTs();
        srt134.updateSRTs();
        test.stopTest();
    }
    
    static testmethod void testmethod14()
    {
        CSS_Claims__c claim14 = new CSS_Claims__c();
        claim14.Customer_Name__c='Gopal';
        claim14.Customer_Code__c='123';
        claim14.Status__c='Draft';
        claim14.Actual_Technician_Time__c=1.2;
        insert claim14;
        apexpages.currentPage().getparameters().put('id',claim14.Id);
        test.startTest();
        CG_CL_ClaimsSRTs srt135 = new CG_CL_ClaimsSRTs();
        srt135.showErrorPopup=false;
        srt135.cId=null;
        srt135.pageName='Test';
        srt135.overlapSRTCallout('AccTest',null);
        //srt135.pgSave();
        srt135.continueNext();
        srt135.nvClaimsVS();
        srt135.nvClaimsJobNotes();
        srt135.nvClaimsSRTs();
        srt135.nvClaimsPOC();
        test.stopTest();
    }
    
    static testmethod void testmethod15()
    {
        CSS_Claims__c claim15 = new CSS_Claims__c();
        claim15.Customer_Name__c='Gopal';
        claim15.Customer_Code__c='123';
        claim15.Status__c='Draft';
        claim15.Actual_Technician_Time__c=1.2;
        insert claim15;
        apexpages.currentPage().getparameters().put('id',claim15.Id);
        test.startTest();
        CG_CL_ClaimsSRTs srt137 = new CG_CL_ClaimsSRTs();
        srt137.showErrorPopup=true;
        srt137.cId=null;
        srt137.pageName=null;
        srt137.overlapSRTCallout('AccTest',null);
        ///srt137.pgSave();
        srt137.continueNext();
        test.stopTest();
    }
    
    static testmethod void testmethod16()
    {
        CSS_Claims__c claim16 = new CSS_Claims__c();
        claim16.Customer_Name__c='Gopal';
        claim16.Customer_Code__c='123';
        claim16.Status__c='Draft';
        claim16.Actual_Technician_Time__c=1.2;
        insert claim16;
        apexpages.currentPage().getparameters().put('id',claim16.Id);
        ApexPages.currentPage().getParameters().put('url','http://google.com');
        test.startTest();
        CG_CL_ClaimsSRTs srt137 = new CG_CL_ClaimsSRTs();
        srt137.cId=null;
        srt137.showErrorPopup=false;
        srt137.nvClaimsPSN();
        srt137.nvClaimsIntake();
        srt137.nvClaimsWC();
        srt137.nvClaimsVH();
        srt137.nvClaimsCC();
        srt137.nvClaimsFC();
        //srt137.pgSave();
        test.stopTest();
    }
    
    static testmethod void testmethod17()
    {
        CSS_Claims__c claim16 = new CSS_Claims__c();
        claim16.Customer_Name__c='Gopal';
        //claim16.Information_Only_Claim__c = true;
        claim16.Customer_Code__c='123';
        claim16.Status__c='Draft';
        claim16.Actual_Technician_Time__c=1.2;
        insert claim16; 
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        apexpages.currentPage().getparameters().put('id',claim16.Id);
        test.startTest();
        CG_CL_ClaimsSRTs obj = new CG_CL_ClaimsSRTs();
        obj.nvClaimsIntake();
        obj.getOlapReasonMsgFlag();  
        obj.nvClaimsWC();
        obj.nvClaimsVH();
        obj.nvClaimsCC();
        obj.nvClaimsFC();
        obj.nvClaimsPSN();
        obj.nvClaimsPOC();
        obj.nvClaimsSRTs();
        obj.nvClaimsJobNotes();
        obj.nvClaimsVS();
    }
    
    static testmethod void testmethod18()
    {
        CSS_Claims__c claim16 = new CSS_Claims__c();
        claim16.Customer_Name__c='Gopal';
        claim16.Information_Only_Claim__c = false;
        claim16.Customer_Code__c='123';
        claim16.Status__c='Draft';
        claim16.Actual_Technician_Time__c=1.2;
        insert claim16; 
        
        apexpages.currentPage().getparameters().put('id',claim16.Id);
        test.startTest();
        CG_CL_ClaimsSRTs obj = new CG_CL_ClaimsSRTs();
        obj.nvClaimsIntake();
        obj.getOlapReasonMsgFlag();  
        obj.nvClaimsWC();
        obj.nvClaimsVH();
        obj.nvClaimsCC();
        obj.nvClaimsFC();
        obj.nvClaimsPSN();
        obj.nvClaimsPOC();
        obj.nvClaimsSRTs();
        obj.nvClaimsJobNotes();
        obj.nvClaimsVS();
    }
    
    static testmethod void testmethod19()
    {
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Account__c = acc.id;
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        insert JO;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        List<CSS_SRT__C> srtlst = new List<CSS_SRT__C>();
        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.Solution_Number__c = solAdd.id;
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 8656;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Step_Id__c = '2';
        srtAddiRepAccess1.Type__c = 'Repair';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess1.Assignment__c = 'Primary';
        insert srtAddiRepAccess1;
        
        CSS_SRT__C srtAddiRepAccess2 = new CSS_SRT__C();
        srtAddiRepAccess2.Solution_Number__c = solAdd.id;
        srtAddiRepAccess2.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess2.SRT_Time__c = 8656;
        srtAddiRepAccess2.SRT_Quantity__c=1;
        srtAddiRepAccess2.Job_Order__c = JO.id;
        srtAddiRepAccess2.name = 'Test';
        srtAddiRepAccess2.Type__c = 'Repair';
        srtAddiRepAccess2.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess2.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess2.Assignment__c = 'Primary';
        insert srtAddiRepAccess2;
        
        srtlst.add(srtAddiRepAccess1);
        srtlst.add(srtAddiRepAccess2);
        
        Test.startTest();
        CG_CL_ClaimsSRTs srt1 = new CG_CL_ClaimsSRTs();
        srt1.mutualOverlapSRTCallout(srtlst);
        Test.stopTest();
    }
    
    static testmethod void testmethod20()
    {
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        
        claim1.Customer_Name__c='Gopal';
        claim1.Customer_Code__c='123';
        claim1.Status__c='Draft';
        claim1.CSS_Job__c = JO.id;
        claim1.Account__c = acc.id;
        claim1.Actual_Technician_Time__c=1.2;
        claim1.ODM_Penalty__c='90';
        insert claim1;
        //c2.claimsRec=claim1;
        ///apex/CG_ClaimsSRTs
        CSS_JobEventTemporary__c jETPW = new CSS_JobEventTemporary__c();
        jETPW.Attribute1__c = 'NPW';
        jETPW.Attribute2__c = '62';
        jETPW.Attribute3__c = 'NEW PARTS WARRANTY';
        jETPW.key__C = 'AccountCodes';
        Insert JETPW;
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.css_claims__c = claim1.id;
        solComp.Action__c = '';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        solcomp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.CoveredLaborHrs__c = '2';
        solcomp.system_code__c = 'TH';
        solcomp.component_code__c = 'AC';
        solcomp.ODM_Penalty__c = '';
        insert solcomp;
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        CSS_SRT__C diagSRT = new CSS_SRT__C();
        diagSRT.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT.Type__c='Field Action';
        diagSRT.SRT_Type__c='Diagnosis';
        diagSRT.Access_Code__c = 'aka';
        diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT.SRT_ID__c='asd';
        diagSRT.SRT_Access_Code__c='asdf';
        //diagSRT.SRT_AccessiblityCheck__c = true;
        diagSRT.Step_Description__c='Step Number-00';
        diagSRT.SRT_Quantity__c=1;
        diagSRT.isPerformed__c=True;
        diagSRT.SRT_Time__c=1.1;
        diagSRT.SRT_ORDER__C = 1;
        diagSRT.Assignment__c = 'PRIMARY';
        diagSRT.css_claims__c = claim1.id;
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT.failcode__c = 'THAC';
        diagSRT.isUserEntered__c = true;
        SRTs.add(diagSRT);
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='Access';
        diagSRT1.SRT_Type__c='99Time';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Step_Description__c='hgfr';
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        diagSRT1.srt_warrantable__c = '100';
        diagSRT.Account_Code__c = 'NEW PARTS WARRANTY 62';
        diagSRT1.failcode__c = 'THAC';
        diagSRT1.isUserEntered__c = true;
        diagSRT1.css_claims__c = claim1.id;
        SRTs.add(diagSRT1);
        insert SRTs;
        
        apexpages.currentPage().getparameters().put('id',claim1.Id);
        test.starttest();
        CG_CL_ClaimsSRTs clamsrt1 = new CG_CL_ClaimsSRTs();
        //clamsrt1.nvClaimsIntake();
        clamsrt1.nvClaimsWC();
        clamsrt1.nvClaimsVH();
        clamsrt1.nvClaimsCC();
        clamsrt1.nvClaimsFC();
        clamsrt1.nvClaimsPOC();
        clamsrt1.nvClaimsSRTs();
        clamsrt1.nvClaimsJobNotes();
        clamsrt1.nvClaimsVS();
        //clamsrt1.pgSave();
        clamsrt1.resolveErrorNow();
        clamsrt1.continueNext();
        clamsrt1.saveTechTime();
        CSS_OverlapSRTReq OverlapSRTReq2;
        //CSS_WS_SRT.getOverlapSRTRecords(OverlapSRTReq2);
        //srt1.loadRequestData();
        clamsrt1.claimsSRTAction();
        test.stoptest();
    }
}