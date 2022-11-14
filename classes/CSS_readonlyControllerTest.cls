@isTest(seeAllData = true)
public class CSS_readonlyControllerTest {
    
    static testMethod void  css_repair_job_Test_Method1()
    {
        Test.startTest();
        
        String json = '{'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   },'+
            '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
            '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [ '+
            '                  {'+
            '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
            '                              {'+
            '                  \"MegawattHours\": \"1000\",'+
            '                  \"CoverageMaxMonths\": \"30\",'+
            '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
            '                  \"CoverageMinMonths\": \"20\",'+
            '                  \"CoverageHours\": \"100\",'+
            '                  \"CoverageDefenitionType\": \"BASE\",'+
            '                  \"CoverageMiles\": \"10\"'+
            '               },'+
            '                              {'+
            '                  \"MegawattHours\": \"123\",'+
            '                  \"CoverageMaxMonths\": \"234\",'+
            '                  \"CoverageComponentTypeCode\": \"BELTS/HOSES\",'+
            '                  \"CoverageMinMonths\": \"56\",'+
            '                  \"CoverageHours\": \"123\",'+
            '                  \"CoverageDefenitionType\": \"BASE\",'+
            '                  \"CoverageMiles\": \"123\"'+
            '               }'+
            '            ]},'+
            '            \"WarrantyManualURL\": \"www.test.com/ems\",'+
            '            \"CoverageType\": \"EMS-Emissions Warranty\",'+
            '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
            '            \"ProcedureNumber\": \"ProcEMS\"'+
            '         },'+
            '                  {'+
            '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
            '                              {'+
            '                  \"MegawattHours\": \"0\",'+
            '                  \"CoverageMaxMonths\": \"120\",'+
            '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
            '                  \"CoverageMinMonths\": \"0\",'+
            '                  \"CoverageHours\": \"100000\",'+
            '                  \"CoverageDefenitionType\": \"BASE\",'+
            '                  \"CoverageMiles\": \"100000\"'+
            '               },'+
            '                              {'+
            '                  \"MegawattHours\": \"0\",'+
            '                  \"CoverageMaxMonths\": \"60\",'+
            '                  \"CoverageComponentTypeCode\": \"EMISSIONS\",'+
            '                  \"CoverageMinMonths\": \"0\",'+
            '                  \"CoverageHours\": \"0\",'+
            '                  \"CoverageDefenitionType\": \"BASE\",'+
            '                  \"CoverageMiles\": \"100000\"'+
            '               }'+
            '            ]},'+
            '            \"WarrantyManualURL\": \"\",'+
            '            \"CoverageType\": \"NEW-New Engine Warranty\",'+
            '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
            '            \"ProcedureNumber\": \"\"'+
            '         }'+
            '      ]},'+
            '      \"ListOfExtendedCoverageDetails\": {\"ExtendedCoverageDetails\":       ['+
            '                  {'+
            '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
            '            \"WarrantyManualURL\": \"\",'+
            '            \"BeginMiles\": \"0\",'+
            '            \"EndMiles\": \"500000\",'+
            '            \"ProcedureNumber\": \"\",'+
            '            \"CertificateNumber\": \"TP41000811\",'+
            '            \"ProgramID\": \"TP4\",'+
            '            \"BeginHours\": \"0\",'+
            '            \"EndHours\": \"0\",'+
            '            \"EndDate\": \"09/21/2015\",'+
            '            \"StartDate\": \"09/21/2010\",'+
            '            \"Months\": \"60\",'+
            '            \"CAPCoverageID\": \"CRT\"'+
            '         },'+
            '                  {'+
            '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
            '            \"WarrantyManualURL\": \"\",'+
            '            \"BeginMiles\": \"0\",'+
            '            \"EndMiles\": \"300000\",'+
            '            \"ProcedureNumber\": \"\",'+
            '            \"CertificateNumber\": \"TP41000811\",'+
            '            \"ProgramID\": \"TP4\",'+
            '            \"BeginHours\": \"0\",'+
            '            \"EndHours\": \"0\",'+
            '            \"EndDate\": \"09/21/2013\",'+
            '            \"StartDate\": \"09/21/2010\",'+
            '            \"Months\": \"36\",'+
            '            \"CAPCoverageID\": \"APT\"'+
            '         }'+
            '      ]}'+
            '   }}'+
            '}';
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = css_testdata.createJobOrder(false);
        JO.Customer_Name__c = 'CBS Trucking';
        //JO.Model__c = 'Cummins';
        //JO.Service_Model_N__c = 2018;
        JO.Status__c = 'Closed';
        JO.Unit_Number__c = 'UN6789';
        Jo.Assigned_To__c = UserInfo.getUserId();
        jo.CoverageResponse__c = json;
        insert(JO);
        
