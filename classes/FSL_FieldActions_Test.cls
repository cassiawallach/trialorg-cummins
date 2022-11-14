@IsTest
public class FSL_FieldActions_Test {
    
    @isTest static void testCallout() {
        
       /* CSS_Integration_Details__c conDetails =new  CSS_Integration_Details__c();
        conDetails.Name ='FSL_QSOL_Getwarrantydocs';
        conDetails.End_Point__c ='https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';
        conDetails.BusinessUnit__c ='EBU';
        insert conDetails; */
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs';
        conDetails.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';
        conDetails.BusinessUnit__c ='EBU';
        //conDetails.Passcode__c = 'Admin';
        //conDetails.Username__c = 'Admin'; 
        insert conDetails;
        
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        //FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
         List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
         FSL_FieldActions.getTokenQSOL();
        FSL_FieldActions fa = new FSL_FieldActions();
       /* PageReference pref;
        pref = new PageReference('/'+wo1.id);
        pref.getParameters().put('id',wo1.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref); 
        Test.setCurrentPage(pageRef);*/
       // fa.CSSSolutionsFromQSOL();
        test.stopTest();
    }
    
    
    
    static testMethod void fsl_fieldactions_Test_Method1() {
        
        // Set mock callout class 

        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.IAM_Service_Provider_Code__c = '48923';
        acc.FSL_Credit_Limit__c = '78888';
        insert acc;
        
       /* Notes note = new Notes();
        note.Body = 'Test1234';
        note.title = 'Title';
        //note.Createfirstname = 'Test.First'
        //note.CreatedBy.lastname ='Test.LastName';
        //note.CreatedDate = Date.today();
        insert note; */
            
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c = '56';
        insert ast;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 Mobile';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        
        insert cs; 

        List<workOrder> woInfo = new List<workOrder>();
        workOrder wo1 = new workOrder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
       	wo1.Case = cs;
        woInfo.add(wo1);
        insert woInfo;
        
        List<workOrder> woInfo1 = new List<workOrder>();
        workOrder wo2 = new workOrder();
        wo2.id = woInfo[0].id;
        wo2.EditComplaint__c = 'Testing Info';
        wo2.EditCause__c = 'Testing Info';
        wo2.EditCorrection__c = 'Testing Info';
        wo2.EditCoverage__c = 'Testing Info1';
        wo2.ServiceTerritoryid = serTer1.id;
        woInfo1.add(wo2);
        update woInfo1;
         ApexPages.CurrentPage().getParameters().put('id',woInfo1[0].id);
        
       /* CSS_CampTsbTrp__c camp = new CSS_CampTsbTrp__c();
        camp.name = 'Test';
        camp.Performed__c = True;
        camp.Performed_Review__c = true;
        camp.Reviewed__c = true;
        //camp.FSL_ServiceJob__c = 
        insert camp;
        
        CSS_Solutions__c solu = new CSS_Solutions__c();
        solu.Name = 'Test';
        solu.Case_Name__c = 'Test22';
        solu.FSL_Service_Job__c = '123453';
        solu.Repair_response__c = 'Test12';
        solu.Solution_Title__c = 'Test232';    
        solu.Solution__c = 'Final Result';   
        solu.Diagnostic_Response__c = 'Result'; 
        insert solu; */
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp =new  CSS_Solution_Component__c ();
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.URL__c ='abc';
        solcomp.Component_Id__c = '1234';
        solcomp.Campaign_Description__c = 'abcxyz';
        solcomp.Performed__c =false;
        solcomp.Performed_Review__c=True;
        solcomp.Reviewed__c=true;

        solcomp.Selected_Component__c=true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.FSL_Service_Job__c =woInfo1[0].Id;
        solcomp.Type__c ='Campaign';
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c =true ;
        solcomp.Multiple_Times__c = true;
        solComp.FSL_Service_Job__c =woInfo[0].id;
       insert solcomp;
        
        CSS_accountLanguage__c accLang = new CSS_accountLanguage__c();
        accLang.Name='en_US';
        accLang.CSS_EDSLanguage__c='English';
        accLang.CSS_QsolLanguage__c='English';
        accLang.CSS_userLanguage__c='en';
        insert accLang;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',User_Location__c = 'abc', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        
       /* CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Intake';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Application_Desc__c = 'Automotive';
        JO.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
        jo.Region__c='KOREA';
        Jo.Territory__c='NORTH KOREA';
        jo.Mileage__c=987;
        jo.Mileage_Measure__c='Miles';
        insert JO; */
       /* Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = '1234';  
        x.Body = 'tEST';
        insert x; */
        
        CSS_Solution_Component__c  obj =[select id from CSS_Solution_Component__c  where id=:solcomp.id];
        FSL_FieldActions fsl = new FSL_FieldActions();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        fsl.componentid = solcomp.Id ;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.name= 'FSL_QSOL_Getwarrantydocs';
        conDetails1.End_Point__c= 'https://test.Com/getWarrantyDetailCoverage';
        conDetails1.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails1.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails1.IsActive__c = true;
        conDetails1.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails1; 
        
        // fsl.vMore_JobId =woInfo1.Id;
        //fsl.DSID =JO.Id;
        fsl.timeinMinutes=10;
        fsl.repTime=10.0;
            fsl.NewrepTime=10.0;
            fsl.NewdigTime=10.0;
            fsl.NewdigMin=5;
            fsl.NewrepMin=6;
            fsl.bmsEnabled=TRUE;
            fsl.selectedSubStatusVal='lIST';
            fsl.dsidIndi='123';
        fsl.timeinhours=1;
        fsl.sServiceModel='Demo';
        fsl.dispDTime ='10';
        fsl.dispRepTime ='7';
        fsl.digTime=1.0;
       fsl.Type='abc';
        fsl.isClaimEnabled=true;
        fsl.isJoblocClaimEnabled=true;
        
        fsl.mainSOQL();
        fsl.updateNotes();
        
        fsl.getALLRecords();
        //fsl.saveCampNotesCheckBox();
        
        fsl.qsollanguage();
        fsl.getCamps();
        fsl.getTrps();
        fsl.getAtcs();
        fsl.getTsbs();
      //  fsl.getDSID();
       
        
         CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
        ct.name = 'CAM';
        ct.name = 'TRP';
        ct.name = 'TSB';
        list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,Cu_Language__c = 'Hindi',
                                                         Performed_Review__c= false,Reviewed__c= false , esn__c = '73695829',FSL_ServiceJob__c = wo1.Id);
        solutionList.add(solRec);
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,
                                                          Performed_Review__c= true,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c = wo1.Id);
        solutionList.add(solRec2); 
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c =wo1.Id);
        solutionList.add(solRec1);
        CSS_CampTsbTrp__c solRec3 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='ATC',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c =wo1.id);
        solutionList.add(solRec3);
        insert solutionList;
        
        Test.setMock(HttpCalloutMock.class, new FSL_getDetailCoverage_TestMock());
         /*cssTrp = new CSS_CampTsbTrp__c();
        cssTrp.Name = 'Test Trp';
        cssTrp.FSL_ServiceJob__c = wo1.id;
        cssTrp.performed_review__c = true;
        cssTrp.performed__c = false;
        cssTrp.Cu_Language__c = 'Hindi';
        cssTrp.Type__c='TSB';
        insert cssTrp;*/
        fsl.comm ='Test';
        fsl.rpid = 'jhjgj';
        fsl.strEDSCodes = 'dgfdgf';
        fsl.filterMake = 'jggfgfk';
        fsl.filterModel = 'dfdgfd';
        fsl.mil_measure = 'hghf';
        fsl.fail_measure = 'hgffg';
        
        
        fsl.saveCheckBox();
        fsl.getQSOLDocs();
        fsl.getALLRecords();
        FSL_FieldActions.viewcampaigns(wo1.id);
       try{
            fsl.CSSSolutionsFromQSOL();
        }
        catch(exception e){}
    }
    static testMethod void fsl_fieldactions_Test_Method3() {
     Asset ast = new Asset();
        ast.Name = '79660448';
        ast.Make__c = 'Kenworth';
        ast.Model__c = 'K600';
        ast.Service_Model__c = 'ISX T600';
        ast.Unit_Number__c = '1234';
        ast.Type_PSN__c = 'Engines-79660448';
        insert ast;
        
         /* Notes note = new Notes();
        note.Body = 'Test1234';
        note.title = 'Title';
        //note.Createfirstname = 'Test.First'
        //note.CreatedBy.lastname ='Test.LastName';
        //note.CreatedDate = Date.today();
        insert note; */
        
        WorkOrder JO = new WorkOrder();
        // JO.Customer_Name__c = 'RoopaTnD';
        JO.AssetId = ast.Id;
        JO.General_Symptoms__c = 'Black Smoke';
        JO.Mileage__c = 23000;
        JO.Category1__c = 'Leak';
        JO.Failure_Date__c = Date.Today();
        // JO.Failure_Point_Measure__c = 'sss';
        // JO.RPV_Email_Address__c = 'test@test.com';
        // JO.RPV_Email_Has_Sent__c = false;
        // JO.RPVControlNumber__c = 'NoInput';
        // JO.DSID_Creation_Timestamp__c = Date.Today();
        // JO.DSID_Status__c='open';
        JO.Shop_Work_Order__c = '';
        JO.Status = 'Intake';
      //  JO.notes  = note.Id ;
        
        // JO.DSID_WorkGroup__c = '1234';
        // JO.RPV_SecondWebserviceCall__c = true;
        // JO.RPV_Notification_Flag__c ='OFF';
        // JO.Assigned_To__c = UserInfo.getUserId();
        // JO.AccessCode__c = '12';
        // JO.BMSStatus__c='UI0';
        // JO.DSID__c = '12345';
        JO.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        insert JO;
        
        Note testNote = new Note();

        testNote.Title = 'CAMPCOMMENTS';
        testNote.Body = 'Test Jo Note Body.';
        testNote.ParentId = JO.Id;

        insert testNote;

        system.debug('wok---'+JO);
        
        
        ApexPages.CurrentPage().getParameters().put('id',JO.Id);
        FSL_FieldActions fsl = new FSL_FieldActions();
        //fsl.getDSID();
         fsl.comm ='Test';
       fsl.saveCampNotesCheckBox();
       //  ApexPages.currentPage().getParameters().put('fileName','test');
       // PageReference p = Page.FSL_FieldActions ; 
        //Test.setCurrentPage(p);  
        //ApexPages.currentPage().getParameters().put('id',JO.Id); 
        
    }
    
     static testmethod void method_test_new1(){
         FSL_FieldActions fsl = new FSL_FieldActions();
         test.startTest();
        fsl.getCamps();
        fsl.getTrps();
        fsl.getAtcs();
        fsl.getTsbs();
         fsl.getQSOLDocs();
         fsl.getALLRecords();
         test.stopTest();
    }
    
    
}