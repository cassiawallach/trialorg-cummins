/*
Test CLass for Customer Complaint Controller - CG_CL_IntakeWarranty
*/
@isTest(seealldata = false)
public class CG_CL_IntakeWarrantyComp_Test{
    @testsetup
    static void testdata()
    {
       
    }
    Static testmethod void CG_CL_IntakeWarrantyComp_TestMethod1() {
        user u = [select id,name from user limit 1];
        
        List <CSS_Job_Order__c> Joelst = new list <CSS_Job_Order__c>();
          CSS_Job_Order__c JO = new CSS_Job_Order__c();
                    
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
        JO.CG_NoWarrantyFlag__c = 'Y';
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
        JO.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}}';
       jo.Region__c='KOREA';
        Jo.Territory__c='NORTH KOREA';
        jo.Mileage__c=987;
        jo.Mileage_Measure__c='Miles';
        Joelst.add(JO);
        
        CSS_Job_Order__c JOe = new CSS_Job_Order__c();
                    
        JOe.Customer_Name__c = 'Test Customer';
        JOe.Application__c = 'Recreational Vehicle';
        JOe.Model__c = 'ModelTest';
        JOe.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
        JOe.Region__c='KOREA';
        Joelst.add(JOe);
        
        insert Joelst;
        
        system.runAs(u)
        {
        Test.startTest();
            Account acc = new account();
            acc.name='Gopal';
            acc.IAM_Service_Provider_Code__c='12345';
            acc.CSS_DistributorCode__c='12345';
            acc.Region__c ='KOREA';
            acc.Territory__c='NORTH KOREA';
            acc.Region__c = 'US and Canada';
             acc.CMI_Account_Status__c = 'Active';
            //insert acc;
       
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
      
        ApexPages.currentPage().getParameters().put('id',JO.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarrantyComp intakeWar = new CG_CL_IntakeWarrantyComp();
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        
        String json = '{'+
        '    \"Header\": '+
        '    {'+
        '        \"Sender\": '+
        '        {'+
        '            \"ServiceName\": \"GetDetailCoverage\",'+
        '            \"SenderID\": \"CSS\"'+
        '        },'+
        '        \"Target\": { \"TargetID\": \"SIEBEL\" }'+
        '    },'+
        '    \"DataArea\": '+
        '    {'+
        '        \"ESN\": \"33137149\",'+
        '        \"SPCode\": \"37320\",'+
        '        \"FailureDate\": \"5/1/2016\",'+
        '        \"FailurePoint\": \"120\",'+
        '        \"FailureMeasure\": \"Miles\",'+
        '        \"EngineApplicationCode\": \"130\",'+
        '        \"SystemCode\": \"IR\",'+
        '        \"ComponentCode\": \"TC\",'+
        '        \"FaultCode\": \"1121\",'+
        '        \"WarrantyStartDate\": \"5/1/2010\",'+
        '        \"CampaignNumber\": \"1-89798987\",'+
        '        \"NewPartsWrntyFlg\": \"Y\",'+
        '        \"ReconPartsWrntyFlg\": \"Y\",'+
        '        \"RoadRelayWrntyFlg\": \"Y\",'+
        '        \"AccountCode\": \"98\"'+
        '    }'+
        '}';
        
        CSS_getBasicCoverageReqJ2A obj = CSS_getBasicCoverageReqJ2A.parse(json);
        CSS_getBasicCoverageResponseJ2A gt = new CSS_getBasicCoverageResponseJ2A();
        //CSS_getBasicCoverageResponseJ2A.CoverageDedutibles = '1';
        gt = CSS_WS_SBL.getBasicCoverage(obj);
        
        intakeWar.SOQLServicejob();
        intakeWar.regionTerritory();
        intakeWar.loadBasicData();
        intakeWar.getItems();
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test());

    //    intakeWar.coveragesearch();
        intakeWar.updatetext();
        intakeWar.clearWarantyFields();
        intakeWar.milekmconv();
        
        Test.stopTest();
        }
    }
    
    Static testmethod void CG_CL_IntakeWarrantyComp_TestMethod2() {
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
                    
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        //JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Intake';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        //Jo.esn__c = '79464646';
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
        JO.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
               
        insert JO;
        
        //ApexPages.currentPage().getParameters().put('id',JO.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarrantyComp intakeWar = new CG_CL_IntakeWarrantyComp();
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        Test.stopTest();
        
    }
    static testmethod void testmethod3()
    {
        CG_CL_IntakeWarrantyComp War = new CG_CL_IntakeWarrantyComp();
        War.myBase64String='Testing';
        War.pagName='RJ';
        war.testVar='TestingVar';
        War.warrentyStartD=system.now();
        War.coverageMaxMonth = 2;
        CG_CL_IntakeWarranty clintwar= new CG_CL_IntakeWarranty();
        war.mainContr=clintwar;
        War.mil_measure = 'Kilometers';
        War.coveragesearch();
        
    }
    static testmethod void testmethod4()
    {
        
        CG_CL_IntakeWarrantyComp War = new CG_CL_IntakeWarrantyComp();
        War.myBase64String='Testing';
        War.pagName='RJ';
        war.testVar='TestingVar';
        War.warrentyStartD=system.now();
        War.coverageMaxMonth = 2;
        war.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar= new CG_CL_IntakeWarranty();
        war.mainContr=clintwar;
    
    //    War.coveragesearch();
        
        css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
        jo.BMSStatus__c = 'esnChanged';
        insert jo;
        CG_CL_IntakeWarrantyComp War1 = new CG_CL_IntakeWarrantyComp();
        War1.myBase64String='Testing';
        War1.pagName='RJ';
        war1.testVar='TestingVar';
        War1.warrentyStartD=system.now();
        War1.coverageMaxMonth = 2;
        war1.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar1= new CG_CL_IntakeWarranty();
        war1.mainContr=clintwar1;
        War1.servicejob = jo;
        War1.mil_measure = 'Kilometers';
        War1.coveragesearch();
        
        css_job_order__C jo1 = new css_job_order__C();
        jo1.Warranty_Start_Date__c=system.today();
        jo1.ESN__c='67682872';
        insert jo1;
        CG_CL_IntakeWarrantyComp War12 = new CG_CL_IntakeWarrantyComp();
        War12.myBase64String='Testing';
        War12.pagName='RJ';
        war12.testVar='TestingVar';
        War12.warrentyStartD=system.now();
        War12.coverageMaxMonth = 2;
        war12.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar12= new CG_CL_IntakeWarranty();
        war12.mainContr=clintwar12;
        War12.servicejob = jo1;
   //     War12.coveragesearch();
        
        css_job_order__C job1 = new css_job_order__C();
        job1.Warranty_Start_Date__c=system.today();
        job1.ESN__c='67682872';
         job1.Region__c='KOREA';
        insert job1;
        CG_CL_IntakeWarrantyComp Wart12 = new CG_CL_IntakeWarrantyComp();
        Wart12.myBase64String='Testing';
        Wart12.pagName='RJ';
        wart12.testVar='TestingVar';
        Wart12.warrentyStartD=system.now();
        Wart12.coverageMaxMonth = 2;
        wart12.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwart12= new CG_CL_IntakeWarranty();
        wart12.mainContr=clintwart12;
        Wart12.servicejob = job1;
        Wart12.mil_measure = 'Kilometers';
        Wart12.coveragesearch();
        user u = [select id from user limit 1];
        system.runAs(u)
        {
         css_job_order__C job11 = new css_job_order__C();
        job11.Warranty_Start_Date__c=system.today();
        job11.ESN__c='67682872';
         job11.Region__c='KOREA';
        job11.Territory__c='NORTH KOREA';
        insert job11;
        CG_CL_IntakeWarrantyComp Wart121 = new CG_CL_IntakeWarrantyComp();
        Wart121.myBase64String='Testing';
        Wart121.pagName='RJ';
        wart121.testVar='TestingVar';
        Wart121.warrentyStartD=system.now();
        Wart121.coverageMaxMonth = 2;
        wart121.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwart121= new CG_CL_IntakeWarranty();
        wart121.mainContr=clintwart121;
        Wart121.servicejob = job11;
   //     Wart121.coveragesearch();
        wart121.regionTerritory();
        }
        css_job_order__C jo12 = new css_job_order__C();
        jo12.Warranty_Start_Date__c=system.today();
        jo12.ESN__c='67682872';
        jo12.Region__c='KOREA';
        jo12.Territory__c='NORTH KOREA';
        jo12.Mileage__c=898;
        jo12.Mileage_Measure__c = 'Kilometers';
        
        insert jo12;
               
        CG_CL_IntakeWarrantyComp War123 = new CG_CL_IntakeWarrantyComp();
        War123.myBase64String='Testing';
        War123.pagName='RJ';
        war123.testVar='TestingVar';
        War123.warrentyStartD=system.now();
        War123.coverageMaxMonth = 2;
        war123.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar123= new CG_CL_IntakeWarranty();
        war123.mainContr=clintwar123;
        War123.servicejob = jo12;
        clintwar123.mil_measure='Kilometers';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        War123.mil_measure = 'Kilometers';
        War123.pgId = jo12.id;
        War123.coveragesearch();
        Test.stopTest();
    }
 static testmethod void testmethod5()
    {
        
        CG_CL_IntakeWarrantyComp War = new CG_CL_IntakeWarrantyComp();
        War.myBase64String='Testing';
        War.pagName='RJ';
        war.testVar='TestingVar';
        War.warrentyStartD=system.now();
        War.coverageMaxMonth = 2;
        war.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar= new CG_CL_IntakeWarranty();
        war.mainContr=clintwar;
    
    //    War.coveragesearch();
        
        css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
        jo.BMSStatus__c = 'esnChanged';
        jo.Before_In_Service__c = false;
        insert jo;
        CG_CL_IntakeWarrantyComp War1 = new CG_CL_IntakeWarrantyComp();
        War1.myBase64String='Testing';
        War1.pagName='RJ';
        war1.testVar='TestingVar';
        War1.warrentyStartD=system.now();
        War1.coverageMaxMonth = 2;
        war1.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar1= new CG_CL_IntakeWarranty();
        war1.mainContr=clintwar1;
        War1.servicejob = jo;
        War1.mil_measure = 'Kilometers';
        War1.coveragesearch();
        
        css_job_order__C jo1 = new css_job_order__C();
       // jo1.Warranty_Start_Date__c=system.today();
       jo1.Warranty_Start_Date__c= null;
       jo1.Before_In_Service__c = false;
        jo1.ESN__c='67682872';
        
        
        insert jo1;
        CG_CL_IntakeWarrantyComp War12 = new CG_CL_IntakeWarrantyComp();
        War12.myBase64String='Testing';
        War12.pagName='RJ';
        war12.testVar='TestingVar';
        War12.warrentyStartD=system.now();
        War12.coverageMaxMonth = 2;
        war12.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar12= new CG_CL_IntakeWarranty();
        war12.mainContr=clintwar12;
        War12.servicejob = jo1;
   //     War12.coveragesearch();
        
        css_job_order__C job1 = new css_job_order__C();
      //  job1.Warranty_Start_Date__c=system.today();
      job1.Warranty_Start_Date__c= null;
       job1.Before_In_Service__c = false;
        job1.ESN__c='67682872';
         job1.Region__c='KOREA';
        insert job1;
        CG_CL_IntakeWarrantyComp Wart12 = new CG_CL_IntakeWarrantyComp();
        Wart12.myBase64String='Testing';
        Wart12.pagName='RJ';
        wart12.testVar='TestingVar';
        Wart12.warrentyStartD=system.now();
        Wart12.coverageMaxMonth = 2;
        wart12.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwart12= new CG_CL_IntakeWarranty();
        wart12.mainContr=clintwart12;
        Wart12.servicejob = job1;
        Wart12.mil_measure = 'Kilometers';
        Wart12.coveragesearch();
        user u = [select id from user limit 1];
        system.runAs(u)
        {
         css_job_order__C job11 = new css_job_order__C();
        job11.Warranty_Start_Date__c=system.today();
        job11.ESN__c='67682872';
        job11.Region__c='KOREA';
        job11.Territory__c='NORTH KOREA';
        job11.Warranty_Start_Date__c= null;
       job11.Before_In_Service__c = false;
        insert job11;
        CG_CL_IntakeWarrantyComp Wart121 = new CG_CL_IntakeWarrantyComp();
        Wart121.myBase64String='Testing';
        Wart121.pagName='RJ';
        wart121.testVar='TestingVar';
        Wart121.warrentyStartD=system.now();
        Wart121.coverageMaxMonth = 2;
        wart121.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwart121= new CG_CL_IntakeWarranty();
        wart121.mainContr=clintwart121;
        Wart121.servicejob = job11;
   //     Wart121.coveragesearch();
        wart121.regionTerritory();
        }
        css_job_order__C jo12 = new css_job_order__C();
        jo12.Warranty_Start_Date__c=system.today();
        jo12.ESN__c='67682872';
        jo12.Region__c='KOREA';
        jo12.Territory__c='NORTH KOREA';
        jo12.Mileage__c=898;
        jo12.Mileage_Measure__c = 'Kilometers';
        jo12.Warranty_Start_Date__c= null;
       jo12.Before_In_Service__c = false;
        
        insert jo12;
               
        CG_CL_IntakeWarrantyComp War123 = new CG_CL_IntakeWarrantyComp();
        War123.myBase64String='Testing';
        War123.pagName='RJ';
        war123.testVar='TestingVar';
        War123.warrentyStartD=system.now();
        War123.coverageMaxMonth = 2;
        war123.selectedAppCode='Testapp';
        CG_CL_IntakeWarranty clintwar123= new CG_CL_IntakeWarranty();
        war123.mainContr=clintwar123;
        War123.servicejob = jo12;
        clintwar123.mil_measure='Kilometers';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test());
        War123.mil_measure = 'Kilometers';
        War123.coveragesearch();
        Test.stopTest();
    }

    Static testmethod void CG_CL_IntakeWarrantyComp_TestMethod6() {
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        List <CSS_Job_Order__c> Joelst = new list <CSS_Job_Order__c>();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
                    
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        //JO.Warranty_Start_Date__c = ;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Intake';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        //Jo.esn__c = '79464646';
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
        JO.Mileage__c=2;
        JO.Mileage_Measure__c='Kilometers';
        JO.BMSStatus__c='esnChanged';
      JO.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}}';
       JO.Region__c='KOREA';
          JO.Territory__c='';
        Joelst.add(JO);
        
        
        CSS_Job_Order__c JOe = new CSS_Job_Order__c();
                    
        JOe.Customer_Name__c = 'Test Customer';
        JOe.Application__c = 'Recreational Vehicle';
        JOe.Model__c = 'ModelTest';
        JOe.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}}';
        JOe.Region__c='KOREA';
        Joelst.add(JOe);
        
        Map<String,string> milesHolder = new Map<String,string>();
        milesHolder.put('test','123');
       
        insert Joelst;
        
        ApexPages.currentPage().getParameters().put('id',JO.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarranty C = new CG_CL_IntakeWarranty();
        CG_CL_IntakeWarrantyComp intakeWar = new CG_CL_IntakeWarrantyComp();
        intakeWar.myBase64String='TESSS';
        intakeWar.pagName='intakeWarranty';
        intakeWar.mainContr=C;
        intakeWar.warrentyStartD=System.Today();
        intakeWar.coverageMaxMonth=0;
        intakeWar.testVar='TESTTT';
        intakeWar.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        
        intakeWar.loadBasicData();
        intakeWar.SOQLServicejob();
        intakeWar.mil_measure = 'Kilometers';
        intakeWar.coveragesearch();
        intakeWar.updatetext();
        intakeWar.clearWarantyFields();
        intakeWar.milekmconv();
        intakeWar.getItems();
        intakeWar.regionTerritory();
        Test.stopTest();
        
    }
    
    Static testmethod void CG_CL_IntakeWarrantyComp_TestMethod61() {
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        List <CSS_Job_Order__c> Joelst = new list <CSS_Job_Order__c>();
       CSS_Job_Order__c JOe = new CSS_Job_Order__c();
                    
        JOe.Customer_Name__c = 'Test Customer';
        JOe.Application__c = 'Recreational Vehicle';
        JOe.Model__c = 'ModelTest';
        JOe.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}}';
        JOe.Region__c='KOREA';
        Joelst.add(JOe);
        
        Map<String,string> milesHolder = new Map<String,string>();
        milesHolder.put('test','123');
       
        insert Joelst;
        
        ApexPages.currentPage().getParameters().put('id',JOe.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarranty C = new CG_CL_IntakeWarranty();
        CG_CL_IntakeWarrantyComp intakeWar = new CG_CL_IntakeWarrantyComp();
        intakeWar.myBase64String='TESSS';
        intakeWar.pagName='intakeWarranty';
        intakeWar.mainContr=C;
        intakeWar.warrentyStartD=System.Today();
        intakeWar.coverageMaxMonth=0;
        intakeWar.testVar='TESTTT';
        intakeWar.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        
        intakeWar.loadBasicData();
        intakeWar.SOQLServicejob();
        intakeWar.mil_measure = 'Kilometers';
        intakeWar.coveragesearch();
        intakeWar.updatetext();
        intakeWar.clearWarantyFields();
        intakeWar.milekmconv();
        
        Test.stopTest();
        
    }
    static testmethod void testregionTerritory()
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi108@cummins.com', User_Location__c='12345-12345');
        insert objUser1;
        system.runAs(objUser1)
        {
                      Account acc = new account();
            acc.name='Gopal';
            acc.IAM_Service_Provider_Code__c='12345';
            acc.CSS_DistributorCode__c='12345';
            acc.Region__c ='KOREA';
            acc.Territory__c='NORTH KOREA';
            acc.Region__c = 'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
            //insert acc;
            
       css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_job_order__C jobwo12 = [select id,Creator_Location__c,Warranty_Start_Date__c from css_job_order__C limit 1]; 
      //  system.assert(jobwo12.Creator_Location__c!=null);
           // account a = [select Id,Region__c,Territory__c,Type from Account where Location__c=:jobwo12.Creator_Location__c];
           // system.assert(a!=null);
         CG_CL_IntakeWarrantyComp intakwar = new CG_CL_IntakeWarrantyComp();
            intakwar.servicejob=jobwo12;
            intakwar.regionTerritory();
            intakwar.EmmisionWarrantyDedutibles = 'test';
        intakwar.ExtendedWarrantyDedutibles= 'test';
        intakwar.ReconWarrantyDedutibles= 'test';
        intakwar.NewEngWarrantyDedutibles= 'test';
            
        }
    }
   
    
    //All values/details with deductibles of BasicCoverage service
    static testmethod void testMethodForFullBasicCoverageResponse() {
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        List <CSS_Job_Order__c> Joelst = new list <CSS_Job_Order__c>();
        CSS_Job_Order__c JOe = new CSS_Job_Order__c();
                    
        JOe.Customer_Name__c = 'Test Customer';
        JOe.Application__c = 'Recreational Vehicle';
        JOe.Model__c = 'ModelTest';
        //JOe.CoverageResponse__c = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}}';
        
        //All values/details with deductibles
        JOe.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';

        JOe.Region__c='KOREA';
        Joelst.add(JOe);
        Map<String,string> milesHolder = new Map<String,string>();
        milesHolder.put('test','123');
        insert Joelst;
        
        ApexPages.currentPage().getParameters().put('id',JOe.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarranty C = new CG_CL_IntakeWarranty();
        CG_CL_IntakeWarrantyComp intakeWar = new CG_CL_IntakeWarrantyComp();
        
        intakeWar.myBase64String='TESSS';
        intakeWar.pagName='intakeWarranty';
        intakeWar.mainContr=C;
        intakeWar.warrentyStartD=System.Today();
        intakeWar.coverageMaxMonth=0;
        intakeWar.testVar='TESTTT';
        intakeWar.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        
        intakeWar.loadBasicData();
        intakeWar.SOQLServicejob();
        intakeWar.mil_measure = 'Kilometers';
        intakeWar.coveragesearch();
        intakeWar.updatetext();
        intakeWar.clearWarantyFields();
        intakeWar.milekmconv();
        
        Test.stopTest();
        
    }
}