        CSS_Service_Notes_Log__c sN = new CSS_Service_Notes_Log__c();
        sN.Name = 'Intake log';
        sN.Note_Type__c = 'Intake';
        sN.Notes__c = 'Sample Notes';
        sN.Job_Order__c = JO.Id;
        insert sN;
        
        CSS_Service_Notes_Log__c sN1 = new CSS_Service_Notes_Log__c();
        sN1.Name = 'Triage Notes';
        sN1.Note_Type__c = 'Triage';
        sN1.Notes__c = 'Sample Notes';
        sN1.Job_Order__c = JO.Id;
        insert sN1;
        
        CSS_CampTsbTrp__c Tsb1 = new CSS_CampTsbTrp__c();
        Tsb1.type__c = 'TSB';
        Tsb1.Job_Order__c = JO.Id;
        
        insert Tsb1;
        
        CSS_Service_Notes_Log__c sN2 = new CSS_Service_Notes_Log__c();
        sN2.Name = 'Repair Note';
        sN2.Note_Type__c ='Repair';
        sN2.Notes__c = 'Sample Notes';
        sN2.Job_Order__c = JO.Id;
        insert sN2;
        
        Note nts = new Note();
        nts.Title='Test';
        //nts.name = 'Test';
        nts.Body = 'This is the test class for'+UserInfo.getUserId();
        nts.ParentId = JO.Id;
        insert nts;
        
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        insert attach;
        
        //Add Test data
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        PageReference p=Page.CSS_Jobreadonly;
        Test.setCurrentPage(p);  
        
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        css_readOnlyController readonly = new css_readOnlyController();
        
        css_readOnlyController readonlyview = new css_readOnlyController();
        
        string x=readonlyview.getmil_measure();
        string y=readonlyview.getDtModify();
        string s=readonlyview.getDtStart();
        string d=readonlyview.getDtFailure();
        string v=readonlyview.getDtCreated();
        readonlyview.statusCode = 200;
        readonlyview.statusMessage = 'success';
        readonlyview.jobId = Jo.id;
        readonlyview.vMore_JobId=Jo.id;
        readonlyview.css_redirect();
        readonlyview.setmil_measure(x);
        readonlyview.showViewEdit = true;
        readonlyview.editTriage = true;
        // readonlyview.statusMessage='messageee';
        //  readonlyview.statusCode=123;
        readonlyview.showPopup();
        readonlyview.closePopup();
        readonlyview.showPopup4();
        readonlyview.closePopup4();
        readonlyview.showPopup8();
        readonlyview.closePopup8();
        readonlyview.getNotex();
        readonlyview.updateNotes();
        readonlyview.getTsbs();
        readonlyview.getInsiteTimeStamp();
        readonlyview.getFile();
        readonlyview.getRepair();
        readonlyview.getLocCode();
        readonlyview.getALLRecords();
        readonlyview.createAttachment(NULL);
        readonlyview.getAttachment(attach.ID);
        DateTime dInputDate = system.Now(); 
        readonlyview.getWarrantyDate(dInputDate); 
        boolean showExtCoverage = false;             
        /* Attachment attach2=new Attachment();    
attach2.Name='Unit Test Attachment';
Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
attach2.body=bodyBlob2;
attach2.parentId=jo.id;
insert attach2;*/
        Test.stopTest();
        
    }
}