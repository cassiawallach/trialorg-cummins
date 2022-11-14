@IsTest(SeeAllData=false)
// @IsTest corrected on 09/13/2016 as part of 09/10/2016 PROD Push
public class CSS_TndRepOverControllerNew_Test{
      //CSS_TndRepOverController obj = new CSS_TndRepOverController();
      //obj.HHSPACCSFlg = true;
    public static CSS_Fault_Code__c createFaultCode(CSS_Job_Order__c job, String fcCode,Integer seq,String mod,String fcType,String relFC){
        CSS_Fault_Code__c fc = new CSS_Fault_Code__c(FaultCodeR2__c = fcCode,Related_Fault_Code__c = relFC);
        fc.Name = fcCode;
        fc.Job_Order__c = job.Id;
        fc.Sequence__c = seq;
        fc.Fault_Code_Type__c = fcType;
        fc.Mod__c = mod;
        fc.isPole__c = false;
        insert fc;
        return fc;
    }
    public static CSS_Solutions__c createSolutionDets(CSS_Job_Order__c job,CSS_Fault_Code__c fc, String title,String csName){
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.FaultCode__c = fc.Id;
        sol.Service_Job__c = job.Id; 
        sol.Name = csName;
        sol.Case_Name__c = csName;
        sol.Solution_Title__c = title;
        insert sol;
        return sol;
    }    
    static testMethod void CSS_TndRepOverController_test_Method1(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Account__c=acc.id;
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.BMSStatus__c = 'Pass';
        jobOrder.Before_In_Service__c = true;
        jobOrder.Mileage__c = 122;
        jobOrder.Mileage_Measure__c = 'Miles';
        jobOrder.INSITE_UpdateTimeStamp__c = system.now()-1;
        jobOrder.Application_Desc__c = 'test1';
        jobOrder.Make__c = 'Make1';
        jobOrder.Model__c = 'Model2';
        jobOrder.GTIS_Message_Type__c = 123;
        joborder.PSN_Not_Available__c = true;
        jobOrder.DisplayGtis__c = false;
        jobOrder.ESN__c = '1234';
        jobOrder.Customer_Name__c = 'ABC';
        jobOrder.Insite_ESN2_Select__c = true;

        //jobOrder.DSID__c = '213213';
        insert jobOrder;
        CSS_Fault_Code__c fc5 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol5 = new CSS_Solutions__c();
        sol5.FaultCode__c = fc5.Id;
        sol5.Service_Job__c = jobOrder.Id;
        sol5.Name = 'Sample Case Name';
        sol5.Case_Name__c = 'Sample Case Name';
        sol5.Solution_Title__c = 'Sample Title';
        sol5.Rank__c=3;
        insert sol5;
        
        CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
        srtComp.Solutions__c = sol5.id;
        srtComp.Quantity__c = 1;
        srtComp.Action__c='asdsad';
        srtComp.Service_Job__c =jobOrder.id;
        srtComp.Selected_Component__c = true;
        insert srtComp;
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_Job__c=JobOrder.id;
        parts1.FailurepartId__c = srtComp.Id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        insert parts1;
        
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
        CSS_TndRepOverController obj = new CSS_TndRepOverController();
        obj.HHSPACCSFlg = true;
        obj.showESNLockPopUp();
        obj.getrankDetails();
        obj.getPartDetails();
        obj.createDSIDAndBMSLookupInPgFcRefresh();
        
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Selected_Component__c = true;
        insert csc;

        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;

        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        

        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','DP','121,131');
        List<CSS_Fault_Code__c> fcList = new List<CSS_Fault_Code__c>();
        fcList.add(fc1);
        fcList.add(fc2);
        fcList.add(fc3);
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
       CSS_TndRepOverController tnd = new CSS_TndRepOverController();
       
        tnd.Ins_JobId=jobOrder.id;
        tnd.pageName = 'TND';
        PageReference pageRef = new PageReference('/apex/test?id=');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('pageName','TND');

        CSS_TndRepOverController.faultcodeswrapper fw= new CSS_TndRepOverController.faultcodeswrapper(fcList,fcList,'0','Primary',String.ValueOf(system.today()), true);
        List<CSS_TndRepOverController.faultcodeswrapper> ab=new List<CSS_TndRepOverController.faultcodeswrapper>();
        ab.add(fw);
        CSS_TndRepOverController.AllOtherFCWrapper alfw= new CSS_TndRepOverController.AllOtherFCWrapper (ab,system.today(),String.ValueOf(system.today()));            
        alfw.compareTo(alfw);  
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        tnd.pgChInsiteESN();
        tnd.pgChJoESN();
        tnd.pgCancelClose();
        tnd.pgFCRefresh();
        tnd.showINncPopup();
        tnd.closeINncPopup();
        tnd.invokeLaunchInsite();
        tnd.getAllOtherFCWrapper();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());        
        tnd.faultCodeClick();
        tnd.getAllSolDetails();
        tnd.getVerSolDetails();
        tnd.getRepairDetails();
        tnd.getDiagSRTDetails();
        tnd.getRepSRTDetails(); 
        tnd.getSolutions();
        tnd.repsol1();
        tnd.createDSID();
        tnd.redirectGtis(1);
        tnd.redirectGtis(2);
        tnd.showGitsPopup();
        tnd.closeGitsPopup();
        List<Id> jobIds = new List<Id>();       
        jobIds.add(jobOrder.id);
        tnd.sftdDate = '1231';
        tnd.isPrioritized = false;
        tnd.poleWarningMsg = false;
        tnd.poleVerified = false;
        CSS_TndRepOverController.UpdateGTIS(jobIds,1);
        CSS_TndRepOverController.UpdateGTIS(jobIds,2);
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());
        tnd.takeControl();
        Test.stopTest();        
    }
    static testMethod void CSS_TndRepOverController_test_Method2(){
        
         Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Account__c=acc.id;
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.INSITE_UpdateTimeStamp__c = system.now()-1;
        jobOrder.GTIS_Message_Type__c = 123;
        jobOrder.DisplayGtis__c = false;
        jobOrder.ESN__c = '1234';
        jobOrder.Customer_Name__c = 'ABC';
        jobOrder.Insite_ESN2__c = '123';
        jobOrder.Insite_ESN2_Select__c = true;
        //jobOrder.DSID__c = '213213';
        insert jobOrder;
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
        CSS_TndRepOverController obj = new CSS_TndRepOverController();
        obj.HHSPACCSFlg = true;
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Selected_Component__c = true;
        insert csc;

        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;

        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        

        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','DP','121,131');
        List<CSS_Fault_Code__c> fcList = new List<CSS_Fault_Code__c>();
        fcList.add(fc1);
        fcList.add(fc2);
        fcList.add(fc3);
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
        CSS_TndRepOverController  tnd=new CSS_TndRepOverController ();
        tnd.Ins_JobId=jobOrder.id;
        tnd.pageName = 'TND';
        PageReference pageRef = new PageReference('/apex/test?id=');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('pageName','TND');

        CSS_TndRepOverController.faultcodeswrapper fw= new CSS_TndRepOverController.faultcodeswrapper(fcList,fcList,'0','Primary',String.ValueOf(system.today()), true);
        List<CSS_TndRepOverController.faultcodeswrapper> ab=new List<CSS_TndRepOverController.faultcodeswrapper>();
        ab.add(fw);
        CSS_TndRepOverController.AllOtherFCWrapper alfw= new CSS_TndRepOverController.AllOtherFCWrapper (ab,system.today(),String.ValueOf(system.today()));            
        alfw.compareTo(alfw);  
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        tnd.isReadUser = false;
        tnd.dSidIndi = 'N';
        // tnd.pgChInsiteESN();
        tnd.pgChJoESN();
        tnd.pgCancelClose();
        tnd.pgFCRefresh();
        tnd.showINncPopup();
        tnd.closeINncPopup();
        tnd.invokeLaunchInsite();
        tnd.getAllOtherFCWrapper();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());        
        tnd.faultCodeClick();
        tnd.getAllSolDetails();
        tnd.showESNLockPopUp();
        tnd.getVerSolDetails();
        tnd.getRepairDetails();
        tnd.getDiagSRTDetails();
        tnd.getRepSRTDetails(); 
        tnd.getSolutions();
        tnd.repsol1();
        tnd.createDSID();
        tnd.redirectGtis(1);
        tnd.redirectGtis(2);
        tnd.showGitsPopup();
        tnd.closeGitsPopup();
        List<Id> jobIds = new List<Id>();       
        jobIds.add(jobOrder.id);
        tnd.sftdDate = '1231';
        tnd.isPrioritized = false;
        tnd.poleWarningMsg = false;
        tnd.poleVerified = false;
        CSS_TndRepOverController.UpdateGTIS(jobIds,1);
        CSS_TndRepOverController.UpdateGTIS(jobIds,2);
        tnd.takeControl();
        Test.stopTest();        
    }


    static testMethod void CSS_TndRepOverController_getSolutions(){
        User usr = new User();
        Usr.User_Location__c = '56270-56255';
        Usr.Username = 'pesari.anirudh@cummins.com';
        Usr.LastName = 'Reddy';
        Usr.Email = 'pesari.anirudh@cummins.com';
        Usr.Alias = 'Preddy';
        Usr.CommunityNickname = 'nw792';
        Usr.TimeZoneSidKey = 'America/Panama';
        Usr.LocaleSidKey = 'en_US';
        Usr.EmailEncodingKey = 'ISO-8859-1';
        Usr.ProfileId = '00e61000000sNkc';
        Usr.LanguageLocaleKey = 'en_US';
        insert usr;

        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Account__c=acc.id;
        jobOrder.Status__c = 'Created/Not Assigned';
        joborder.DSID__c = 'DSED';
        joborder.Customer_Name__c = 'derr';
        joborder.BMSStatus__c = 'pass';
        joborder.Unit_Number__c = '1234';
        joborder.DSID_Creation_Timestamp__c = system.now();
        joborder.DSID_Status__c = 'open';
        joborder.ESN_Locked__c = true;
        jobOrder.INSITE_UpdateTimeStamp__c = system.now()-1;
        jobOrder.GTIS_Message_Type__c = 123;
        jobOrder.DisplayGtis__c = false;
        date myDate = date.today();
        //date weekStart = myDate.toStartofWeek();

        joborder.Warranty_Start_Date__c =myDate ;
        joborder.Before_In_Service__c = false;
        jobOrder.ESN__c = '1234';
        jobOrder.Customer_Name__c = 'ABC';
        jobOrder.Insite_ESN2__c = '123';
        jobOrder.Customer_Code__c = '234';
        jobOrder.Insite_ESN2_Select__c = true;
        joborder.INSITE_ESN_Choice__c = 'Overwrite ESN';
        //jobOrder.DSID__c = '213213';
        insert jobOrder;
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        insert csc;
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);

        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;

        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.isPerformed__c = true;
        srt2.SRT_Time__c=60.0;
        insert srt2;        

        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.isPerformed__c = true;
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','DP','121,131');
        List<CSS_Fault_Code__c> fcList = new List<CSS_Fault_Code__c>();
        fcList.add(fc1);
        fcList.add(fc2);
        fcList.add(fc3);
        
        CSS_TndRepOverController  tnd=new CSS_TndRepOverController();
        tnd.bmsEnabled = true;
        tnd.Ins_JobId=jobOrder.id;
        tnd.pageName = 'TND';
        PageReference pageRef = new PageReference('/apex/test?id=');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('pageName','TND');

        CSS_TndRepOverController.faultcodeswrapper fw= new CSS_TndRepOverController.faultcodeswrapper(fcList,fcList,'0','Primary',String.ValueOf(system.today()), true);
        List<CSS_TndRepOverController.faultcodeswrapper> ab=new List<CSS_TndRepOverController.faultcodeswrapper>();
        ab.add(fw);
        CSS_TndRepOverController.AllOtherFCWrapper alfw= new CSS_TndRepOverController.AllOtherFCWrapper (ab,system.today(),String.ValueOf(system.today()));            
        alfw.compareTo(alfw);  
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        tnd.isReadUser = false;
        tnd.sServiceModel = 'WDER';
        tnd.selectedReltdFaulcode = 'yes';
        tnd.displayHHPPopup1 = true;
        tnd.displayHHPPopup2 = false;
        tnd.dSidIndi = 'N';
        tnd.pgChJoESN();
        tnd.pgCancelClose();
        tnd.showESNLockPopUp();

        tnd.pgFCRefresh();

        tnd.showINncPopup();
        tnd.closeINncPopup();
        tnd.invokeLaunchInsite();
        tnd.getAllOtherFCWrapper();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());        
        tnd.faultCodeClick();
        tnd.getAllSolDetails();
        tnd.getVerSolDetails();
        tnd.getRepairDetails();
        tnd.getDiagSRTDetails();
        tnd.getRepSRTDetails(); 
        tnd.getSolutions();
        tnd.repsol1();
        tnd.createDSID();
        tnd.redirectGtis(1);
        tnd.redirectGtis(2);
        tnd.showGitsPopup();
        tnd.closeGitsPopup();
        List<Id> jobIds = new List<Id>();       
        jobIds.add(jobOrder.id);
        tnd.sftdDate = '1231';
        tnd.isPrioritized = false;
        tnd.poleWarningMsg = false;
        tnd.poleVerified = false;
        tnd.solutionNumber('DSBDT4729');  
        CSS_TndRepOverController.UpdateGTIS(jobIds,1);
        CSS_TndRepOverController.UpdateGTIS(jobIds,2);
        tnd.takeControl();
        //tnd.callCreateWoAndUpdateComment();
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_UnitOutboundMockup_Test()); 
        tnd.getBMSUnitDetails('79462880');
        tnd.selectedUnitNumber = '12345';
        tnd.selectedBMSUnitNumber();
        tnd.HHSPSMNFlg = true;
        tnd.HHSPACCSFlg = false;
        tnd.pgSaveFinish();
        tnd.closeSrvModPopup();
        tnd.closeBMSUnitDetails();
        //tnd.bmsEnabled = true;
        tnd.createDSIDAndBMSLookup();
        tnd.selectedUnitDetails();
        tnd.HHSPACCSFlg = true;
        tnd.pgChInsiteESN();

        Test.stopTest();        
    }

    static testMethod void testMethod4() {
        

        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Anirudh';
        JO.Application_Desc__c = 'test1';
        JO.Model__c = 'AnirudhTest';
        JO.Make__c = 'CSSTest';
        JO.Failure_Point__c = 122;
        JO.Mileage__c = 122;
        JO.Mileage_Measure__c = 'Miles';
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Application__c = 'Automotive';
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        JO.Assigned_To__c = UserInfo.getUserId();
        JO.esn__c = '79464646';
        JO.Country__c = 'United States';
        JO.CSS_State__c = 'Indiana';
        JO.City__c = 'Columbus';
        JO.Customer_Code__c = '';
        insert(JO);
        
        ApexPages.CurrentPage().getParameters().put('id',JO.id);
        CSS_TndRepOverController tndJob = new CSS_TndRepOverController();
         Test.startTest();
        CSS_CampTsbTrp__c cssTrp = new CSS_CampTsbTrp__c();
            cssTrp.Name = 'Test Trp';
            cssTrp.Job_Order__c = Jo.id;
            cssTrp.performed_review__c = true;
            cssTrp.performed__c = false;
            cssTrp.Cu_Language__c = 'Hindi';
            insert cssTrp;
        CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
        hhp.Name = 'AnirudhTest';
            hhp.Listof_HHP_SMN__c = 'testdata';
        insert hhp;
            //Inserting test data for CSS_accountLanguage__c accountlang
            CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
            
            Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            
        tndJob.startRequest('794629','AnirudhTest');
        Test.stopTest();   
    }

    static testMethod void engineDataSiebel() {
system.debug('Test**Kal');
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='QSOL Auth Token';
        condetails.ApplicationName__c='QSOL Soft';
        condetails.AuthEnv__c='QSOL Auth Tokens';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='GetWattantyDocsforQsolREST';
        condetails1.ApplicationName__c='QSOL Soft';
        condetails1.AuthEnv__c='QSOL Auth Token';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs; 
        string json ='{"apiToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw","ResponseCode":"200"}';
       string json1  ='[{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TSB","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"}, { "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TRP","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"ATC","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{"documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"CAMPAIGN","language":"en","status":"OPEN", "documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html" }]';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TSB&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TRP&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=ATC&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=CAMPAIGN&language=en',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        test.startTest();
        CG_SL_QSOL.getQSOLWarrantyDocs('a0529000004V3BYAA0',null, '79664889', 'en', new list<string> {'TSB','ATC','TRP','CAMPAIGN'});
        test.stopTest();
    }
    static testMethod void CG_SL_QSOLService2(){
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
            
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='GetEngineDataPlateQSOLREST';
        condetails1.ApplicationName__c='QSOL Soft';
        condetails1.AuthEnv__c='QSOL Auth Token';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs; 
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CG_BLIntakeMock_Test());
        system.debug('Test**Kal1');
        
        CSS_Job_Order__c JOsr = new CSS_Job_Order__c();
        JOsr.ESN__c = '79384192';
        JOsr.Make__c = 'Msake';
        JOsr.Model__c = 'Model';
        insert JOsr;
        ApexPages.CurrentPage().getParameters().put('id',JOsr.id);
        CSS_TndRepOverController IntakeJobRstartReq = new CSS_TndRepOverController();
        IntakeJobRstartReq.filterMake = 'aknaksha';
        IntakeJobRstartReq.filterModel = 'Ridhima';
        CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
        hhp.name = 'SX15 CM2350 X101';
        hhp.Listof_HHP_SMN__c = 'SX15 CM2350 X101';
        insert hhp;
        Test.startTest();
        IntakeJobRstartReq.rJobOrd = JOsr;

        CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
        CSS_getEngineDataResponseJ2A engineData;
        CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
        jidi.ESN = JOsr.ESN__c;
        wrapobj.DataArea = jidi;


        engineData = CSS_WS_SBL.getEngineData(wrapobj);
        IntakeJobRstartReq.startRequest('794629','AnirudhTest');
        // IntakeJobRstartReq.pgSaveFinish();
        Test.stopTest();
    }
    static testMethod void CSS_TndRepOverController_getSolutions1(){
        User usr = new User();
        Usr.User_Location__c = '56270-56255';
        Usr.Username = 'pesari.anirudh@cummins.com';
        Usr.LastName = 'Reddy';
        Usr.Email = 'pesari.anirudh@cummins.com';
        Usr.Alias = 'Preddy';
        Usr.CommunityNickname = 'nw792';
        Usr.TimeZoneSidKey = 'America/Panama';
        Usr.LocaleSidKey = 'en_US';
        Usr.EmailEncodingKey = 'ISO-8859-1';
        Usr.ProfileId = '00e61000000sNkc';
        Usr.LanguageLocaleKey = 'en_US';
        insert usr;

        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Account__c=acc.id;
        jobOrder.Status__c = 'Created/Not Assigned';
        joborder.DSID__c = 'DSED';
        joborder.Customer_Name__c = 'derr';
        joborder.BMSStatus__c = 'pass';
        joborder.Unit_Number__c = '1234';
        joborder.DSID_Creation_Timestamp__c = system.now();
        joborder.DSID_Status__c = 'open';
        joborder.ESN_Locked__c = true;
        joborder.Application_Desc__c = 'test123';
        joborder.Make__c = 'Make123';
        joborder.Model__c = 'Model123';
        joborder.Mileage__c=122;
        joborder.Mileage_Measure__c = 'Miles';
        jobOrder.INSITE_UpdateTimeStamp__c = system.now()-1;
        jobOrder.GTIS_Message_Type__c = 123;
        jobOrder.DisplayGtis__c = false;
        date myDate = date.today();
        //date weekStart = myDate.toStartofWeek();

        joborder.Warranty_Start_Date__c =myDate ;
        joborder.Before_In_Service__c = false;
        jobOrder.ESN__c = '1234';
        jobOrder.Customer_Name__c = 'ABC';
        jobOrder.Insite_ESN2__c = '123';
        jobOrder.Insite_ESN2_Select__c = true;
        joborder.INSITE_ESN_Choice__c = 'Overwrite ESN';
        //jobOrder.DSID__c = '213213';
        insert jobOrder;
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        insert csc;

        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;

        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        

        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','DP','121,131');
        List<CSS_Fault_Code__c> fcList = new List<CSS_Fault_Code__c>();
        fcList.add(fc1);
        fcList.add(fc2);
        fcList.add(fc3);
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
        CSS_TndRepOverController  tnd=new CSS_TndRepOverController();
        
        tnd.Ins_JobId=jobOrder.id;
        tnd.pageName = 'REPAIR';
        PageReference pageRef = new PageReference('/apex/test?id=');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('pageName','TND');

        CSS_TndRepOverController.faultcodeswrapper fw= new CSS_TndRepOverController.faultcodeswrapper(fcList,fcList,'0','Primary',String.ValueOf(system.today()), true);
        List<CSS_TndRepOverController.faultcodeswrapper> ab=new List<CSS_TndRepOverController.faultcodeswrapper>();
        ab.add(fw);
        CSS_TndRepOverController.AllOtherFCWrapper alfw= new CSS_TndRepOverController.AllOtherFCWrapper (ab,system.today(),String.ValueOf(system.today()));            
        alfw.compareTo(alfw);  
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        tnd.isReadUser = false;
        tnd.sServiceModel = 'WDER';
        tnd.selectedReltdFaulcode = 'yes';
        tnd.displayHHPPopup1 = true;
        tnd.displayHHPPopup2 = false;
        tnd.dSidIndi = 'N';
        tnd.pgChJoESN();
        tnd.pgCancelClose();

        tnd.pgFCRefresh();

        tnd.showINncPopup();
        tnd.closeINncPopup();
        tnd.invokeLaunchInsite();
        tnd.getAllOtherFCWrapper();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());        
        tnd.faultCodeClick();
        tnd.getAllSolDetails();
        tnd.getVerSolDetails();
        tnd.getRepairDetails();
        tnd.getDiagSRTDetails();
        tnd.getRepSRTDetails(); 
        tnd.getSolutions();
        tnd.repsol1();
        tnd.createDSID();
        tnd.redirectGtis(1);
        tnd.redirectGtis(2);
        tnd.showGitsPopup();
        tnd.closeGitsPopup();
        List<Id> jobIds = new List<Id>();       
        jobIds.add(jobOrder.id);
        tnd.sftdDate = '1231';
        tnd.isPrioritized = false;
        tnd.poleWarningMsg = false;
        tnd.poleVerified = false;
        tnd.solutionNumber('DSBDT4729');  
        CSS_TndRepOverController.UpdateGTIS(jobIds,1);
        CSS_TndRepOverController.UpdateGTIS(jobIds,2);
        tnd.takeControl();
        //tnd.callCreateWoAndUpdateComment();
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_UnitOutboundMockup_Test()); 
        tnd.getBMSUnitDetails('79462880');
        tnd.selectedUnitNumber = '12345';
        tnd.selectedBMSUnitNumber();
        tnd.HHSPSMNFlg = true;
        tnd.HHSPACCSFlg = false;
        tnd.pgSaveFinish();
        tnd.closeSrvModPopup();
        tnd.closeBMSUnitDetails();
        //tnd.bmsEnabled = true;
        tnd.createDSIDAndBMSLookup();
        tnd.selectedUnitDetails();
        tnd.HHSPACCSFlg = true;
        tnd.pgChInsiteESN();

        Test.stopTest();        
    }
    
    static testMethod void CSS_TndRepOverController_test_Method11(){
        

         Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Account__c=acc.id;
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.BMSStatus__c = 'Pass';
        jobOrder.Before_In_Service__c = true;
        jobOrder.Mileage__c = 122;
        jobOrder.Mileage_Measure__c = 'Miles';
        jobOrder.INSITE_UpdateTimeStamp__c = system.now()-1;
        jobOrder.Application_Desc__c = 'test1';
        jobOrder.Make__c = 'Make1';
        jobOrder.Model__c = 'Model2';
        jobOrder.GTIS_Message_Type__c = 123;
        joborder.PSN_Not_Available__c = true;
        jobOrder.DisplayGtis__c = false;
        jobOrder.ESN__c = '';
        jobOrder.Customer_Name__c = 'ABC';
        jobOrder.Insite_ESN2_Select__c = true;
        jobOrder.PSN_Not_Available__c = true;

        //jobOrder.DSID__c = '213213';
        insert jobOrder;
        
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
        CSS_TndRepOverController obj = new CSS_TndRepOverController();
        obj.HHSPACCSFlg = true;
        obj.showESNLockPopUp();
        obj.getrankDetails();
        obj.createDSIDAndBMSLookupInPgFcRefresh();
        
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Selected_Component__c = true;
        insert csc;

        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;

        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        

        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','DP','121,131');
        List<CSS_Fault_Code__c> fcList = new List<CSS_Fault_Code__c>();
        fcList.add(fc1);
        fcList.add(fc2);
        fcList.add(fc3);
        ApexPages.CurrentPage().getParameters().put('id',jobOrder.id);
       CSS_TndRepOverController tnd = new CSS_TndRepOverController();
       
        tnd.Ins_JobId=jobOrder.id;
        tnd.pageName = 'TND';
        PageReference pageRef = new PageReference('/apex/test?id=');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('pageName','TND');

        CSS_TndRepOverController.faultcodeswrapper fw= new CSS_TndRepOverController.faultcodeswrapper(fcList,fcList,'0','Primary',String.ValueOf(system.today()), true);
        List<CSS_TndRepOverController.faultcodeswrapper> ab=new List<CSS_TndRepOverController.faultcodeswrapper>();
        ab.add(fw);
        CSS_TndRepOverController.AllOtherFCWrapper alfw= new CSS_TndRepOverController.AllOtherFCWrapper (ab,system.today(),String.ValueOf(system.today()));            
        alfw.compareTo(alfw); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        tnd.pgChInsiteESN();
        tnd.pgChJoESN();
        tnd.pgCancelClose();
        tnd.pgFCRefresh();
        tnd.showINncPopup();
        tnd.closeINncPopup();
        tnd.invokeLaunchInsite();
        tnd.getAllOtherFCWrapper();
        
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());        
        tnd.faultCodeClick();
        tnd.getAllSolDetails();
        tnd.getVerSolDetails();
        tnd.getRepairDetails(); 
        tnd.getDiagSRTDetails();
        tnd.getRepSRTDetails(); 
        tnd.getSolutions();
        tnd.repsol1();
        tnd.createDSID();
        tnd.redirectGtis(1);
        tnd.redirectGtis(2);
        tnd.showGitsPopup();
        tnd.closeGitsPopup();
        List<Id> jobIds = new List<Id>();       
        jobIds.add(jobOrder.id);
        tnd.sftdDate = '1231';
        tnd.isPrioritized = false;
        tnd.poleWarningMsg = false;
        tnd.poleVerified = false;
        CSS_TndRepOverController.UpdateGTIS(jobIds,1);
        CSS_TndRepOverController.UpdateGTIS(jobIds,2);
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());
        tnd.takeControl();
        Test.stopTest();        
    }
        
}