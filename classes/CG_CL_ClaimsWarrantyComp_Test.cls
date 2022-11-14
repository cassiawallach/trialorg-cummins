@isTest
public class CG_CL_ClaimsWarrantyComp_Test
{
      public static Testmethod void CG_CL_ClaimsWarrantyCompwithFullCoverageDetails() 
    {
        //Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal210@testorg.com', user_Location__c = '02466-19134',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runAs(u){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c= '02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
            jo.Account__c = acc.id;
        insert jo;
        
        test.startTest();
        DateTime dInputDate=Datetime.now();
        String prevmil_measure='Kilometers';
        String mil_measure='Kilometers';
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.Customer_Code__c = 'Cummins';
        claimsobj.Customer_Contact_Phone__c = '12345';
        claimsobj.Contact_First_Name__c = 'Cummins';
        claimsobj.Contact_Last_Name__c = 'Guidanz';
        claimsobj.Country__c = 'India';
        claimsobj.Customer_Name__c = 'CSS';
        claimsobj.Email_Address__c = 'abc@cummins.com';
        claimsobj.Location__c = 'Columbus';
        claimsobj.ESN__c='56335346';
        //claimsobj.Region__c = 'INTERNATIONAL';
        claimsobj.Region__c='INTERNATIONAL';
        claimsobj.Territory__c='BELIZE';
        //claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        //claimsobj.CoverageResponse__c='{ "Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "WarrantyEndDate": "1/31/2020", "CoverageType": "NEW-New Engine Warranty", "ProcedureNumber": "111-503-065", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "6250", "CoverageMaxMonths": "12", "CoverageComponentTypeCode": "BELTS/HOSES", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" }, { "CoverageHours": "6250", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" } ] } },{"Status":"Active","ListOfCoverageDedutibles":{ "CoverageDedutibles": []},"WarrantyManualURL": "", "WarrantyEndDate": "1/31/2021", "CoverageType": "REW-Recon Engine Warranty", "ProcedureNumber": "", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "200000" }, { "CoverageHours": "0", "CoverageMaxMonths": "36", "CoverageComponentTypeCode": "EXTENDED", "MegawattHours": "0", "CoverageDefenitionType": "EXTENDED", "CoverageMinMonths": "0", "CoverageMiles": "300000" }, { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "INJECTOR", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "125000" } ] } }, { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html", "WarrantyEndDate": "1/31/2023", "CoverageType":"EMS-Emissions Warranty", "ProcedureNumber": "","ListOfCoverageComponentList":{"CoverageComponentList":[{ "CoverageHours": "0", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" }, { "CoverageHours": "3000", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS-CA", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" } ] } } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "Status": "Active", "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "Months": "24", "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "CAPCoverageID": "DC1", "ProgramID": "XT1", "BeginMiles": "647563", "EndDate": "02/01/2020", "StartDate": "02/01/2018", "BeginHours": "0", "EndMiles":"847563","CertificateNumber":"XT11002477","EndHours":"0","ProcedureNumber": "111-505-146"}]}}}}';	
        claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-146"}]}}}}';
            claimsobj.css_job__c = jo.id;
            insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        if(claimsobj.id != null){
            CG_CL_ClaimsWarranty mainContr1=new CG_CL_ClaimsWarranty();
            CG_CL_ClaimsWarranty mainContr=mainContr1;
        }
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=2.0;
            psnobj.Mileage_Measure__c='Miles';
        psnobj.PSN__c='56335346';
        psnobj.Failure_Date__c=system.today()+2;
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        CG_CL_ClaimsWarrantyComp cc = new CG_CL_ClaimsWarrantyComp();
        cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        cc.loadBasicData();
        cc.regionTerritory();
        cc.coverageSearch();
        cc.getItems();
        cc.gettoken();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
           cc.getFormatedFailureDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        
        cc.SOQLClaimsJob();
        cc.basicCoverageDetails=null;
        cc.milekmconv();
        
        test.stopTest();
      }
    } 
     public static Testmethod void CG_CL_ClaimsWarrantyCompwithFullCoverageDetails1()
    {
       // Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal310@testorg.com', user_Location__c = '02466-19134',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runAs(u){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c= '02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
            jo.Account__c = acc.id;
        insert jo;
        
        test.startTest();
        DateTime dInputDate=Datetime.now();
        String prevmil_measure='Kilometers';
        String mil_measure='Kilometers';
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.Customer_Code__c = 'Cummins';
        claimsobj.Customer_Contact_Phone__c = '12345';
        claimsobj.Contact_First_Name__c = 'Cummins';
        claimsobj.Contact_Last_Name__c = 'Guidanz';
        claimsobj.Country__c = 'India';
        claimsobj.Customer_Name__c = 'CSS';
        claimsobj.Email_Address__c = 'abc@cummins.com';
        claimsobj.Location__c = 'Columbus';
        claimsobj.ESN__c='56335346';
        //claimsobj.Region__c = 'INTERNATIONAL';
        claimsobj.Region__c='INTERNATIONAL';
        claimsobj.Territory__c='BELIZE';
        //claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        //claimsobj.CoverageResponse__c='{ "Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "WarrantyEndDate": "1/31/2020", "CoverageType": "NEW-New Engine Warranty", "ProcedureNumber": "111-503-065", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "6250", "CoverageMaxMonths": "12", "CoverageComponentTypeCode": "BELTS/HOSES", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" }, { "CoverageHours": "6250", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" } ] } },{"Status":"Active","ListOfCoverageDedutibles":{ "CoverageDedutibles": []},"WarrantyManualURL": "", "WarrantyEndDate": "1/31/2021", "CoverageType": "REW-Recon Engine Warranty", "ProcedureNumber": "", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "200000" }, { "CoverageHours": "0", "CoverageMaxMonths": "36", "CoverageComponentTypeCode": "EXTENDED", "MegawattHours": "0", "CoverageDefenitionType": "EXTENDED", "CoverageMinMonths": "0", "CoverageMiles": "300000" }, { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "INJECTOR", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "125000" } ] } }, { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html", "WarrantyEndDate": "1/31/2023", "CoverageType":"EMS-Emissions Warranty", "ProcedureNumber": "","ListOfCoverageComponentList":{"CoverageComponentList":[{ "CoverageHours": "0", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" }, { "CoverageHours": "3000", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS-CA", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" } ] } } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "Status": "Active", "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "Months": "24", "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "CAPCoverageID": "DC1", "ProgramID": "XT1", "BeginMiles": "647563", "EndDate": "02/01/2020", "StartDate": "02/01/2018", "BeginHours": "0", "EndMiles":"847563","CertificateNumber":"XT11002477","EndHours":"0","ProcedureNumber": "111-505-146"}]}}}}';	
       // claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-146"}]}}}}';
       claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"9999999","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"10"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"10"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
            //claimsobj.css_job__c = jo.id;
            insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        if(claimsobj.id != null){
            CG_CL_ClaimsWarranty mainContr1=new CG_CL_ClaimsWarranty();
            CG_CL_ClaimsWarranty mainContr=mainContr1;
        }
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=0.0;
        psnobj.PSN__c='56335346';
            psnobj.Product_Hours__c=1;
            psnobj.Mileage_Measure__c='Miles';
            psnobj.Failure_Date__c=system.today()+2;
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);  
            CG_CL_ClaimsWarrantyComp cc = new CG_CL_ClaimsWarrantyComp(); 
          CG_CL_ClaimsWarranty C = new CG_CL_ClaimsWarranty();
        //cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        cc.myBase64String='TESSS';
        //cc.pagName='intakeWarranty';
        cc.mainContr=C;
        //cc.warrentyStartD=System.Today();
        //cc.coverageMaxMonth=0;
        //cc.testVar='TESTTT';
        cc.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        cc.loadBasicData();
        cc.regionTerritory();
        cc.coverageSearch();
        cc.getItems();
        //cc.gettoken();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        
        cc.SOQLClaimsJob();
        //cc.basicCoverageDetails=null;
        cc.milekmconv();
        
        test.stopTest();
      }
    }
     public static Testmethod void CG_CL_ClaimsWarrantyCompwithFullCoverageDetails2() 
    {
       // Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal210@testorg.com', user_Location__c = '02466-19134',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runAs(u){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c= '02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
            jo.Account__c = acc.id;
        insert jo;
        
        test.startTest();
        DateTime dInputDate=Datetime.now();
        String prevmil_measure='Kilometers';
        String mil_measure='Kilometers';
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.Customer_Code__c = 'Cummins';
        claimsobj.Customer_Contact_Phone__c = '12345';
        claimsobj.Contact_First_Name__c = 'Cummins';
        claimsobj.Contact_Last_Name__c = 'Guidanz';
        claimsobj.Country__c = 'India';
        claimsobj.Customer_Name__c = 'CSS';
        claimsobj.Email_Address__c = 'abc@cummins.com';
        claimsobj.Location__c = 'Columbus';
        claimsobj.ESN__c='56335346';
        //claimsobj.Region__c = 'INTERNATIONAL';
        claimsobj.Region__c='INTERNATIONAL';
        claimsobj.Territory__c='BELIZE';
        //claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        //claimsobj.CoverageResponse__c='{ "Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "WarrantyEndDate": "1/31/2020", "CoverageType": "NEW-New Engine Warranty", "ProcedureNumber": "111-503-065", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "6250", "CoverageMaxMonths": "12", "CoverageComponentTypeCode": "BELTS/HOSES", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" }, { "CoverageHours": "6250", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" } ] } },{"Status":"Active","ListOfCoverageDedutibles":{ "CoverageDedutibles": []},"WarrantyManualURL": "", "WarrantyEndDate": "1/31/2021", "CoverageType": "REW-Recon Engine Warranty", "ProcedureNumber": "", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "200000" }, { "CoverageHours": "0", "CoverageMaxMonths": "36", "CoverageComponentTypeCode": "EXTENDED", "MegawattHours": "0", "CoverageDefenitionType": "EXTENDED", "CoverageMinMonths": "0", "CoverageMiles": "300000" }, { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "INJECTOR", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "125000" } ] } }, { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html", "WarrantyEndDate": "1/31/2023", "CoverageType":"EMS-Emissions Warranty", "ProcedureNumber": "","ListOfCoverageComponentList":{"CoverageComponentList":[{ "CoverageHours": "0", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" }, { "CoverageHours": "3000", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS-CA", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" } ] } } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "Status": "Active", "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "Months": "24", "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "CAPCoverageID": "DC1", "ProgramID": "XT1", "BeginMiles": "647563", "EndDate": "02/01/2020", "StartDate": "02/01/2018", "BeginHours": "0", "EndMiles":"847563","CertificateNumber":"XT11002477","EndHours":"0","ProcedureNumber": "111-505-146"}]}}}}';	
        claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-146"}]}}}}';
            claimsobj.css_job__c = jo.id;
            insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        if(claimsobj.id != null){
            CG_CL_ClaimsWarranty mainContr1=new CG_CL_ClaimsWarranty();
            CG_CL_ClaimsWarranty mainContr=mainContr1;
        }
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=2.0;
            psnobj.Mileage_Measure__c='Kilometers';
        psnobj.PSN__c='56335346';
        psnobj.Failure_Date__c=system.today()+2;
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        CG_CL_ClaimsWarrantyComp cc = new CG_CL_ClaimsWarrantyComp();
        cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        cc.loadBasicData();
        cc.regionTerritory();
        cc.coverageSearch();
        cc.getItems();
        cc.gettoken();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
           cc.getFormatedFailureDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        
        cc.SOQLClaimsJob();
        cc.basicCoverageDetails=null;
        cc.milekmconv();
        
        test.stopTest();
      }
    } 
     public static Testmethod void CG_CL_ClaimsWarrantyCompwithFullCoverageDetails4()
    {
      //  Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal310@testorg.com', user_Location__c = '02466-19134',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runAs(u){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c= '02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
            jo.Account__c = acc.id;
        insert jo;
        
        test.startTest();
        DateTime dInputDate=Datetime.now();
        String prevmil_measure='Kilometers';
        String mil_measure='Kilometers';
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.Customer_Code__c = 'Cummins';
        claimsobj.Customer_Contact_Phone__c = '12345';
        claimsobj.Contact_First_Name__c = 'Cummins';
        claimsobj.Contact_Last_Name__c = 'Guidanz';
        claimsobj.Country__c = 'India';
        claimsobj.Customer_Name__c = 'CSS';
        claimsobj.Email_Address__c = 'abc@cummins.com';
        claimsobj.Location__c = 'Columbus';
        claimsobj.ESN__c='56335346';
        //claimsobj.Region__c = 'INTERNATIONAL';
        claimsobj.Region__c='INTERNATIONAL';
        claimsobj.Territory__c='BELIZE';
        //claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        //claimsobj.CoverageResponse__c='{ "Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "WarrantyEndDate": "1/31/2020", "CoverageType": "NEW-New Engine Warranty", "ProcedureNumber": "111-503-065", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "6250", "CoverageMaxMonths": "12", "CoverageComponentTypeCode": "BELTS/HOSES", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" }, { "CoverageHours": "6250", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" } ] } },{"Status":"Active","ListOfCoverageDedutibles":{ "CoverageDedutibles": []},"WarrantyManualURL": "", "WarrantyEndDate": "1/31/2021", "CoverageType": "REW-Recon Engine Warranty", "ProcedureNumber": "", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "200000" }, { "CoverageHours": "0", "CoverageMaxMonths": "36", "CoverageComponentTypeCode": "EXTENDED", "MegawattHours": "0", "CoverageDefenitionType": "EXTENDED", "CoverageMinMonths": "0", "CoverageMiles": "300000" }, { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "INJECTOR", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "125000" } ] } }, { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html", "WarrantyEndDate": "1/31/2023", "CoverageType":"EMS-Emissions Warranty", "ProcedureNumber": "","ListOfCoverageComponentList":{"CoverageComponentList":[{ "CoverageHours": "0", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" }, { "CoverageHours": "3000", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS-CA", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" } ] } } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "Status": "Active", "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "Months": "24", "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "CAPCoverageID": "DC1", "ProgramID": "XT1", "BeginMiles": "647563", "EndDate": "02/01/2020", "StartDate": "02/01/2018", "BeginHours": "0", "EndMiles":"847563","CertificateNumber":"XT11002477","EndHours":"0","ProcedureNumber": "111-505-146"}]}}}}';	
       // claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-146"}]}}}}';
      claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"9999999","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"10"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"10"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
            //claimsobj.css_job__c = jo.id;
            insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        if(claimsobj.id != null){
            CG_CL_ClaimsWarranty mainContr1=new CG_CL_ClaimsWarranty();
            CG_CL_ClaimsWarranty mainContr=mainContr1;
        }
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=0.0;
        psnobj.PSN__c='56335346';
            psnobj.Product_Hours__c=1;
            psnobj.Mileage_Measure__c='Kilometers';
            psnobj.Failure_Date__c=system.today()+2;
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);  
            CG_CL_ClaimsWarrantyComp cc = new CG_CL_ClaimsWarrantyComp(); 
          CG_CL_ClaimsWarranty C = new CG_CL_ClaimsWarranty();
        //cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        cc.myBase64String='TESSS';
        //cc.pagName='intakeWarranty';
        cc.mainContr=C;
        //cc.warrentyStartD=System.Today();
        //cc.coverageMaxMonth=0;
        //cc.testVar='TESTTT';
        cc.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        cc.loadBasicData();
        cc.regionTerritory();
        cc.coverageSearch();
        cc.getItems();
        //cc.gettoken();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        
        cc.SOQLClaimsJob();
        //cc.basicCoverageDetails=null;
        cc.milekmconv();
        
        test.stopTest();
      }
    }
     public static Testmethod void CG_CL_ClaimsWarrantyCompwithFullCoverageDetails5()
    {
       // Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal310@testorg.com', user_Location__c = '02466-19134',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runAs(u){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c= '02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            css_job_order__C jo = new css_job_order__C();
        jo.Warranty_Start_Date__c=system.today();
            jo.Account__c = acc.id;
        insert jo;
        
        test.startTest();
        DateTime dInputDate=Datetime.now();
        String prevmil_measure='Kilometers';
        String mil_measure='Kilometers';
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.Customer_Code__c = 'Cummins';
        claimsobj.Customer_Contact_Phone__c = '12345';
        claimsobj.Contact_First_Name__c = 'Cummins';
        claimsobj.Contact_Last_Name__c = 'Guidanz';
        claimsobj.Country__c = 'India';
        claimsobj.Customer_Name__c = 'CSS';
        claimsobj.Email_Address__c = 'abc@cummins.com';
        claimsobj.Location__c = 'Columbus';
        claimsobj.ESN__c='56335346';
        //claimsobj.Region__c = 'INTERNATIONAL';
        claimsobj.Region__c='INTERNATIONAL';
        claimsobj.Territory__c='BELIZE';
        //claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        //claimsobj.CoverageResponse__c='{ "Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "WarrantyEndDate": "1/31/2020", "CoverageType": "NEW-New Engine Warranty", "ProcedureNumber": "111-503-065", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "6250", "CoverageMaxMonths": "12", "CoverageComponentTypeCode": "BELTS/HOSES", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" }, { "CoverageHours": "6250", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "250000" } ] } },{"Status":"Active","ListOfCoverageDedutibles":{ "CoverageDedutibles": []},"WarrantyManualURL": "", "WarrantyEndDate": "1/31/2021", "CoverageType": "REW-Recon Engine Warranty", "ProcedureNumber": "", "ListOfCoverageComponentList": { "CoverageComponentList": [ { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "BASE", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "200000" }, { "CoverageHours": "0", "CoverageMaxMonths": "36", "CoverageComponentTypeCode": "EXTENDED", "MegawattHours": "0", "CoverageDefenitionType": "EXTENDED", "CoverageMinMonths": "0", "CoverageMiles": "300000" }, { "CoverageHours": "0", "CoverageMaxMonths": "24", "CoverageComponentTypeCode": "INJECTOR", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "125000" } ] } }, { "Status": "Active", "ListOfCoverageDedutibles": { "CoverageDedutibles": [] }, "WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html", "WarrantyEndDate": "1/31/2023", "CoverageType":"EMS-Emissions Warranty", "ProcedureNumber": "","ListOfCoverageComponentList":{"CoverageComponentList":[{ "CoverageHours": "0", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" }, { "CoverageHours": "3000", "CoverageMaxMonths": "60", "CoverageComponentTypeCode": "EMISSIONS-CA", "MegawattHours": "0", "CoverageDefenitionType": "BASE", "CoverageMinMonths": "0", "CoverageMiles": "100000" } ] } } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "Status": "Active", "WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=", "Months": "24", "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "CAPCoverageID": "DC1", "ProgramID": "XT1", "BeginMiles": "647563", "EndDate": "02/01/2020", "StartDate": "02/01/2018", "BeginHours": "0", "EndMiles":"847563","CertificateNumber":"XT11002477","EndHours":"0","ProcedureNumber": "111-505-146"}]}}}}';	
       // claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-146"}]}}}}';
       claimsobj.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"9999999","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"10"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"10"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
            //claimsobj.css_job__c = jo.id;
            insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        if(claimsobj.id != null){
            CG_CL_ClaimsWarranty mainContr1=new CG_CL_ClaimsWarranty();
            CG_CL_ClaimsWarranty mainContr=mainContr1;
        }
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today()-1;
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=0.0;
        psnobj.PSN__c='56335346';
            psnobj.Product_Hours__c=1;
            psnobj.Mileage_Measure__c='Kilometers';
            psnobj.Failure_Date__c=system.today()+2;
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);  
            CG_CL_ClaimsWarrantyComp cc = new CG_CL_ClaimsWarrantyComp(); 
          CG_CL_ClaimsWarranty C = new CG_CL_ClaimsWarranty();
        //cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        cc.myBase64String='TESSS';
        //cc.pagName='intakeWarranty';
        cc.mainContr=C;
        //cc.warrentyStartD=System.Today();
        //cc.coverageMaxMonth=0;
        //cc.testVar='TESTTT';
        cc.mil_measure='Kilometers';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        cc.loadBasicData();
        cc.regionTerritory();
        cc.coverageSearch();
        cc.getItems();
        //cc.gettoken();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        
        cc.SOQLClaimsJob();
        //cc.basicCoverageDetails=null;
        cc.milekmconv();
        
        test.stopTest();
      }
    }

    
}