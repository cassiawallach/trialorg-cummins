@IsTest
public class CSS_WarrantyTest {
    
    
    Public static testMethod void testJobOrderData () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();
        
        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = 'Automotive';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Moles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        
        CSS_Job_Order__c servjob12= new CSS_Job_Order__c();
          servjob12.Application__c = 'Automotive';
          servjob12.Mileage_Measure__c = 'Moles';
          servjob12.Warranty_Start_Date__c = null;
          servjob12.ESN__c = null;
          servjob12.Region__c = null;
          servjob12.Territory__c = null;
           insert servjob12;
        
        //CSS_Job_Order__c servjob1= new CSS_Job_Order__c();
        
        
        apexpages.currentpage().getparameters().put('id' , servjob.id);
        
        css_warranty objCSSWarranty =  new css_warranty();
        objCSSWarranty.applicationCode = '130';
        objCSSWarranty.mil_measure = 'miles'; 
        objCSSWarranty.reqWrRegBoolean = true;
        objCSSWarranty.reqWrTerBoolean = true;
        objCSSWarranty.reqWrWarBoolean = true;
        objCSSWarranty.reqWrEsnBoolean = true;
        objCSSWarranty.reqWrcoverBoolean = true;
        objCSSWarranty.reqWrcertBoolean = true;
        objCSSWarranty.pagName = 'REPAIR';
        objCSSWarranty.SOQLServicejob();
        objCSSWarranty.loadBasicData();
        objCSSWarranty.getItems();
        objCSSWarranty.updatetext();
        objCSSWarranty.milekmconv();
        objCSSWarranty.coveragesearch();
        
        Test.StopTest();

    }
    
    Public static testMethod void testJobOrderData2 () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();
        
        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = 'Automotive';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Moles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        
        
        apexpages.currentpage().getparameters().put('id' , servjob.id);
        
        css_warranty objCSSWarranty =  new css_warranty();
        objCSSWarranty.applicationCode = '130';
        objCSSWarranty.mil_measure = 'Kilometers'; 
        objCSSWarranty.reqWrRegBoolean = true;
        objCSSWarranty.reqWrTerBoolean = true;
        objCSSWarranty.reqWrWarBoolean = true;
        objCSSWarranty.reqWrEsnBoolean = true;
        objCSSWarranty.reqWrcoverBoolean = true;
        objCSSWarranty.reqWrcertBoolean = true;
        objCSSWarranty.pagName = 'REPAIR';
        objCSSWarranty.SOQLServicejob();
        objCSSWarranty.loadBasicData();
        objCSSWarranty.getItems();
        objCSSWarranty.updatetext();
        objCSSWarranty.milekmconv();
        objCSSWarranty.coveragesearch();
        
        Test.StopTest();

    }
    
    Public static testMethod void testJobOrderData3 () {
        Test.StartTest();
        CSS_Job_Order__c servjob= new CSS_Job_Order__c();
        
        date d = Date.today();
        servjob.Region__c = 'North America';
        servjob.Territory__c = 'United states';
        servjob.Warranty_Start_Date__c = d + 7;
        servjob.Application__c = 'Automotive';
        servjob.EditCoverage__c = 'abcdefg';
        servjob.ESN__c = '79464646';
        servjob.Mileage_Measure__c = 'Miles';
        servjob.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob;
        
        
        apexpages.currentpage().getparameters().put('id' , servjob.id);
        
        css_warranty objCSSWarranty =  new css_warranty();
        objCSSWarranty.applicationCode = '130';
        objCSSWarranty.mil_measure = 'Kilometers'; 
        objCSSWarranty.reqWrRegBoolean = true;
        objCSSWarranty.reqWrTerBoolean = true;
        objCSSWarranty.reqWrWarBoolean = true;
        objCSSWarranty.reqWrEsnBoolean = true;
        objCSSWarranty.reqWrcoverBoolean = true;
        objCSSWarranty.reqWrcertBoolean = true;
        objCSSWarranty.pagName = 'REPAIR';
        objCSSWarranty.SOQLServicejob();
        objCSSWarranty.loadBasicData();
        objCSSWarranty.getItems();
        objCSSWarranty.updatetext();
        objCSSWarranty.milekmconv();
        objCSSWarranty.coveragesearch();
        
        Test.StopTest();

    }
    
    static testmethod void testCoverage(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        
        css_warranty objCSSWarranty1 =  new css_warranty();
        
        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();
        servjob1.Region__c = 'North America';
        servjob1.Territory__c = 'United states';
        servjob1.Warranty_Start_Date__c = d1 + 7; 
        servjob1.Application__c = 'Automotive';
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.ESN__c = '79464646';
        servjob1.Mileage__c = 1;
        servjob1.Mileage_Measure__c = 'Moles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;
        
        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
       	accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        
        objCSSWarranty1.servicejob = servjob1;
        objCSSWarranty1.SelectedAppCode = 'Automotive';
        Test.startTest();
        objCSSWarranty1.coveragesearch();
        objCSSWarranty1.gettoken();
        objCSSWarranty1.getWarrCreatedDate();
        objCSSWarranty1.clearWarantyFields();
        objCSSWarranty1.warrentyStartD = DateTime.now();
        objCSSWarranty1.coverageMaxMonth = 6;
        objCSSWarranty1.getWarrCreatedDate();
        Test.stopTest();
        
    }
    
    static testmethod void testCoverage1(){
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        
        css_warranty objCSSWarranty1 =  new css_warranty();
        
        CSS_List_Of_Values__c CusSettRec = new CSS_List_Of_Values__c();
        CusSettRec.Name = 'Test'+math.random();
        CusSettRec.Type__c = 'Application Code';
        CusSettRec.Code__c = 'AU';
        CusSettRec.Picklist_Values_1__c = 'Automotive';
        insert(CusSettRec);

        date d1 = Date.today();
        CSS_Job_Order__c servjob1= new CSS_Job_Order__c();
        servjob1.Region__c = 'North America';
        servjob1.Territory__c = 'United states';
        servjob1.Warranty_Start_Date__c = d1 + 7; 
        servjob1.Application__c = 'Automotive';
        servjob1.EditCoverage__c = 'abcdefg';
        servjob1.ESN__c = '79464646';
        servjob1.Mileage__c = 1;
        servjob1.Mileage_Measure__c = 'Miles';
        servjob1.CoverageResponse__c  = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';  
        insert servjob1;
        
        CSS_accountLanguage__c accountlang = new CSS_accountLanguage__c();
       	accountlang.Name = 'en_US';
        accountlang.CSS_QsolLanguage__c = 'en';
        insert accountlang;
        
        objCSSWarranty1.servicejob = servjob1;
        objCSSWarranty1.SelectedAppCode = 'Automotive';
        objCSSWarranty1.mil_measure = 'Kilometers'; 
        Test.startTest();
        objCSSWarranty1.coveragesearch();
        objCSSWarranty1.gettoken();
        objCSSWarranty1.getWarrCreatedDate();
        objCSSWarranty1.clearWarantyFields();
        objCSSWarranty1.warrentyStartD = DateTime.now();
        objCSSWarranty1.coverageMaxMonth = 6;
        objCSSWarranty1.getWarrCreatedDate();
        Test.stopTest();
        
    }

}