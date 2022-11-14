/*
* Test Class for Apex Controller - FSL_CL_CheckWarrantyCoverage 
* Author - Piyush Rani   
*/
@isTest
public class FSL_CL_CheckWarrantyCoverage_Test {
    
    public static Testmethod void FSL_CL_CheckWarrantyCoverage_Method()
    {
        // test.startTest();//Test Jenkins 
        // FSL_CL_CheckWarrantyCoverage aa = new FSL_CL_CheckWarrantyCoverage();
        
        date d = Date.today();
        FSL_CL_CheckWarrantyCoverage.WarrStartDt=d - 7;
        FSL_CL_CheckWarrantyCoverage.donotskippflag = true;
        FSL_CL_CheckWarrantyCoverage.productAppdesc = 'test';
        FSL_CL_CheckWarrantyCoverage.productAppcode = '1234';
        //FSL_CL_CheckWarrantyCoverage.mapDescriptionToCode='1234';
        FSL_CL_CheckWarrantyCoverage.filterApplication ='Automation';
        FSL_CL_CheckWarrantyCoverage.recconFlag =true; 
        FSL_CL_CheckWarrantyCoverage.displaySrvModPopup=true;
        FSL_CL_CheckWarrantyCoverage.WarrStartDt=Date.today();
        FSL_CL_CheckWarrantyCoverage.wsdReadOnlyFromContr=true;
        FSL_CL_CheckWarrantyCoverage.FormattedDate='Date.today()';
        FSL_CL_CheckWarrantyCoverage.bisFlag=true;
        FSL_CL_CheckWarrantyCoverage.ExternReturnDateFlag=true;
        FSL_CL_CheckWarrantyCoverage.ReadonlyBIS=true; 
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270-56270';         
        acc.Type ='Customer';
        insert acc;
        
        CSS_Claims__c claimsobj = new CSS_Claims__c();
        claimsobj.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj; 
        
        CSS_Claims__c claimsobj2 = new CSS_Claims__c();
        claimsobj2.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "REW-Recon Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj2;
         FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
             insert lm;
        
        Asset psnobj=new Asset();
        psnobj.Recon_Engine_Flag__c =false;
        psnobj.Labor_Multiplier__c = lm.id;
        psnobj.Warranty_Start_Date__c=system.today();
        psnobj.Application_Code__c='130';
        // psnobj.Primary__c=true;
        // psnobj.Mileage__c=2.0;
        psnobj.name='79788868';
        psnobj.Type_PSN__c = 'Engines-79788868';
        psnobj.Type__c = 'Engines';
        insert psnobj;
        
        WorkOrder wo = new WorkOrder();
        wo.Application__c = '130 - Automotive';
        wo.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        //insert wo;
        
        CSS_Claims__c claimsobj1 = new CSS_Claims__c();
        claimsobj1.Customer_Code__c = 'Cummins';
        claimsobj1.Customer_Contact_Phone__c = '12345';
        claimsobj1.Contact_First_Name__c = 'Cummins';
        claimsobj1.Contact_Last_Name__c = 'Guidanz';
        claimsobj1.Country__c = 'India';
        claimsobj1.Customer_Name__c = 'CSS';
        claimsobj1.Email_Address__c = 'abc@cummins.com';
        claimsobj1.Location__c = 'Columbus';
        claimsobj1.ESN__c='56335346';
        claimsobj1.Region__c='NORTH AMERICA';
        claimsobj1.Territory__c='UNITED STATES';
        claimsobj1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        insert claimsobj1;
        
        String esnValue = '79788868';
        String appValue= '130';
        String regionValue = 'AUSTRALIA';
        String terrValue = 'UNITED STATES';
        String warrantyStartDate = 'Date.today()-5';
        String displayCoverage='true';
        String prodMileage = '55';
        String prodMileageType = 'Miles';
        String prodHour = '35';
        
        
        //FSL_CL_CheckWarrantyCoverage.searchParamWrapper( esnValue,  appValue,  regionValue,  terrValue,  warrantyStartDate,  displayCoverage, 
        //prodMileage,  prodMileageType,  prodHour);
        String inputParams = '{'+
            '  \"esnValue\": \"79788868\",'+
            '  \"appValue\": \"130 - AUTOMOTIVE\",'+
            '  \"regionValue\": \"AUSTRALIA/ NEW ZEALAND\",'+
            '  \"terrValue\": \"AUSTRALIA\",'+
            '  \"warrantyStartDate\": \"2017-04-01\",'+
            '  \"prodMileage\": \"0\",'+
            '  \"prodMileageType\": \"Kilometers\",'+
            '  \"prodHour\": \"0\",'+
            '  \"displayCoverage\": \"Kilometers\"'+
            '}';
        String inputParams1 = '{'+
            '  \"esnValue\": \"79788868\",'+
            '  \"appValue\": \"130 - AUTOMOTIVE\",'+
            '  \"regionValue\": \"AUSTRALIA/ NEW ZEALAND\",'+
            '  \"terrValue\": \"AUSTRALIA\",'+
            '  \"warrantyStartDate\": \"",'+
            '  \"prodMileage\": \"30\",'+
            '  \"prodMileageType\": \"Miles\",'+
            '  \"prodHour\": \"0\",'+
            '  \"displayCoverage\": \"Miles\"'+
            '}'; 
        String inputParams2 = '{'+
            '  \"esnValue\": \"79788868\",'+
            '  \"regionValue\": \"AUSTRALIA\",'+
            '  \"terrValue\": \"AUSTRALIA\",'+
            '  \"failureDate\": \"2017-04-01\" '+
            '}';
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(
            Name = 'InsiteImage',
            ApplicationName__c = 'InsiteImage',
            End_Point__c = 'https://csosolutions-stg.cummins.com/INSITEImage/v1/imagefile',
            IsActive__c = true,
            Key__c = 'EQJmnS6yy0lhAmZVEa8j1MpaOdAbNRPh27NUDAK1eYs',
            Passcode__c = 'oNKi4EbhBYDkSLQUb5OP66Og2KS05cgW/RGXlTOu8ik=',
            Username__c = '66EcWToVQYb4Me7In4yKbDNnHVqP82YcO23SUYQdmlE='
        ); 
        insert inteDetails;
        
        FSL_CL_CheckWarrantyCoverage.requredProfile();
        FSL_CL_CheckWarrantyCoverage.startRequest(psnobj.Name);
        FSL_CL_CheckWarrantyCoverage.getRegionValues();
        FSL_CL_CheckWarrantyCoverage.getApplicationList();
        FSL_CL_CheckWarrantyCoverage.getTerritoryValues('AUSTRALIA');
        FSL_CL_CheckWarrantyCoverage.fetchWarrantyCoverage(inputParams);
        FSL_CL_CheckWarrantyCoverage.fetchWarrantyCoverage(inputParams1);
        FSL_CL_CheckWarrantyCoverage.fetchFieldActions(inputParams2);
        
        //FSL_CL_CheckWarrantyCoverage.getLocaleDate('12/08/2019');
        FSL_CL_CheckWarrantyCoverage.getApplication();
        CSS_Integration_Details__c intDetails =  FSL_CL_CheckWarrantyCoverage.getConnection('InsiteImage');
        FSL_CL_CheckWarrantyCoverage.receiveToken();
        
    }
}