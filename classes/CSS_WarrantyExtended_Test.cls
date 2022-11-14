@IsTest
public class CSS_WarrantyExtended_Test {
    Public static testMethod void testJobOrderDatanew13111 () {
        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup1_Test());
        date d = Date.today();

        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 19.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d.addYears(-17);
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        servjob2.CSS_Hours__c=0;
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
        insert servjob2;

        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        objCSSExtWarranty.EmmisionWarrantyDedutibles = 'objCSSExtWarranty';
        objCSSExtWarranty.ExtendedWarrantyDedutibles = 'ExtendedWarrantyDedutibles';
        objCSSExtWarranty.ReconWarrantyDedutibles = 'ReconWarrantyDedutibles';
        objCSSExtWarranty.NewEngWarrantyDedutibles = 'NewEngWarrantyDedutibles';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }
    Public static testMethod void testJobOrderDatanew1311 () {
        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup1_Test());
        date d = Date.today();

        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 19.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d.addYears(-17);
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        servjob2.CSS_Hours__c=91;
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
        insert servjob2;

        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        //objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }
    Public static testMethod void testJobOrderDatanew131 () {
        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup1_Test());
        date d = Date.today();

        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 19.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        servjob2.CSS_Hours__c=91;
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2030","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2010","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"100","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"1"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"12/9/2000","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-507-033","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"1","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
        insert servjob2;

        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }
    Public static testMethod void testJobOrderDatanew1 () {
        Test.StartTest();


        date d = Date.today();

        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 9.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2010","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert servjob2;

        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }
    Public static testMethod void testJobOrderDatanew11 () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();

        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = '210';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Before_In_Service__c = true;
        servjob.Mileage_Measure__c = 'Miles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 9.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Before_In_Service__c = true;
        servjob2.Mileage_Measure__c = 'Moles';
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2010","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert servjob2;
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();

        //date d = Date.today();
        servjob1.Region__c = 'North America';
        servjob1.Territory__c = 'United states';
        servjob1.Warranty_Start_Date__c = d + 7;
        servjob1.Application__c = '210';
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.Before_In_Service__c = true;
        servjob1.ESN__c = '79464646';
        servjob1.Mileage_Measure__c = 'Miles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;
        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }
    Public static testMethod void testJobOrderDatanew () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();

        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = '210';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Miles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        servjob2.Mileage__c = 9.9;
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2010","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert servjob2;
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();

        //date d = Date.today();
        servjob1.Region__c = 'North America';
        servjob1.Territory__c = 'United states';
        servjob1.Warranty_Start_Date__c = d + 7;
        servjob1.Application__c = '210';
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.ESN__c = '79464646';
        servjob1.Mileage_Measure__c = 'Miles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;
        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.SelectedAppCode='test';
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }

    Public static testMethod void testJobOrderData () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();

        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = '210';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Miles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2010","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        //date d = Date.today();
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Moles';
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2010","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "0"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert servjob2;
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();

        //date d = Date.today();
        servjob1.Region__c = 'North America';
        servjob1.Territory__c = 'United states';
        servjob1.Warranty_Start_Date__c = d + 7;
        servjob1.Application__c = '210';
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.ESN__c = '79464646';
        servjob1.Mileage_Measure__c = 'Miles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;
        apexpages.currentpage().getparameters().put('id' , servjob.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.coveragesearch();


        Test.StopTest();

    }

    Public static testMethod void testJobOrderData2 () {
        Test.StartTest();
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        date d = Date.today();
        servjob2.Region__c = 'North America';
        servjob2.Territory__c = 'United states';
        servjob2.Warranty_Start_Date__c = d + 7;
        servjob2.Application__c = '130';
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = '79464646';
        servjob2.Mileage_Measure__c = 'Miles';
        //servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob2.CoverageResponse__c  = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "9999999","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}';
        insert servjob2;
        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty2 =  new CSS_WarrantyExtended();
        objCSSExtWarranty2.applicationCode = '130';
        //objCSSExtWarranty2.mil_measure = 'miles';
        objCSSExtWarranty2.mil_measure = 'Kilometers';
        objCSSExtWarranty2.defValue = 'Kilometers';
        objCSSExtWarranty2.reqWrRegBoolean = true;
        objCSSExtWarranty2.reqWrTerBoolean = true;
        objCSSExtWarranty2.reqWrWarBoolean = true;
        objCSSExtWarranty2.reqWrEsnBoolean = true;
        objCSSExtWarranty2.reqWrcoverBoolean = true;
        objCSSExtWarranty2.reqWrcertBoolean = true;
        objCSSExtWarranty2.pagName = 'REPAIR';
        objCSSExtWarranty2.SOQLServicejob();
        objCSSExtWarranty2.loadBasicData();
        objCSSExtWarranty2.getItems();
        objCSSExtWarranty2.updatetext();
        objCSSExtWarranty2.milekmconv();
        objCSSExtWarranty2.coveragesearch();

        Test.StopTest();

    }

    static testmethod void testCoverage(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());

        CSS_WarrantyExtended objCSSExtWarranty1 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();
        servjob1.Region__c = null;
        servjob1.Territory__c = '';
        servjob1.Failure_Date__c = d1+7;
        servjob1.Warranty_Start_Date__c = d1-7; 
        servjob1.Application__c = null;
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.ESN__c = '79464646';
        servjob1.Mileage_Measure__c = 'Moles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty1.mil_measure = 'Kilometers';
        objCSSExtWarranty1.defValue = 'Kilometers';
        objCSSExtWarranty1.servicejob = servjob1;
        objCSSExtWarranty1.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty1.coveragesearch();

        objCSSExtWarranty1.gettoken();
        objCSSExtWarranty1.getWarrCreatedDate();
        objCSSExtWarranty1.warrentyStartD = DateTime.now();
        objCSSExtWarranty1.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty1.getWarrantyDate(dInputDate);
        objCSSExtWarranty1.myBase64String = '6';
        objCSSExtWarranty1.mileKmMeasure = '()';
        objCSSExtWarranty1.coverageMaxMonth = 6;
        Test.stopTest();

    }

    static testmethod void testCoverage1(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());

        CSS_WarrantyExtended objCSSExtWarranty1 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();
        servjob2.Region__c = null;
        servjob2.Territory__c = null;
        servjob2.Failure_Date__c = d1+7;
        servjob2.Warranty_Start_Date__c = d1-7; 
        servjob2.Application__c = null;
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = null;
        servjob2.Mileage_Measure__c = 'Moles';
        servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob2;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty1.mil_measure = 'Kilometers';
        objCSSExtWarranty1.defValue = 'Kilometers';
        objCSSExtWarranty1.servicejob = servjob2;
        objCSSExtWarranty1.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty1.coveragesearch();

        objCSSExtWarranty1.gettoken();
        objCSSExtWarranty1.getWarrCreatedDate();
        objCSSExtWarranty1.warrentyStartD = DateTime.now();
        objCSSExtWarranty1.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty1.getWarrantyDate(dInputDate);
        objCSSExtWarranty1.myBase64String = '6';
        objCSSExtWarranty1.mileKmMeasure = '()';
        objCSSExtWarranty1.coverageMaxMonth = 6;
        Test.stopTest();

    }

    static testmethod void testCoverage3(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());

        CSS_WarrantyExtended objCSSExtWarranty3 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob3= new CSS_Job_Order__c();
        servjob3.Region__c ='North America';
        servjob3.Territory__c = null;
        servjob3.Failure_Date__c = d1+7;
        servjob3.Warranty_Start_Date__c = d1-7; 
        servjob3.Application__c = null;
        servjob3.EditCoverage__c = 'abcdefg';
        servjob3.ESN__c = '79464646';
        servjob3.Mileage_Measure__c = 'Moles';
        servjob3.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob3;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;

        objCSSExtWarranty3.servicejob = servjob3;
        objCSSExtWarranty3.SelectedAppCode = 'Automotive';
        objCSSExtWarranty3.mil_measure = 'Kilometers';
        objCSSExtWarranty3.defValue = 'Kilometers';
        Test.startTest();
        objCSSExtWarranty3.coveragesearch();

        objCSSExtWarranty3.gettoken();
        objCSSExtWarranty3.getWarrCreatedDate();
        objCSSExtWarranty3.warrentyStartD = DateTime.now();
        objCSSExtWarranty3.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty3.getWarrantyDate(dInputDate);
        objCSSExtWarranty3.myBase64String = '6';
        objCSSExtWarranty3.mileKmMeasure = '()';
        objCSSExtWarranty3.coverageMaxMonth = 6;
        Test.stopTest();

    }



    static testmethod void testCoverage4(){

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());

        CSS_WarrantyExtended objCSSExtWarranty4 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob4= new CSS_Job_Order__c();
        servjob4.Region__c ='North America';
        servjob4.Territory__c = 'United states';
        servjob4.Failure_Date__c = d1+7;
        servjob4.Warranty_Start_Date__c = d1-7; 
        servjob4.Application__c = null;
        servjob4.EditCoverage__c = 'abcdefg';
        servjob4.ESN__c = '79464646';
        servjob4.Mileage_Measure__c = 'Miles';
        servjob4.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"999999"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob4;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty4.mil_measure = 'Miles';
        objCSSExtWarranty4.defValue = 'Kilometers';
        objCSSExtWarranty4.servicejob = servjob4;
        objCSSExtWarranty4.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty4.coveragesearch();

        objCSSExtWarranty4.gettoken();
        objCSSExtWarranty4.getWarrCreatedDate();
        objCSSExtWarranty4.warrentyStartD = DateTime.now();
        objCSSExtWarranty4.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty4.getWarrantyDate(dInputDate);
        objCSSExtWarranty4.myBase64String = '6';
        objCSSExtWarranty4.mileKmMeasure = '()';
        objCSSExtWarranty4.coverageMaxMonth = 6;
        Test.stopTest();

    }

    static testmethod void testCoverage5(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup1_Test());

        CSS_WarrantyExtended objCSSExtWarranty5 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob5= new CSS_Job_Order__c();
        servjob5.Region__c ='North America';
        servjob5.Territory__c = 'United states';
        servjob5.Failure_Date__c = d1+7;
        servjob5.Warranty_Start_Date__c = d1-7; 
        servjob5.Application__c = null;
        servjob5.EditCoverage__c = 'abcdefg';
        servjob5.Mileage__c = 10;
        servjob5.ESN__c = '79464646';
        servjob5.Mileage_Measure__c = 'Miles';
        servjob5.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"9999999",CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"},{"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  

        insert servjob5;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty5.mil_measure = 'Kilometers';
        objCSSExtWarranty5.defValue = 'Kilometers';
        objCSSExtWarranty5.servicejob = servjob5;
        objCSSExtWarranty5.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty5.coveragesearch();

        objCSSExtWarranty5.gettoken();
        objCSSExtWarranty5.getWarrCreatedDate();
        objCSSExtWarranty5.warrentyStartD = DateTime.now();
        objCSSExtWarranty5.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty5.getWarrantyDate(dInputDate);
        objCSSExtWarranty5.myBase64String = '6';
        objCSSExtWarranty5.mileKmMeasure = '()';
        objCSSExtWarranty5.coverageMaxMonth = 6;
        Test.stopTest();

    }

    public static Testmethod void CG_CL_ClaimsWarrantyComp_sblwsMethod11()
    {
        Test.StartTest();
        CSS_Job_Order__c servjob2= new CSS_Job_Order__c();

        date d = Date.today();
        servjob2.Region__c = null;
        servjob2.Territory__c = null;
        servjob2.Warranty_Start_Date__c = null;
        servjob2.Application__c = null;
        servjob2.EditCoverage__c = 'abcdefg';
        servjob2.ESN__c = null;
        servjob2.Mileage_Measure__c = 'Moles';
        servjob2.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob2;


        apexpages.currentpage().getparameters().put('id' , servjob2.id);

        CSS_WarrantyExtended objCSSExtWarranty1 =  new CSS_WarrantyExtended();
        objCSSExtWarranty1.applicationCode = '130';
        //objCSSExtWarranty1.mil_measure = 'miles';
        objCSSExtWarranty1.mil_measure = 'Kilometers';
        objCSSExtWarranty1.defValue = 'Kilometers';
        objCSSExtWarranty1.reqWrRegBoolean = true;
        objCSSExtWarranty1.reqWrTerBoolean = true;
        objCSSExtWarranty1.reqWrWarBoolean = true;
        objCSSExtWarranty1.reqWrEsnBoolean = true;
        objCSSExtWarranty1.reqWrcoverBoolean = true;
        objCSSExtWarranty1.reqWrcertBoolean = true;
        objCSSExtWarranty1.pagName = 'REPAIR';
        objCSSExtWarranty1.SOQLServicejob();
        objCSSExtWarranty1.loadBasicData();
        objCSSExtWarranty1.getItems();
        objCSSExtWarranty1.updatetext();
        objCSSExtWarranty1.milekmconv();
        objCSSExtWarranty1.coveragesearch();
        objCSSExtWarranty1.SelectedAppCode = '';
        objCSSExtWarranty1.coveragesearch();
        Test.StopTest();

    }  

    public static Testmethod void CG_CL_ClaimsWarrantyComp_sblwsMethod111()
    {
        Test.StartTest();
        CSS_Job_Order__c servjob21= new CSS_Job_Order__c();

        date d = Date.today();
        servjob21.Region__c = null;
        servjob21.Territory__c = null;
        servjob21.Warranty_Start_Date__c = Date.today();
        servjob21.Before_In_Service__c = true;
        servjob21.Application__c = null;
        servjob21.EditCoverage__c = 'abcdefg';
        servjob21.ESN__c = null;
        servjob21.Mileage__c = 10;
        servjob21.Mileage_Measure__c = 'Miles';
        servjob21.CoverageResponse__c  ='';
        //  servjob21.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob21;

        apexpages.currentpage().getparameters().put('id' , servjob21.id);

        CSS_WarrantyExtended objCSSExtWarranty1 =  new CSS_WarrantyExtended();
        objCSSExtWarranty1.mil_measure = 'Kilometers';
        objCSSExtWarranty1.defValue = 'Kilometers';
        objCSSExtWarranty1.applicationCode = '130';
        //objCSSExtWarranty1.mil_measure = 'miles'; 
        objCSSExtWarranty1.reqWrRegBoolean = false;
        objCSSExtWarranty1.reqWrTerBoolean = false;
        objCSSExtWarranty1.reqWrWarBoolean = false;
        objCSSExtWarranty1.reqWrEsnBoolean = false;
        objCSSExtWarranty1.reqWrcoverBoolean = false;
        objCSSExtWarranty1.reqWrcertBoolean = false;
        objCSSExtWarranty1.pagName = 'REPAIR';
        //  objCSSExtWarranty1.SOQLServicejob();
        // objCSSExtWarranty1.loadBasicData();
        // objCSSExtWarranty1.getItems();
        // objCSSExtWarranty1.updatetext();
        // objCSSExtWarranty1.milekmconv();
        // objCSSExtWarranty1.coveragesearch();
        objCSSExtWarranty1.SelectedAppCode = '';
        objCSSExtWarranty1.coveragesearch();
        Test.StopTest();

    }  
    public static Testmethod void CG_CL_ClaimsWarrantyComp_sblwsMethod1112()
    {
        Test.StartTest();
        CSS_Job_Order__c servjob21= new CSS_Job_Order__c();

        date d = Date.today();
        servjob21.Region__c = null;
        servjob21.Territory__c = null;
        servjob21.Warranty_Start_Date__c = Date.today();
        servjob21.Before_In_Service__c = true;
        servjob21.Application__c = null;
        servjob21.EditCoverage__c = 'abcdefg';
        servjob21.ESN__c = null;
        servjob21.Mileage__c = 10;
        servjob21.Mileage_Measure__c = null;
        servjob21.CoverageResponse__c  ='';
        //  servjob21.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob21;

        apexpages.currentpage().getparameters().put('id' , servjob21.id);

        CSS_WarrantyExtended objCSSExtWarranty1 =  new CSS_WarrantyExtended();
        objCSSExtWarranty1.mil_measure = 'Kilometers';
        objCSSExtWarranty1.defValue = 'Kilometers';
        objCSSExtWarranty1.applicationCode = '130';
        //objCSSExtWarranty1.mil_measure = 'miles'; 
        objCSSExtWarranty1.reqWrRegBoolean = false;
        objCSSExtWarranty1.reqWrTerBoolean = false;
        objCSSExtWarranty1.reqWrWarBoolean = false;
        objCSSExtWarranty1.reqWrEsnBoolean = false;
        objCSSExtWarranty1.reqWrcoverBoolean = false;
        objCSSExtWarranty1.reqWrcertBoolean = false;
        objCSSExtWarranty1.pagName = 'REPAIR';
        //  objCSSExtWarranty1.SOQLServicejob();
        // objCSSExtWarranty1.loadBasicData();
        // objCSSExtWarranty1.getItems();
        // objCSSExtWarranty1.updatetext();
        // objCSSExtWarranty1.milekmconv();
        // objCSSExtWarranty1.coveragesearch();
        objCSSExtWarranty1.SelectedAppCode = '';
        objCSSExtWarranty1.coveragesearch();
        Test.StopTest();

    }  
    Public static testMethod void testJobOrderData123() {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();

        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = '210';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Miles';
        //servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"EXTENDED","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"EXTENDED","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"9999999","CoverageDefenitionType":"BASE","CoverageMiles":"0"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;


        apexpages.currentpage().getparameters().put('id' , servjob.id);

        CSS_WarrantyExtended objCSSExtWarranty =  new CSS_WarrantyExtended();
        objCSSExtWarranty.applicationCode = '130';
        //objCSSExtWarranty.mil_measure = 'miles';
        objCSSExtWarranty.mil_measure = 'Kilometers';
        objCSSExtWarranty.defValue = 'Kilometers';
        objCSSExtWarranty.reqWrRegBoolean = true;
        objCSSExtWarranty.reqWrTerBoolean = true;
        objCSSExtWarranty.reqWrWarBoolean = true;
        objCSSExtWarranty.reqWrEsnBoolean = true;
        objCSSExtWarranty.reqWrcoverBoolean = true;
        objCSSExtWarranty.reqWrcertBoolean = true;
        objCSSExtWarranty.pagName = 'REPAIR';
        objCSSExtWarranty.SOQLServicejob();
        objCSSExtWarranty.loadBasicData();
        objCSSExtWarranty.getItems();
        objCSSExtWarranty.updatetext();
        objCSSExtWarranty.milekmconv();
        objCSSExtWarranty.coveragesearch();

        Test.StopTest();

    }
    static testmethod void testCoverage51(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup1_Test());

        CSS_WarrantyExtended objCSSExtWarranty5 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob5= new CSS_Job_Order__c();
        servjob5.Region__c ='';
        servjob5.Territory__c = '';
        servjob5.Failure_Date__c = d1+7;
        servjob5.Warranty_Start_Date__c = null;
        servjob5.Before_In_Service__c = false;
        servjob5.Application__c = null;
        servjob5.EditCoverage__c = 'abcdefg';
        servjob5.Mileage__c = 10;
        servjob5.ESN__c = '';
        servjob5.Mileage_Measure__c = null;
        servjob5.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"},{"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  

        insert servjob5;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty5.mil_measure = 'Kilometers';
        objCSSExtWarranty5.defValue = 'Kilometers';
        objCSSExtWarranty5.servicejob = servjob5;
        objCSSExtWarranty5.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty5.coveragesearch();

        objCSSExtWarranty5.gettoken();
        objCSSExtWarranty5.getWarrCreatedDate();
        objCSSExtWarranty5.warrentyStartD = DateTime.now();
        objCSSExtWarranty5.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty5.getWarrantyDate(dInputDate);
        objCSSExtWarranty5.myBase64String = '6';
        objCSSExtWarranty5.mileKmMeasure = '()';
        objCSSExtWarranty5.coverageMaxMonth = 6;
        Test.stopTest();

    }
    static testmethod void testCoverage2(){

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup11_Test());

        CSS_WarrantyExtended objCSSExtWarranty4 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob4= new CSS_Job_Order__c();
        servjob4.Region__c ='North America';
        servjob4.Territory__c = 'United states';
        servjob4.Failure_Date__c = d1+7;
        servjob4.Warranty_Start_Date__c = d1-7; 
        servjob4.Application__c = null;
        servjob4.EditCoverage__c = 'abcdefg';
        servjob4.ESN__c = '79464646';
        servjob4.Mileage_Measure__c = 'Miles';
        servjob4.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"999999"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob4;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty4.mil_measure = 'Miles';
        //  objCSSExtWarranty4.defValue = 'Kilometers';
        objCSSExtWarranty4.defValue = 'Miles';
        objCSSExtWarranty4.servicejob = servjob4;
        objCSSExtWarranty4.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty4.coveragesearch();

        objCSSExtWarranty4.gettoken();
        objCSSExtWarranty4.getWarrCreatedDate();
        objCSSExtWarranty4.warrentyStartD = DateTime.now();
        objCSSExtWarranty4.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty4.getWarrantyDate(dInputDate);
        objCSSExtWarranty4.myBase64String = '6';
        objCSSExtWarranty4.mileKmMeasure = '()';
        objCSSExtWarranty4.coverageMaxMonth = 6;
        Test.stopTest();

    }

    //BASE CoverageDedutibles 
    static testmethod void testCoverageBaseDeductibles(){

        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup12_Test()); //new Mockup with full response

        CSS_WarrantyExtended objCSSExtWarranty4 =  new CSS_WarrantyExtended();

        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob4= new CSS_Job_Order__c();
        servjob4.Region__c ='North America';
        servjob4.Territory__c = 'United states';
        servjob4.Failure_Date__c = d1+7;
        servjob4.Warranty_Start_Date__c = d1-7; 
        servjob4.Application__c = null;
        servjob4.EditCoverage__c = 'abcdefg';
        servjob4.ESN__c = '79464646';
        servjob4.Mileage_Measure__c = 'Miles';
        //servjob4.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"999999"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        //servjob4.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"4/19/2022","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-012","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"4/19/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
        
        //ExtendedCoverageDedutibles without ListOfCoverageDedutibles
        //servjob4.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
        
        //All values/details with deductibles
        //servjob4.CoverageResponse__c  = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
        servjob4.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
        insert servjob4;

        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
        accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        objCSSExtWarranty4.mil_measure = 'Miles';
        //  objCSSExtWarranty4.defValue = 'Kilometers';
        objCSSExtWarranty4.defValue = 'Miles';
        objCSSExtWarranty4.servicejob = servjob4;
        objCSSExtWarranty4.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSExtWarranty4.coveragesearch();

        objCSSExtWarranty4.gettoken();
        objCSSExtWarranty4.getWarrCreatedDate();
        objCSSExtWarranty4.warrentyStartD = DateTime.now();
        objCSSExtWarranty4.getWarrCreatedDate();
        DateTime dInputDate = null;
        objCSSExtWarranty4.getWarrantyDate(dInputDate);
        objCSSExtWarranty4.myBase64String = '6';
        objCSSExtWarranty4.mileKmMeasure = '()';
        objCSSExtWarranty4.coverageMaxMonth = 6;
        Test.stopTest();

    }



}