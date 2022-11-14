@isTest
public class CG_CL_IntakeUE_Test {
    
    static testMethod void callAllMethods(){
        
        List<CSS_Job_Order__c> JobList = new List<CSS_Job_Order__c>();
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Gopal';
        JO.Application__c = 'Recreational Vehicle';
        JO.FieldActionWebServiceResult__c = 'Error';
        JO.Model__c = 'RajTest';
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
        JO.Status__c = 'Repair Complete';
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
        JO.Service_Model__c ='smodel';
        jo.Territory_Class_Name__c=null;
        JobList.add(JO);
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'Gopal';
        JO1.Application__c = 'Recreational Vehicle';
        JO1.Model__c = 'RajTest';
        JO1.Status__c = 'Job Plan';
        JobList.add(JO1);
        
        insert JobList;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        list<CSS_CampTsbTrp__c> qsolCTTP = new list<CSS_CampTsbTrp__c>();
        
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'tel', Performed__c = false,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646',Job_Order__c=JO.id);
        solutionList.add(solRec);
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'tel', Performed__c = false, 
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = '79464646',Job_Order__c=JO.id);
        solutionList.add(solRec2);
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'tel', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646',Job_Order__c=JO.id);
        qsolCTTP.add(solRec1);
        
        insert solutionList;
        
        List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c = 'Approved';
        solComp.Complete_Indicator__c = True;
        solcomp.Multiple_Times__c = True;
        insert solComp;
        solCompCTTP.add(solComp);
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'Test';
        accLan.Name = 'en';
        insert accLan;
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(False);
        SerRec.CSS_Job_Location_Code__c='53775-53775';
        SerRec.Id = null;
        insert SerRec;
        CG_CL_IntakeUE IntakeUE = new CG_CL_IntakeUE();
        IntakeUE.pageAction();
        IntakeUE.Wid = ApexPages.currentPage().getParameters().put('id',SerRec.id);
        IntakeUE.getfilterMake();
        IntakeUE.prodcodeErrormessage=true;
        IntakeUE.filterCountry='test';
        IntakeUE.setfilterMake('test');
        IntakeUE.getfilterModel();
        IntakeUE.setfilterModel('Aqua');
        IntakeUE.getfilterState();
        IntakeUE.setfilterState('Working...');
        IntakeUE.getfilterUnitType();
        IntakeUE.setfilterUnitType('Johnson');
        IntakeUE.getfilterSubType();
        IntakeUE.setfilterSubType('Johnson1');
        IntakeUE.getmil_measure();
        IntakeUE.setmil_measure('Test123');
        IntakeUE.getfail_measure();
        IntakeUE.setfail_measure('Sample');
        IntakeUE.pgSave();
        
