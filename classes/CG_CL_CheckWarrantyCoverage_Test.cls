@isTest
public class CG_CL_CheckWarrantyCoverage_Test 
{ 
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method()
    {       
        test.startTest();
        
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.FormattedDate='Date.today()';
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=true;
        aa.applnMandatoryFlag=true;
        aa.wsdMandatoryFlag=true;
        aa.failDateMandatoryFlag=true;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.prodcodeErrormessage=true;
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        aa.EmmisionWarrantyDedutibles = 'test';
        aa.ExtendedWarrantyDedutibles= 'test';
        aa.ReconWarrantyDedutibles= 'test';
        aa.NewEngWarrantyDedutibles= 'test';
        
        Account acc = new Account();
        //acc = css_utility.getRegionTerritory('');
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj; 
        
        CSS_Claims__c claimsobj1 = new CSS_Claims__c();
        claimsobj1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj1;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        aa.claim=claimsobj1;
        aa.dt_FailureDate=system.now();
        aa.mil_measure='Kilometers';        
        // cc.psnRec=psnobj;
        aa.startRequest();
        //aa.startRequest_Existing();
        aa.getRegionTerritory();
        aa.searchMethod();
        aa.milekmconv();
        aa.getItems();
        aa.closeSrvModPopup();
        aa.getApplication();
        aa.MakeBISReadOnly();
        aa.MakeWSDReadOnly();
        //aa.updateproductappcode();
        //aa.getFormattedDate=('date.today');
        
        //cc.getWarrantyDate(dInputDate);
        aa.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        aa.basicCoverageDetails=null;
        aa.milekmconv();
        //aa.getFormattedDate('');
        test.stopTest();
    } 
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method1()
    {        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d + 7;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.FormattedDate=null;
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=true;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=true;
        aa.applnMandatoryFlag=true;
        aa.wsdMandatoryFlag=true;
        aa.failDateMandatoryFlag=true;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;       
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        
        aa.mil_measure='Kilometers';        
        // cc.psnRec=psnobj;
        aa.startRequest();
        //aa.startRequest_Existing();
        aa.getRegionTerritory();
        aa.searchMethod();
        aa.getItems();
        aa.closeSrvModPopup();
        aa.getApplication();
        aa.MakeBISReadOnly();
        aa.MakeWSDReadOnly();
        //aa.updateproductappcode();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        aa.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        aa.basicCoverageDetails=null;
        aa.milekmconv();
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        test.stopTest();
    } 
    
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method3()
    {
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage dd = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        dd.WarrStartDt=d - 7;
        dd.failureDt=d;
        dd.psn='57788989';	
        dd.warrStDtHidden=null;	   
        dd.filterApplication='';
        dd.wsdReadOnlyFromContr=true;
        dd.ExternReturnDateFlag=true;
        dd.ReadonlyBIS= true;
        dd.FormattedDate=null;
        dd.ReadonlyWSD=null;
        dd.prodcodeErrormessage = false;
        dd.prodHours=null;
        dd.prodMileKm=null; 
        dd.regionMandatoryFlag=false;
        dd.territoryMandatoryFlag=false;
        dd.psnMandatoryFlag=false;
        dd.applnMandatoryFlag=false;
        dd.wsdMandatoryFlag=false;
        dd.failDateMandatoryFlag=false;
        dd.recconFlag=true; 
        dd.reqWrcoverBoolean= true;
        dd.reqWrTerBoolean= true;
        
        dd.reqWrcertBoolean= true;
        dd.showExtCoverage=null;
        dd.emissionStatus=null;
        dd.productAppcode=null;
        dd.productAppdesc=null;
        
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.CoverageResponse__c='{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "7/15/2017","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-077","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "ACCESSORIES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "STRT/ALT","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}},{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate": "7/15/2020","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "5000","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        //testclaimsRec.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert testclaimsRec;
        
        //css_psn__c psn1 = new css_psn__c();
        /*psn1.CSS_Claims__c= testclaimsRec.id;
psn1.Warranty_Start_Date__c=system.today();
psn1.Before_In_Service__c=false;
psn1.Failure_Date__c=system.today();
psn1.Unit_Type__c='';
//psn1.PSN__c = '1079446';
//  psn.Justification__c='Field Action';
insert psn1;*/
        
        
        //system.debug('PSN ID:'+psn1.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);      
        
        dd.mil_measure='Kilometers';        
        // dd.psnRec=psnobj;
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        dd.startRequest();
        //dd.startRequest_Existing();
        dd.getRegionTerritory();
        dd.searchMethod();
        dd.milekmconv();
        dd.getItems();
        dd.closeSrvModPopup();
        dd.getApplication();
        dd.MakeBISReadOnly();
        dd.MakeWSDReadOnly();
        //dd.updateproductappcode();
        dd.closeSrvModPopup1();
        dd.getFormatedFailureDate();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        dd.getWarrCreatedDate(); 
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        dd.basicCoverageDetails=null;
        // dd.milekmconv(); 
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        Req.EtoConversionDate='2013-10-14T00:00:00.000-04:00';
        
        test.startTest();
        CG_CL_CheckWarrantyCoverage POPUP = new CG_CL_CheckWarrantyCoverage();
        POPUP.startRequest();
        test.stoptest();
    }
    
