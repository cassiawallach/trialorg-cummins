@isTest //(seeAllData=false)
public class CSS_SRTAccessCheckListClosedCntrl_Test {
    @isTest static void testIntegrationError(){
        CSS_SRTAccessWebService.srtIntegrationError('hello');
    }
     @isTest static void testAccessToken(){
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_SRTAccessWebService.receiveToken();
    }
   
    public static testMethod void accessCheck(){
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
        
        // insert JobOrderId object
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = 'test';
        joborder.Qsol_Engine_Family_Code__c = '100';
        joborder.Service_Model__c = '100';
        insert joborder;
        system.debug('joborder=='+joborder);
        
        CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.ZipCode__c = '12345';
            testclaimsRec1.Account__c=acc.id;
            testclaimsRec1.Location_Code__c='56270-56255';
            testclaimsRec1.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec1;
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        //insert CSS_srt__c
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'rep');
        
        
        
        //insert CSS_JobEventTemporary__c    
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.JobOrder__c = joborder.id;
        jobevent.Attribute1__c = joborder.Qsol_Engine_Family_Code__c;
        jobevent.Attribute2__c = joborder.Equipment_ID__c;
        jobevent.Attribute3__c = 'test';
        jobevent.Service_Model_Name__c = joborder.Service_Model__c;
        jobevent.Source__c = 'SRT';
        jobevent.Type__c = 'Repair Access';// give type from parameters
        jobevent.ExpireDateTime__c = System.Now()+1000;
        insert jobevent;
        system.debug('jobevent==='+jobevent); 

                
        
        CSS_srt__c srt1 = new CSS_srt__c();
       /* srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.Type__c = 'Repair Access';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
        srt.Flex_Flag__c = true;
        srt.SRT_Time__c=0;*/
       // srt.srt_id__c = 'test';
       srt1.Job_Order__c = joborder.id;
                srt1.CSS_Claims__c = testclaimsRec1.id;
                srt1.Access_Code_A__c = 65;
                srt1.name = 'TestClassName';
                srt1.type__c = 'Admin';
                srt1.Assignment__c = 'PRIMARY';
                srt1.srt_time__c = 0;
                srt1.SRT_ID__c = '00-901-10';
                srt1.isPerformed__c = true;
                srt1.ODM_Status__c = '';
                srt1.Access_Code__c = 'A';
                srt1.Account_Code__c = 'EMISSION WARRANTY 70';
               srt1.Flex_Flag__c = true;
        insert srt1;
        
     
         CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();
    
    } 
    
    
    public static testMethod void accessCheck2(){
     Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
    // insert JobOrderId object
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = 'test';
        joborder.Qsol_Engine_Family_Code__c = '100';
        joborder.Service_Model__c = '100';
        joborder.Account__c=acc.id;
        insert joborder;
        system.debug('joborder=='+joborder);
        CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.ZipCode__c = '12345';
            testclaimsRec1.Account__c=acc.id;
            testclaimsRec1.Location_Code__c='56270-56255';
            testclaimsRec1.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec1;
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        //insert CSS_srt__c
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'rep');
        CSS_srt__c srt = new CSS_srt__c();
        srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.css_claims__c = testclaimsRec1.id;
        srt.Type__c = 'Repair Access';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
        srt.srt_id__c = 'test';
        insert srt;
        
        
         CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();
          
    
    }
    
    public static testMethod void accessCheck3(){
    Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
    // insert JobOrderId object
       List<CSS_Job_Order__c> ljo=new List<CSS_Job_Order__c>();
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = '';
        joborder.Qsol_Engine_Family_Code__c = '';
        joborder.Service_Model__c = '';
        joborder.Status__c = 'Closed';
        ljo.add(joborder);
        insert ljo;
        
        system.debug('joborder=='+joborder);
        CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.ZipCode__c = '12345';
            testclaimsRec1.Account__c=acc.id;
            testclaimsRec1.Location_Code__c='56270-56255';
            testclaimsRec1.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec1;
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        //insert CSS_srt__c
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'Diag Access');
        list<CSS_srt__c> lstSRT=new list<CSS_srt__c>();
        CSS_srt__c srt = new CSS_srt__c();
        srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.CSS_Claims__c=testclaimsRec1.id;
        srt.Type__c = 'Diag Access';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
        srt.srt_id__c = 'test';
        lstSRT.add(srt);
        insert lstSRT;
        
        
         CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();

    }
    
    public static testMethod void accessCheck8(){
        // insert JobOrderId object
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = 'test';
        joborder.Qsol_Engine_Family_Code__c = '100';
        joborder.Service_Model__c = '100';
        joborder.Status__c='closed';
        insert joborder;
        system.debug('joborder=='+joborder);
        
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = joborder.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = css.Id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
      //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        insert AddsolComp;
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        //ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'camp');
       ApexPages.CurrentPage().getParameters().put('componentId',AddsolComp.id);
        
        
        
        //insert CSS_JobEventTemporary__c    
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.JobOrder__c = joborder.id;
        jobevent.Attribute1__c = joborder.Qsol_Engine_Family_Code__c;
        jobevent.Attribute2__c = joborder.Equipment_ID__c;
        jobevent.Attribute3__c = 'test';
        jobevent.Service_Model_Name__c = joborder.Service_Model__c;
        jobevent.Source__c = 'SRT';
        jobevent.Type__c = 'Field Action Access';// give type from parameters
        jobevent.ExpireDateTime__c = System.Now()+1000;
        insert jobevent;
        system.debug('jobevent==='+jobevent); 

                
        
        CSS_srt__c srt = new CSS_srt__c();
        srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.Type__c = 'Field Action Access';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
        srt.Component_Id__c = AddsolComp.id;
        srt.step_id__c = 'test';
       // srt.srt_id__c = 'test';
        //insert srt;
        
        
       
         CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();
        
        }
      /*  public static testMethod void accessCheck9(){
        // insert JobOrderId object
        integer i=0;
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = 'test';
        joborder.Qsol_Engine_Family_Code__c = '100';
        joborder.Service_Model__c = '100';
        joborder.Status__c='testing1';
        insert joborder;
        system.debug('joborder=='+joborder);
        
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        //insert CSS_srt__c
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        //ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'testing');
        list<CSS_srt__c> lstSRT=new list<CSS_srt__c>();
        CSS_srt__c srt = new CSS_srt__c();
        srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.Type__c = 'test';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
       srt.srt_id__c = 'test';
       insert srt;
        CSS_srt__c srt2 = new CSS_srt__c();
        srt2.Solution_Number__c = css.id;
        srt2.Job_order__c = joborder.id;
        srt2.Type__c = 'test';
        srt2.SRT_Details__c = 'test';
        srt2.SRT_Title__c = 'MR';
        srt2.srt_id__c = 'test';
        srt2.SRT_AccessiblityCheck__c =true;
        srt2.SRT_Quantity__c=123;
       insert srt2;
            lstSRT.add(srt);
            lstSRT.add(srt2);
        
         CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();
        
        }*/
    public static testMethod void accessCheck10(){
    
    CSS_SRTAccessCheckListClosedCntrl obj = new CSS_SRTAccessCheckListClosedCntrl();
        obj.Cancel();
    
    }
    
        
}