        //IntakeUE.nvIntakeCustomer();
        //IntakeUE.nvIntakeCC();
        //IntakeUE.nvIntakeVH();
        //IntakeUE.nvIntakeWarranty();
        //IntakeUE.nvIntakeRJ();
        IntakeUE.showPopup();
        IntakeUE.closePopup();
        IntakeUE.closeSession();
        IntakeUE.qsollanguage();
        IntakeUE.getSiebelQSOLCampaigns();
        IntakeUE.getQSOLDocs();
        IntakeUE.redirectPopup();
        IntakeUE.ChkFieldBlank();
        IntakeUE.Cancel();
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        // CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c(JO.ID,JO.ESN__c,accLan,'test','test');
        CSS_QuickServe.getQsolDocSaveLang(SerRec.id,'43443243','Test');
        Test.stopTest();
    }
    
    static testmethod  void TestonSaveUE(){
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(False);
        SerRec.CSS_Job_Location_Code__c='53775-53775';
        SerRec.Id = null;
        insert SerRec;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        Cache.Session.put('selectedLocation', u.User_Location__c);
        String selectedLocation = (String) Cache.Session.get('selectedLocation');
        //string selectedLocation1='test';
        
        List<CSS_UserLocation__c> lstuserloc = new List<CSS_UserLocation__c>();
        CSS_UserLocation__c usrloc = new CSS_UserLocation__c();
        usrloc.isActive__c=true;
        usrloc.isPrimary__c=true;
        usrloc.UserId__c=u.Id;
        usrloc.Location_code__c= selectedLocation;
        insert usrloc;
        lstuserloc.add(usrloc);
        
        list<CSS_CampTsbTrp__c> testcamtsptrp = new list<CSS_CampTsbTrp__c>();
        CG_CL_IntakeUE intakeUE = new CG_CL_IntakeUE();
        intakeue.filterCountry = 'US';
        intakeue.campList = testcamtsptrp;
        intakeUE.saveUE(SerRec.id,'rajasekhar');
    }
    
    static testmethod void testpageactionmethod1(){
        
        cache.Session.put('UserERPSystem','BMS Legacy');
        CG_CL_IntakeUE IntakeUEobj = new CG_CL_IntakeUE();
        IntakeUEobj.pageAction();
        
    }
    
    static testmethod void testpageactionmethod2(){
        
        CG_CL_IntakeUE IntakeUEobj = new CG_CL_IntakeUE();
        IntakeUEobj.pageAction();
    }
    
    static testmethod void testpageactionmethod3(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'raj', Email='gopalraj@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testinggopal', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='raj4@testorg.com');
        insert u;
        system.runAs(u)
        {
            CSS_JOb_Order__c JOb1 = new CSS_JOb_Order__c();
            
            JOb1.Customer_Name__c = 'Gopal';
            JOb1.Application__c = 'Recreational Vehicle';
            JOb1.Model__c = 'RajTest';
            JOb1.Make__c = 'CSSTest';
            JOb1.Notes__c = 'CAMPCOMMENTS';
            JOb1.Failure_Point__c = 122;
            JOb1.Failure_Point_Measure__c = 'Miles';
            JOb1.VIN__c = '12345677890';
            JOb1.Failure_Date__c = date.today() - 20;
            JOb1.Warranty_Start_Date__c = date.today() - 365;
            JOb1.Location_Certification__c = 'abc';
            JOb1.Before_In_Service__c = True;
            JOb1.Status__c = 'Repair Complete';
            JOb1.Unit_Number__c = 'test123';
            JOb1.Assigned_To__c = UserInfo.getUserId();
            JOb1.esn__c = '79464646';
            JOb1.Unit_Type__c = 'type';
            JOb1.Country__c = 'United States';
            JOb1.CSS_State__c = 'Indiana';
            JOb1.City__c = 'Columbus';
            JOb1.Customer_Code__c = '23456';
            JOb1.EditComplaint__c = 'complaint';
            JOb1.EditCoverage__c = 'coverage';
            JOb1.EditCause__c = 'cause';
            JOb1.EditCorrection__c = 'correction';
            JOb1.chevron_page__c = 'prt';
            JOb1.CSS_Resolution__c = 'Test';
            JOb1.DSID__c = 'VFD23';
            JOb1.Service_Model__c ='smodel';
            JOb1.Territory_Class_Name__c=null;
            insert JOb1;
            pagereference ref ;
            ref = new pagereference('/'+JOb1.id);
            ref.getParameters().put('id',+job1.id);
            test.setCurrentPage(Ref);
            
            CG_CL_IntakeUE IntakeUEobj = new CG_CL_IntakeUE();
            IntakeUEobj.pageAction();
        }
    }
    
    static testmethod void pageactiontestmethod4(){
        
        cache.Session.put('UserERPSystem','BMS Legacy');
        
        CSS_JOb_Order__c JOb2 = new CSS_JOb_Order__c();
        JOb2.Customer_Name__c = 'Gopal';
        JOb2.Application__c = 'Recreational Vehicle';
        JOb2.Model__c = 'RajTest';
        JOb2.Make__c = 'CSSTest';
        JOb2.Notes__c = 'CAMPCOMMENTS';
        JOb2.Failure_Point__c = 122;
        JOb2.Failure_Point_Measure__c = 'Miles';
        JOb2.VIN__c = '12345677890';
        JOb2.Failure_Date__c = date.today() - 20;
        JOb2.Warranty_Start_Date__c = date.today() - 365;
        JOb2.Location_Certification__c = 'abc';
        JOB2.Sub_Type__c='test';
        JOb2.Before_In_Service__c = True;
        JOb2.Status__c = 'Repair Complete';
        JOb2.Unit_Number__c = 'test123';
        JOb2.Assigned_To__c = UserInfo.getUserId();
        JOb2.esn__c = '79464646';
        JOb2.Unit_Type__c = 'type';
        JOb2.Country__c = 'United States';
        JOb2.CSS_State__c = 'Indiana';
        JOb2.City__c = 'Columbus';
        JOb2.Customer_Code__c = '23456';
        JOb2.EditComplaint__c = 'complaint';
        JOb2.EditCoverage__c = 'coverage';
        JOb2.EditCause__c = 'cause';
        JOb2.EditCorrection__c = 'correction';
        JOb2.chevron_page__c = 'prt';
        JOb2.CSS_Resolution__c = 'Test';
        JOb2.DSID__c = 'VFD23';
        JOb2.Service_Model__c ='smodel';
        JOb2.Territory_Class_Name__c=null;
        insert JOb2;
        
        pagereference ref ;
        ref = new pagereference('/'+JOb2.id);
        ref.getParameters().put('id',+JOb2.id);
        test.setCurrentPage(Ref);
        CG_CL_IntakeUE IntakeUEobj = new CG_CL_IntakeUE();
        IntakeUEobj.pageAction();
    }
    
    static testmethod void testForValuesInPageAction(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Oliver Trucking';
        Jo.esn__c = '79464646';
        JO.Application__c = '130-Automotive';
        JO.Model__c = 'test';
        JO.Make__c = 'test';
        JO.Warranty_Start_Date__c = date.today()+3;
        JO.Status__c = 'Intake';
        JO.Application_Desc__c = '130-Automotive' ;
        JO.Mileage_Measure__c = 'KM';
        insert JO;
        
        system.assertEquals(date.today()+3, JO.Warranty_Start_Date__c, 'Testing');
        system.assertEquals('130-Automotive',JO.Application_Desc__c, 'Testing for Application_Desc__c');
        system.assertEquals('KM',JO.Mileage_Measure__c, 'Testing for Mileage_Measure__c');
        
        Test.startTest();
        pagereference ref = new pagereference('/'+JO.id);
        ref.getParameters().put('id',+JO.id);
        test.setCurrentPage(Ref);
        CG_CL_IntakeUE IntakeUE = new CG_CL_IntakeUE();
        IntakeUE.pageAction();
        test.stopTest();
       }
       
    static testmethod void testOnAppoitment(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Oliver Trucking';
        Jo.esn__c = '79464646';
        JO.Application_Desc__c = '130-Automotive';
        JO.status__c = 'Appointment';
        insert JO;
        System.assert(JO !=null, 'Test');
        
        Test.startTest();
        pagereference ref = new pagereference('/'+JO.id);
        ref.getParameters().put('id',+JO.id);
        test.setCurrentPage(Ref);
        CG_CL_IntakeUE IntakeUE = new CG_CL_IntakeUE();
        IntakeUE.pgSave();
        IntakeUE.nvIntakeCustomer();
        IntakeUE.nvIntakeCC();
        IntakeUE.nvIntakeVH();
        IntakeUE.nvIntakeWarranty();
        IntakeUE.nvIntakeRJ();
        test.stopTest();
       }
       
    static testmethod void testOnWidNull(){
        
        Test.startTest();
        CG_CL_IntakeUE IntakeUE = new CG_CL_IntakeUE();
        IntakeUE.nvIntakeCustomer();
        IntakeUE.nvIntakeCC();
        IntakeUE.nvIntakeVH();
        IntakeUE.nvIntakeWarranty();
        IntakeUE.nvIntakeRJ();
        test.stopTest();
       }   
    
}