    //to test getEngineData service down
    /*public static Testmethod void getEngineDataDown_Method() 
{
Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
//Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResJ2ADown_Mockup_Test());
CG_CL_CheckWarrantyCoverage dd = new CG_CL_CheckWarrantyCoverage();
date d = Date.today();
dd.WarrStartDt=d - 7;
dd.failureDt=d;
dd.psn='57788989';	
dd.warrStDtHidden=null;	   
dd.filterApplication='';
dd.wsdReadOnlyFromContr=true;
dd.ExternReturnDateFlag=true;
dd.ReadonlyBIS= true;
dd.FormattedDate=null;
dd.ReadonlyWSD=null;
dd.prodcodeErrormessage = false;
dd.prodHours=null;
dd.prodMileKm=null; 
dd.regionMandatoryFlag=false;
dd.territoryMandatoryFlag=false;
dd.psnMandatoryFlag=false;
dd.applnMandatoryFlag=false;
dd.wsdMandatoryFlag=false;
dd.failDateMandatoryFlag=false;
dd.recconFlag=true; 
dd.reqWrcoverBoolean= true;
dd.reqWrTerBoolean= true;

dd.reqWrcertBoolean= true;
dd.showExtCoverage=null;
dd.emissionStatus=null;
dd.productAppcode=null;
dd.productAppdesc=null;


CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
testclaimsRec.Customer_Name__c='TestCustomer';
testclaimsRec.Customer_Code__c = '1234';
testclaimsRec.Contact_Last_Name__c = 'T';
testclaimsRec.Address__c = 'T';
testclaimsRec.Customer_Contact_Phone__c = null;
testclaimsRec.Email_Address__c = 'rp@sct.com';
testclaimsRec.Status__c = 'Draft';
testclaimsRec.TSR1__c = '1234';
testclaimsRec.TSR2__c = '1234';
testclaimsRec.TSR3__c = '1234';
testclaimsRec.TSR4__c = '1234';
testclaimsRec.TSR5__c = '1234';
testclaimsRec.TSR6__c = '1234';
testclaimsRec.TSR7__c = '1234';
testclaimsRec.TSR8__c = '1234';
testclaimsRec.TSR9__c = '1234';
testclaimsRec.TSR10__c = '1234';
testclaimsRec.Country__c = '1234';
testclaimsRec.State__c = '1234';
testclaimsRec.ZipCode__c = '12345-1234';
testclaimsRec.CoverageResponse__c='{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "7/15/2017","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-077","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "ACCESSORIES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "STRT/ALT","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}},{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate": "7/15/2020","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "5000","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
//testclaimsRec.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
insert testclaimsRec;

//css_psn__c psn1 = new css_psn__c();
//psn1.CSS_Claims__c= testclaimsRec.id;
//psn1.Warranty_Start_Date__c=system.today();
//psn1.Before_In_Service__c=false;
//psn1.Failure_Date__c=system.today();
//psn1.Unit_Type__c='';
//psn1.PSN__c = '1079446';
//  psn.Justification__c='Field Action';
//insert psn1;


//system.debug('PSN ID:'+psn1.id);
PageReference pg = Page.CG_ClaimsWarranty;
Test.setCurrentPage(pg);    
apexpages.currentPage().getparameters().put('id',testclaimsRec.id);      

dd.mil_measure='Kilometers';        
// dd.psnRec=psnobj;

test.startTest();
Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResJ2ADown_Mockup_Test());
dd.startRequest();
//dd.startRequest_Existing();
dd.getRegionTerritory();
dd.searchMethod();
dd.milekmconv();
dd.getItems();
dd.closeSrvModPopup();
dd.getApplication();
dd.MakeBISReadOnly();
dd.MakeWSDReadOnly();
//dd.updateproductappcode();
dd.closeSrvModPopup1();
dd.getFormatedFailureDate();
//aa.getFormattedDate();

//cc.getWarrantyDate(dInputDate);
dd.getWarrCreatedDate(); 
//   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
dd.basicCoverageDetails=null;
// dd.milekmconv(); 

test.stoptest();
}*/
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method4()
    {
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CG_CL_CheckWarrantyCoverage dd = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        dd.WarrStartDt=null;
        dd.failureDt=null;
        dd.psn='57788989';	
        dd.warrStDtHidden=null;	   
        dd.filterApplication='Automation';
        dd.wsdReadOnlyFromContr=true;
        dd.ExternReturnDateFlag=true;
        dd.ReadonlyBIS= true;
        dd.FormattedDate=null;
        dd.ReadonlyWSD=null;
        dd.prodHours=null;
        dd.prodMileKm=null; 
        dd.regionMandatoryFlag=false;
        dd.territoryMandatoryFlag=false;
        dd.psnMandatoryFlag=false;
        dd.applnMandatoryFlag=false;
        dd.wsdMandatoryFlag=true;
        dd.failDateMandatoryFlag=true;
        dd.recconFlag=true; 
        dd.reqWrcoverBoolean= true;
        dd.reqWrTerBoolean= true;
        
        dd.reqWrcertBoolean= true;
        dd.showExtCoverage=null;
        dd.emissionStatus=null;
        dd.productAppcode=null;
        dd.productAppdesc=null;
        dd.prodcodeErrormessage = true;
        
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.CoverageResponse__c='{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "7/15/2017","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-077","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "ACCESSORIES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "STRT/ALT","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}},{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate": "7/15/2020","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "5000","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert testclaimsRec;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c= testclaimsRec.id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Before_In_Service__c=false;
        psn1.Failure_Date__c=system.today();
        psn1.Unit_Type__c='';
        psn1.PSN__c = '1079446';
        //  psn.Justification__c='Field Action';
        insert psn1;
        CSS_JobEventTemporary__c jobtemp = CSS_TestData.createJobEventTempObj(false);
        jobtemp.Key__c = 'MarketingApplicationCodes';
        insert jobtemp;
        system.debug('PSN ID:'+psn1.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);      
        
        dd.mil_measure='Kilometers';        
        // cc.psnRec=psnobj;
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        dd.startRequest();
        //dd.startRequest_Existing();
        dd.getRegionTerritory();
        dd.searchMethod();
        dd.milekmconv();
        dd.getItems();
        dd.closeSrvModPopup();
        dd.getApplication();
        dd.MakeBISReadOnly();
        dd.MakeWSDReadOnly();
        //dd.updateproductappcode();
        dd.closeSrvModPopup1();
        dd.getFormatedFailureDate();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        dd.getWarrCreatedDate(); 
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        dd.basicCoverageDetails=null;
        // dd.milekmconv(); 
        
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        //CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        //CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        
        //Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        //Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        //Req.EtoConversionDate='2013-10-14T00:00:00.000-04:00';
        
        test.startTest();
        CG_CL_CheckWarrantyCoverage POPUP = new CG_CL_CheckWarrantyCoverage();
        //POPUP.startRequest();
        test.stoptest();
    }
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method5()
    {
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage dd = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        dd.WarrStartDt=d-7;
        dd.failureDt=d;
        dd.psn='57788989';	
        dd.warrStDtHidden=null;	   
        dd.filterApplication='Automation';
        dd.wsdReadOnlyFromContr=true;
        dd.ExternReturnDateFlag=true;
        //dd.warrStartDt_Final=null;
        dd.ReadonlyBIS= true;
        dd.FormattedDate=null;
        dd.ReadonlyWSD=null;
        dd.prodHours=null;
        dd.prodMileKm=null; 
        dd.regionMandatoryFlag=false;
        dd.territoryMandatoryFlag=false;
        dd.psnMandatoryFlag=false;
        dd.applnMandatoryFlag=false;
        dd.wsdMandatoryFlag=false;
        dd.failDateMandatoryFlag=false;
        dd.recconFlag=true; 
        dd.reqWrcoverBoolean= true;
        dd.reqWrTerBoolean= true;
        
        dd.reqWrcertBoolean= true;
        dd.showExtCoverage=null;
        dd.emissionStatus=null;
        dd.productAppcode=null;
        dd.productAppdesc=null;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.CoverageResponse__c='{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "7/15/2017","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-077","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9999999","CoverageMaxMonths": "3","CoverageComponentTypeCode": "ACCESSORIES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "STRT/ALT","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}},{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate": "7/15/2020","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9999999","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert testclaimsRec;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c= testclaimsRec.id;
        psn1.Warranty_Start_Date__c=d-7;
        psn1.Before_In_Service__c=false;
        psn1.Failure_Date__c=system.today();
        psn1.Unit_Type__c='';
        psn1.PSN__c = '1079446';
        //  psn.Justification__c='Field Action';
        insert psn1;
        
        
        system.debug('PSN ID:'+psn1.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);      
        
        dd.mil_measure='Kilometers'; 
        string filterLabel='130-Automotive';
        // cc.psnRec=psnobj;
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        dd.getApplication();
        dd.applicationCode = '130';
        dd.searchMethod();
        dd.milekmconv();
        //dd.updateproductappcode();
        
        //cc.getWarrantyDate(dInputDate);
        dd.getWarrCreatedDate(); 
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        dd.basicCoverageDetails=null;
        //dd.milekmconv(); 
        
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        //CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        //CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        
        //Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        //Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        //Req.EtoConversionDate='2013-10-14T00:00:00.000-04:00';
        
        test.startTest();
        CG_CL_CheckWarrantyCoverage POPUP = new CG_CL_CheckWarrantyCoverage();
        //POPUP.getRegionValues();
        //POPUP.startRequest();
        test.stoptest();
    }
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method6()
    {        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.FormattedDate=null;
        aa.ReadonlyWSD=null;
        aa.prodHours='45';
        aa.prodMileKm='35'; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=true;
        aa.applnMandatoryFlag=true;
        aa.wsdMandatoryFlag=true;
        aa.failDateMandatoryFlag=true;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;       
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        
        aa.mil_measure='Kilometers';        
        // cc.psnRec=psnobj;
        Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        aa.startRequest();
        //aa.startRequest_Existing();
        
        aa.searchMethod();
        //aa.milekmconv();
        //aa.getItems();
        //aa.closeSrvModPopup();
        aa.getApplication();
        aa.MakeBISReadOnly();
        aa.MakeWSDReadOnly();
        //aa.updateproductappcode();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        aa.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        aa.basicCoverageDetails=null;
        // aa.milekmconv();
        
        test.stopTest();
    }
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method7()
    {        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.applicationCode = '130';
        aa.psn='79619554';
        aa.failureDt=null;
        aa.regionSelected = 'test';
        aa.territorySelected = 'test';
        aa.recconFlag = false;
        aa.prodMileKm = '100';
        aa.mil_measure = 'Miles';
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.bisFlag=false;
        aa.FormattedDate=null;
        aa.ReadonlyWSD=null;
        aa.prodHours='45';
        aa.prodMileKm='35'; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=false;
        aa.applnMandatoryFlag=false;
        aa.wsdMandatoryFlag=false;
        aa.failDateMandatoryFlag=false;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Expired" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;       
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        
        aa.mil_measure='Kilometers';        
        // cc.psnRec=psnobj;
        Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //aa.startRequest();
        aa.warrStartDt_Final=null;
        //aa.filterLabel='Test';
        aa.searchMethod();
        //aa.milekmconv();
        //aa.getItems();
        //aa.closeSrvModPopup();
        //aa.getApplication();
        ////aa.MakeBISReadOnly();
        //aa.MakeWSDReadOnly();
        
        //aa.updateproductappcode();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        //aa.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        aa.basicCoverageDetails=null;
        // aa.milekmconv();
        
        test.stopTest();
    }
    
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method8()
    {        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=null;
        aa.psn='74868686';	
        aa.warrStDtHidden=null;
        aa.filterApplication='MARINE (HEAVY DUTY)';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.bisFlag=true;
        //aa.failureDt=null;
        aa.FormattedDate=null;
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm='1'; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=true;
        aa.applnMandatoryFlag=true;
        aa.wsdMandatoryFlag=true;
        aa.failDateMandatoryFlag=true;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.mil_measure='Miles';
        aa.applicationCode='130';
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode='1234';
        aa.productAppdesc='test';
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;       
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        
        string basicCoverageDetails='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "0" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "12-12-2022", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        aa.mil_measure='Miles';        
        // cc.psnRec=psnobj;
        aa.startRequest();
        //aa.startRequest_Existing();
        aa.getRegionTerritory();
        aa.bisFlag=true;
        aa.UnitMiles='Kilometers';
        aa.PointMiles='0';
        aa.UnitHours='Hours';
        aa.PointHours='0';
        aa.searchMethod();
        aa.milekmconv();
        aa.getItems();
        aa.territoryMandatoryFlag = false;
        aa.closeSrvModPopup();
        aa.failDateMandatoryFlag = true;
        aa.wsdMandatoryFlag = false;
        aa.getApplication();
        aa.MakeBISReadOnly();
        aa.MakeWSDReadOnly();
        //aa.updateproductappcode();
        //aa.getFormattedDate();
        
        //cc.getWarrantyDate(dInputDate);
        aa.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        // aa.basicCoverageDetails=null;
        //aa.milekmconv();
        
        test.stopTest();
    } 
    
    public static Testmethod void CG_CL_ClaimsWarrantyComp_sblwsMethod()
    {
        
        DateTime dInputDate=Datetime.now();
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
        claimsobj.Region__c='NORTH AMERICA';
        claimsobj.Territory__c='UNITED STATES';
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Failure_Date__c=system.today()-5;
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=2.0;
        psnobj.PSN__c='56335346';
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsIntake;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);    
        Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        test.startTest();
        CG_CL_CheckWarrantyCoverage cc = new CG_CL_CheckWarrantyCoverage();
        cc.mil_measure='Kilometers';
        // cc.psnRec=psnobj;
        
        
        
        system.debug('Testclass starts');
        cc.startRequest();
        //cc.startRequest_Existing();
        cc.getRegionTerritory();
        cc.searchMethod();
        cc.milekmconv();
        cc.getItems();
        cc.closeSrvModPopup();
        cc.getApplication();
        cc.MakeBISReadOnly();
        cc.MakeWSDReadOnly();
        //cc.updateproductappcode();
        //cc.getWarrantyDate(dInputDate);
        cc.getWarrCreatedDate();
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        cc.basicCoverageDetails=null;
        //   cc.milekmconv();
        CG_CL_CheckWarrantyCoverage.getDependentPicklistValues(CSS_Claims__c.Territory__c);
        cc.regionSelected = 'INTERNATIONAL';
        cc.getRegionValues();
        cc.getTerritoryValues();
        cc.prodcodeErrormessage = true;
        test.stopTest();
    }
    public static Testmethod void CG_CL_ClaimsWarrantyComp_sblwsMethod1()
    {
        
        DateTime dInputDate=Datetime.now();
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
        claimsobj.Region__c='NORTH AMERICA';
        claimsobj.Territory__c='UNITED STATES';
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        system.debug('CLAIMS ID:'+claimsobj.id);
        css_psn__c psnobj=new css_psn__c();
        psnobj.CSS_Claims__c =claimsobj.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Failure_Date__c=system.today()-5;
        psnobj.Application__c='Testing';
        psnobj.Primary__c=true;
        psnobj.Mileage__c=2.0;
        psnobj.PSN__c='56335346';
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        CSS_JobEventTemporary__c jet = new CSS_JobEventTemporary__c();
        jet.Key__c = 'MarketingApplicationCodes';
        jet.Attribute1__c = 'test1';
        jet.Attribute3__c = 'test2';
        insert jet;
        PageReference pg = Page.CG_ClaimsIntake;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);    
        Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        test.startTest();
        CG_CL_CheckWarrantyCoverage cc = new CG_CL_CheckWarrantyCoverage();
        cc.psn = '79464646';
        cc.mil_measure='Kilometers';
        cc.productAppcode = 'test1';
        cc.productAppdesc = 'test2';
        
        // cc.psnRec=psnobj;
        cc.failureDt = null;	
        cc.regionSelected = 'test';
        
        system.debug('Testclass starts');
        cc.startRequest();
        //cc.startRequest_Existing();
        cc.getRegionTerritory();
        
        cc.milekmconv();
        cc.getItems();
        cc.closeSrvModPopup();
        cc.getApplication();
        cc.warrStDtHidden = 'test';
        cc.MakeBISReadOnly();
        cc.bisFlag = true;
        cc.MakeWSDReadOnly();
        
        cc.searchMethod();
        cc.prodcodeErrormessage = true;
        
        
        cc.getWarrCreatedDate();
        
        cc.basicCoverageDetails=null;
        
        CG_CL_CheckWarrantyCoverage.getDependentPicklistValues(CSS_Claims__c.Territory__c);
        cc.regionSelected = 'INTERNATIONAL';
        cc.getRegionValues();
        cc.getTerritoryValues();
        test.stopTest();
    }
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method77()
    {        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.bisFlag=false;
        aa.FormattedDate=null;
        aa.ReadonlyWSD=null;
        aa.prodHours='45';
        aa.prodMileKm='35'; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=false;
        aa.applnMandatoryFlag=false;
        aa.wsdMandatoryFlag=false;
        aa.failDateMandatoryFlag=false;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;       
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        
        system.debug('PSN ID:'+psnobj.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id);      
        
        aa.mil_measure='Kilometers';        
        
        Test.setMock(HttpCalloutMock.class , new CSS_getClaimsBasicCoverageMOCK_Test());
        //aa.startRequest();
        aa.warrStartDt_Final=null;
        aa.WarrStartDt = null;
        aa.searchMethod();
        
        aa.basicCoverageDetails=null;
        
        test.stopTest();
    }
    
    public static Testmethod void updateproductappcodeMethod(){
        
        CSS_JobEventTemporary__c job = new CSS_JobEventTemporary__c();
        job.Key__c = 'MarketingApplicationCodes';
        job.Attribute1__c = 'BB';
        job.Attribute2__c = '310';
        job.Attribute5__c = 'RECREATIONAL VEHICAL';
        job.Attribute3__c = 'AUTOMOTIVE';
        insert job;
        system.debug('job'+job);
        
        Test.startTest();
        CG_CL_CheckWarrantyCoverage obj = new CG_CL_CheckWarrantyCoverage();
        obj.updateproductappcode();
        Test.stoptest();
    }
    
    public static Testmethod void TestmethodNew()
    {       
        test.startTest();
        
        
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.prodcodeErrormessage = true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.FormattedDate='Date.today()';
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=true;
        aa.applnMandatoryFlag=true;
        aa.wsdMandatoryFlag=true;
        aa.failDateMandatoryFlag=true;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        String json = '{'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   },'+
            '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
            '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
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
            '            \"CoverageType\": \"REW-Recon Engine Warranty\",'+
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
        
        
        
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id); 
        
        CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        aa.basicCoverageDetails = obj;
        aa.kil_measure = 'Kilometers';
        aa.mil_measure='Kilometers';
        aa.startRequest();
        // aa.startRequest_Existing();
        aa.milekmconv();
        test.stopTest();
    }
    
    public static Testmethod void TestmethodNew1()
    {       
        test.startTest();
        
        
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        aa.WarrStartDt=d - 7;
        aa.failureDt=d;
        aa.psn='79619554';	
        aa.warrStDtHidden=null;	   
        aa.filterApplication='Automation';
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.FormattedDate='Date.today()';
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=false;
        aa.applnMandatoryFlag=false;
        aa.wsdMandatoryFlag=false;
        aa.failDateMandatoryFlag=false;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        String json = '{'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   },'+
            '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
            '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
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
            '            \"CoverageType\": \"REW-Recon Engine Warranty\",'+
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
        
        
        
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id); 
        
        CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        aa.basicCoverageDetails = obj;
        aa.kil_measure = 'Kilometers';
        aa.mil_measure='Kilometers';
        aa.startRequest();
        //aa.startRequest_Existing();
        aa.searchMethod();
        test.stopTest();
    }
    
    public static Testmethod void TestmethodNew2()
    {       
        test.startTest();
        
        
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        aa.psn='79619554';	
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.prodcodeErrormessage =true;
        aa.ReadonlyBIS= true;
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=false;
        aa.applnMandatoryFlag=false;
        aa.wsdMandatoryFlag=false;
        aa.failDateMandatoryFlag=false;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
        jobEvent.attribute1__c ='ApplicationCodes';
        jobEvent.Key__c='56270-56270';
        jobEvent.Reason__c='{"DataArea":{"Details":[{"MarineFlag":"N","Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"130","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"130","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"200","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"210","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"220","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"300","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"400","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"410","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"420","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"500","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"600","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"605","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"610","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"620","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"625","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"645","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"650","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"655","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"665","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"700","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"710","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"720","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"800","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Standby","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"810","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Prime","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"820","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"830","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"840","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"900","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"910","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"920","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"930","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"940","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"950","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"960","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"10","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"11","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"12","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"13","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"20","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"21","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"22","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"23","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"30","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"31","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"40","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"41","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"42","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"50","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"51","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"60","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"61","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"62","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"63","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"64","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"65","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"66","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"70","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"71","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"72","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"80","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"81","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"82","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"83","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"84","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"90","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"91","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"92","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"93","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"94","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"95","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"96","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"100","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"110","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"230","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"310","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"510","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"635","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"660","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"FORD GRAY AUTO","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"140","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FORD GRAY BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"240","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"ISC-SERIES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"150","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"621","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"651","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"656","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"661","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"320","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"890","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"670","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"675","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"680","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"685","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"690","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"695","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"891","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"520","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"850","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"250","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"699","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"662","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"663","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"530","AutomotiveFlag":"N"}]},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
            insert jobEvent;
        
        CSS_JobEventTemporary__c jobEvent1 =CSS_TestData.createJobEventTempObj(false);
        jobEvent1.attribute1__c ='BB';
        jobEvent1.Attribute3__c = 'AUTOMOTIVE';
        jobEvent1.Attribute2__c = '130';
        jobEvent1.Key__c='MarketingApplicationCodes';
        jobEvent1.Reason__c='{"DataArea":{"Details":[{"MarineFlag":"N","Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"120","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"130","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"200","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"210","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"220","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"300","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"400","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"410","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"420","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"500","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"600","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"605","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"610","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"620","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"625","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"645","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"650","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"655","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"665","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"700","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"710","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"720","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"800","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Standby","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"810","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Prime","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"820","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"830","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"840","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"900","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"910","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"920","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"930","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"940","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"950","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"960","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"10","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"11","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"12","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"13","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"20","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"21","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"22","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"23","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"30","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"31","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"40","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"41","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"42","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"50","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"51","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"60","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"61","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"62","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"63","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"64","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"65","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"66","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"70","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"71","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"72","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"80","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"81","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"82","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"83","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"84","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"90","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"91","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"92","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"93","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"94","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"95","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"96","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"100","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"110","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"230","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"310","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"510","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"635","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"660","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"FORD GRAY AUTO","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"140","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FORD GRAY BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"240","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"ISC-SERIES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"150","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"621","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"651","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"656","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"661","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"320","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"890","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"670","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"675","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"680","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"685","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"690","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"695","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"891","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"520","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"850","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"250","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"699","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"662","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"663","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"530","AutomotiveFlag":"N"}]},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
            insert jobEvent1;
        
        
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        String json = '{'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   },'+
            '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
            '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
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
            '            \"CoverageType\": \"REW-Recon Engine Warranty\",'+
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
        
        String json1 = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Fault Details Data sent successfully\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}';
        
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id); 
        
        CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        CSS_WPR_SBL_ApplicationResJSON obj1 = CSS_WPR_SBL_ApplicationResJSON.parse(json1);
        aa.filterApplication = 'AUTOMOTIVE';
        aa.basicCoverageDetails = obj;
        aa.kil_measure = 'Kilometers';
        aa.mil_measure='Kilometers';
        aa.startRequest();
        //aa.startRequest_Existing();
        aa.searchMethod();
        test.stopTest();
    }
    
    public static Testmethod void TestmethodNew3()
        
    {       
        test.startTest();
        
        
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        aa.psn='79619554';	
        aa.wsdReadOnlyFromContr=true;
        aa.ExternReturnDateFlag=true;
        aa.ReadonlyBIS= true;
        aa.ReadonlyWSD=null;
        aa.prodHours=null;
        aa.prodMileKm=null; 
        aa.regionMandatoryFlag=false;
        aa.territoryMandatoryFlag=false;
        aa.psnMandatoryFlag=false;
        aa.applnMandatoryFlag=false;
        aa.wsdMandatoryFlag=false;
        aa.failDateMandatoryFlag=false;
        aa.recconFlag=true; 
        aa.reqWrcoverBoolean= true;
        aa.reqWrTerBoolean= true;
        aa.reqWrcertBoolean= true;
        aa.showExtCoverage=null;
        aa.emissionStatus=null;
        aa.productAppcode=null;
        aa.productAppdesc=null;
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
        jobEvent.attribute1__c ='ApplicationCodes';
        jobEvent.Key__c='56270-56270';
        jobEvent.Reason__c='{"DataArea":{"Details":[{"MarineFlag":"N","Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"120","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"130","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"200","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"210","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"220","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"300","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"400","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"410","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"420","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"500","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"600","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"605","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"610","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"620","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"625","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"645","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"650","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"655","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"665","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"700","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"710","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"720","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"800","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Standby","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"810","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Prime","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"820","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"830","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"840","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"900","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"910","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"920","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"930","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"940","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"950","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"960","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"10","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"11","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"12","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"13","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"20","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"21","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"22","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"23","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"30","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"31","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"40","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"41","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"42","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"50","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"51","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"60","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"61","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"62","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"63","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"64","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"65","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"66","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"70","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"71","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"72","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"80","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"81","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"82","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"83","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"84","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"90","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"91","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"92","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"93","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"94","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"95","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"96","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"100","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"110","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"230","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"310","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"510","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"635","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"660","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"FORD GRAY AUTO","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"140","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FORD GRAY BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"240","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"ISC-SERIES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"150","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"621","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"651","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"656","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"661","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"320","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"890","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"670","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"675","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"680","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"685","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"690","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"695","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"891","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"520","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"850","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"250","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"699","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"662","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"663","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"530","AutomotiveFlag":"N"}]},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
            insert jobEvent;
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        String json = '{'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   },'+
            '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
            '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
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
            '            \"CoverageType\": \"REW-Recon Engine Warranty\",'+
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
        
        String json1 = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Fault Details Data sent successfully\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}';
        
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',claimsobj.id); 
        
        CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        CSS_WPR_SBL_ApplicationResJSON obj1 = CSS_WPR_SBL_ApplicationResJSON.parse(json1);
        aa.filterApplication = 'AUTOMOTIVE';
        aa.basicCoverageDetails = obj;
        aa.kil_measure = 'Kilometers';
        aa.mil_measure='Kilometers';
        aa.searchMethod();
        test.stopTest();
    }
    public static Testmethod void catchblockMethod(){
        CG_CL_CheckWarrantyCoverage aa = new CG_CL_CheckWarrantyCoverage();
        aa.getFormattedDate(Date.today());
    } 
    
    
    public static Testmethod void CG_CL_CheckWarrantyCoverage_Method51()
    {
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        CG_CL_CheckWarrantyCoverage dd = new CG_CL_CheckWarrantyCoverage();
        date d = Date.today();
        dd.WarrStartDt=d-7;
        dd.failureDt=d;
        dd.psn='57788989';	
        dd.warrStDtHidden=null;	   
        dd.filterApplication='Automation';
        dd.wsdReadOnlyFromContr=true;
        dd.ExternReturnDateFlag=true;
        //dd.warrStartDt_Final=null;
        dd.ReadonlyBIS= true;
        dd.FormattedDate=null;
        dd.ReadonlyWSD=null;
        dd.prodHours=null;
        dd.prodMileKm=null; 
        dd.regionMandatoryFlag=false;
        dd.territoryMandatoryFlag=false;
        dd.psnMandatoryFlag=false;
        dd.applnMandatoryFlag=false;
        dd.wsdMandatoryFlag=false;
        dd.failDateMandatoryFlag=false;
        dd.recconFlag=true; 
        dd.reqWrcoverBoolean= true;
        dd.reqWrTerBoolean= true;
        
        dd.reqWrcertBoolean= true;
        dd.showExtCoverage=null;
        dd.emissionStatus=null;
        dd.productAppcode=null;
        dd.productAppdesc=null;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.CoverageResponse__c='{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "7/15/2017","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-077","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "ACCESSORIES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "3","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"},{"CoverageHours": "9000","CoverageMaxMonths": "24","CoverageComponentTypeCode": "STRT/ALT","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}},{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate": "7/15/2020","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "5000","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert testclaimsRec;
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Processed_Data__c='test';
        ie1.Response_Body__c='Access Denied';
        ie1.Service_Name__c='GetEngineDataService';
        ie1.Source__c='SIEBEL';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c= testclaimsRec.id;
        psn1.Warranty_Start_Date__c=d-7;
        psn1.Before_In_Service__c=false;
        psn1.Failure_Date__c=system.today();
        psn1.Unit_Type__c='';
        psn1.PSN__c = '1079446';
        //  psn.Justification__c='Field Action';
        insert psn1;
        
        
        system.debug('PSN ID:'+psn1.id);
        PageReference pg = Page.CG_ClaimsWarranty;
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);      
        
        dd.mil_measure='Miles'; 
        string filterLabel='130-Automotive';
        // cc.psnRec=psnobj;
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        dd.getApplication();
        dd.searchMethod();
        dd.milekmconv();
        //dd.updateproductappcode();
        
        //cc.getWarrantyDate(dInputDate);
        dd.getWarrCreatedDate(); 
        //   CSS_getBasicCoverageResponseJ2A nw = new CSS_getBasicCoverageResponseJ2A();
        dd.basicCoverageDetails=null;
        dd.applicationCode = '220';
        //dd.milekmconv(); 
        
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        //CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        //CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        
        //Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        //Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        //Req.EtoConversionDate='2013-10-14T00:00:00.000-04:00';
        
        test.startTest();
        CG_CL_CheckWarrantyCoverage POPUP = new CG_CL_CheckWarrantyCoverage();
        //POPUP.getRegionValues();
        //POPUP.startRequest();
        test.stoptest();
    }
    
    public static testmethod void Method1(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='56335346';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        Test.startTest();
        CG_CL_CheckWarrantyCoverage CL = new CG_CL_CheckWarrantyCoverage();
        CL.psn ='11111111';
        CL.startRequest();
        Test.stopTest();
        
        
        
    }
    
    public static testmethod void Method2(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='22222222';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        List<Asset> lstAsset = new List<Asset>();
        Asset A = new Asset();
        A.name = 'TestAsset';
        A.AccountId=acc.id;
        A.Type__c='Engines';
        A.SerialNumber = '22222222';
        LstAsset.add(A);
        insert LstAsset;
        
        Test.setMock(HttpCalloutMock.class , new CSS_getEngineDataResponseJ2A_Mockup_Test());
        
        Test.startTest();
        CG_CL_CheckWarrantyCoverage CL = new CG_CL_CheckWarrantyCoverage();
        CL.psn ='22222222';
        CL.startRequest();
        Test.stopTest();
        
    }
    
    public static testmethod void Method3(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.Territory__c = 'US';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';
        acc.Type ='Customer';
        insert acc;
        
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj;
        
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
        psnobj.PSN__c='33333333';
        
        insert psnobj;
        system.debug('PSN ID:'+psnobj.id);
        
        List<Asset> lstAsset = new List<Asset>();
        Asset A = new Asset();
        A.name = 'TestAsset';
        A.Type__c='Engines';
        A.AccountId=acc.id;
        A.SerialNumber = '33333333';
        LstAsset.add(A);
        insert LstAsset;
        
        
        Test.startTest();
        CG_CL_CheckWarrantyCoverage CL = new CG_CL_CheckWarrantyCoverage();
        CL.psn ='33333333';
        CL.startRequest();
        Test.stopTest();
        
        
        
    }
    
    
    
}