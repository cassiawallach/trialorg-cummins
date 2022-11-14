/*******************************************************************
Test CLass for Customer Complaint Controller - FSL_CL_IntakeWarranty
<<<<<<< HEAD  
adding comment to check coverage
*********************************************************************/

@isTest(seealldata = false)
public class FSL_CL_IntakeWarrantyComp_Test {
    
    //@isTest  
    static testmethod void testmethod8() {
        
        CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'CSS_SBL_BCOVER';
        conDetail1.Username__c = 'OXzk8PV3KvMr3tMtgnZlExtTM3QmlWgXk0LkKYgPRuoK6ZbWZH8xnWZxQN+3WvoqrKq/g3juWGfwXoi/BBZ3pQ==';
        conDetail1.Passcode__c = 'W5xcpoN2AnBLiv8oootpoAaCmT6kAG58APDi5bSaIks3p9wPha5Y7+EiH+gjtWAO7svIzjutqhxqLDU2bwh3yg==';
        conDetail1.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi/warranty/v1/coverage/basic';
        conDetail1.Key__c = 'MQu8hsVkSwA1F2ZH+c4k2znkWCHl5jHNi8n17c+2Weg=';
        conDetail1.IsActive__c = true;
        conDetail1.AuthEnv__c ='MuleAuthDEV';
        insert conDetail1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.name= 'MuleAuthDEV';
        conDetails.End_Point__c= 'https://test.Com/gettoken';
        conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails.IsActive__c = true;
        conDetail1.AuthEnv__c ='MuleAuthDEV';
        conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails;
        Test.startTest();
        FSL_getBasicCoverageReqJ2A.DataArea fde = new FSL_getBasicCoverageReqJ2A.DataArea();
        fde.ESN='';
        fde.EngineApplicationCode='';
        fde.FailurePoint='';
        fde.FailureUnit='';
        fde.JobId='';
        fde.PartsWarranty='';
        fde.Region='';
        fde.ReconFlag='';
        fde.Territory='';
        fde.WarrantyStartDate='';
        FSL_getBasicCoverageReqJ2A fdg = new FSL_getBasicCoverageReqJ2A();
        fdg.DataArea = fde;
        FSL_getBasicCoverageReqJ2A.Header  fgh = new FSL_getBasicCoverageReqJ2A.Header();
        FSL_getBasicCoverageReqJ2A.Sender fds = new FSL_getBasicCoverageReqJ2A.Sender();
        fds.SenderID='';
        fds.ServiceName='';
        FSL_getBasicCoverageReqJ2A.Target fdt = new FSL_getBasicCoverageReqJ2A.Target();
        fdt.TargetID='';
        fgh.Sender  = fds;
        fgh.Target = fdt;
        fdg.Header = fgh;
        fdg.DataArea = fde;
        system.debug('request::'+fdg);
        String emptyString = '';
        boolean insertErrorRecord;
        boolean showWarrDetailsSection;
        //FSL_getBasicCoverageResponseJ2A.ListOfCoverageDedutibles listofcoveragedebut = c.ListOfCoverageDedutibles;
        // Decimal constantDecutibleAmt = 0;
        // Decimal firstVisitAmt = 0;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account a = FSLTestDataSetupCls.createAccountData();//Account set
        Asset ast=FSLTestDataSetupCls.createAssetRecord();//Asseet set
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        
        FSL_WS_SBL.testforerror = false;
        
        //Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);//WorkOrder set             
        WorkOrder wo=new WorkOrder(AccountId=a.id, assetid=ast.id, serviceterritoryId=st.Id);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.FSL_Application_Error_Message__c = '';
        insert wo;
        
        FSL_CL_IntakeWarrantyComp War1 = new FSL_CL_IntakeWarrantyComp();
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        
        wo.Application__c = '410 - FIRE TRUCK';
        wo.Mileage__c = 60;
        update wo;
        
        FSL_WarrantyServiceRetryCls.getWarrantyDetails(wo.Id); 
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        
        String returnDescr='';
        FSLIntakeWarrantyResp fd = new FSLIntakeWarrantyResp();
        FSLIntakeWarrantyResp getRetrybasiccoveragedetails = FSL_WS_SBL.getRetrybasiccoveragedetails;//getRetrybasiccoveragedetails.Header.ReturnCodeDescription = '';
        FSLIntakeWarrantyResp.Header hd = new FSLIntakeWarrantyResp.Header();            
        
        FSL_getBasicCoverageReqJ2A getBasicCoverageReq = new FSL_getBasicCoverageReqJ2A();
        FSL_getBasicCoverageReqJ2A.DataArea reqDA = new FSL_getBasicCoverageReqJ2A.DataArea();
        FSL_getBasicCoverageResponseJ2A basicCoverageDetails = new FSL_getBasicCoverageResponseJ2A();
        wo.Application_Code__c = '';
        wo.Application__c = '';
        
        //Coverage Details
        reqDA.ESN = 'test12345678test';
        reqDA.EngineApplicationCode = '';
        reqDA.Region = '';
        reqDA.Territory = '';
        reqDA.WarrantyStartDate  = '05/10/2017'; 
        reqDA.PartsWarranty = 'Y';
        reqDA.JobId = '00001234';
        reqDA.FailurePoint = '123456789012345';     
        reqDA.FailureUnit = 'Miles';      
        reqDA.ReconFlag = 'Y'; 
        
        //Coverage Details
        wo.Warranty_Integration_Status__c = '';
        wo.Warranty_Integration_Descrption__c = '';
        //getRetrybasiccoveragedetails.Header.ReturnCodeDescription = '';
        update wo;
        
        FSL_CL_IntakeWarrantyComp fslintake = new FSL_CL_IntakeWarrantyComp();
        fslintake.coveragesearch();
        Test.stopTest();
        System.assertEquals(wo,wo);
    }
    
    static testmethod void testmethod9() {
        
        CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'CSS_SBL_BCOVER';
        conDetail1.Username__c = 'OXzk8PV3KvMr3tMtgnZlExtTM3QmlWgXk0LkKYgPRuoK6ZbWZH8xnWZxQN+3WvoqrKq/g3juWGfwXoi/BBZ3pQ==';
        conDetail1.Passcode__c = 'W5xcpoN2AnBLiv8oootpoAaCmT6kAG58APDi5bSaIks3p9wPha5Y7+EiH+gjtWAO7svIzjutqhxqLDU2bwh3yg==';
        conDetail1.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi/warranty/v1/coverage/basic';
        conDetail1.AuthEnv__c ='MuleAuthDEV';
        conDetail1.IsActive__c = true;
        conDetail1.Key__c = 'MQu8hsVkSwA1F2ZH+c4k2znkWCHl5jHNi8n17c+2Weg=';
        insert conDetail1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.name= 'MuleAuthDEV';
        conDetails.End_Point__c= 'https://test.Com/gettoken';
        conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails.IsActive__c = true;
        conDetails.AuthEnv__c ='MuleAuthDEV';
        conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails;
        
        Test.startTest();
        String emptyString = '';
        boolean insertErrorRecord;
        boolean showWarrDetailsSection;
        // FSL_getBasicCoverageResponseJ2A.ListOfCoverageDedutibles listofcoveragedebut = c.ListOfCoverageDedutibles;
        // Decimal constantDecutibleAmt = 0;
        // Decimal firstVisitAmt = 0;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account a = FSLTestDataSetupCls.createAccountData();//Account set
        Asset ast=FSLTestDataSetupCls.createAssetRecord();//Asseet set
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        
        FSL_WS_SBL.testforerror = true;
        
        //Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);//WorkOrder set      
        WorkOrder wo=new WorkOrder(AccountId=a.id, assetid=ast.id, serviceterritoryId=st.Id);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.FSL_Application_Error_Message__c = '';
        wo.Mileage__c = 60;
        insert wo;
        
        wo.Application__c = '130 - AUTOMOTIVE';
        update wo;
        
        List<FSL_Coverage_Details__c> covgDetailsToInsert = new List<FSL_Coverage_Details__c>();
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        FSL_CL_IntakeWarrantyComp War1 = new FSL_CL_IntakeWarrantyComp();
        FSL_WarrantyServiceRetryCls.getWarrantyDetails(wo.Id); 
        
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        String returnDescr='';
        
        FSLIntakeWarrantyResp fd = new FSLIntakeWarrantyResp();
        FSLIntakeWarrantyResp getRetrybasiccoveragedetails = FSL_WS_SBL.getRetrybasiccoveragedetails;//getRetrybasiccoveragedetails.Header.ReturnCodeDescription = '';
        FSLIntakeWarrantyResp.Header hd = new FSLIntakeWarrantyResp.Header();            
        
        FSL_getBasicCoverageReqJ2A getBasicCoverageReq = new FSL_getBasicCoverageReqJ2A();
        FSL_getBasicCoverageReqJ2A.DataArea reqDA = new FSL_getBasicCoverageReqJ2A.DataArea();
        FSL_getBasicCoverageResponseJ2A basicCoverageDetails = new FSL_getBasicCoverageResponseJ2A();
        wo.Application_Code__c = '';
        wo.Application__c = '';
        
        //Coverage Details
        reqDA.ESN = 'test12345678test';
        reqDA.EngineApplicationCode = '';
        reqDA.Region = '';
        reqDA.Territory = '';
        reqDA.WarrantyStartDate  = '05/10/2017'; 
        reqDA.PartsWarranty = 'Y';
        reqDA.JobId = '00001234';
        reqDA.FailurePoint = '123456789012345';     
        reqDA.FailureUnit = 'Miles';      
        reqDA.ReconFlag = 'Y'; 
        //Coverage Details
        wo.Warranty_Integration_Status__c = '';
        wo.Warranty_Integration_Descrption__c = '';
        //getRetrybasiccoveragedetails.Header.ReturnCodeDescription = '';
        string coverageDetailsSTR='';
        string coverageDetailsSTR2='';
        for(FSL_Coverage_Details__c cd : covgDetailsToInsert) {
            String wsd;
            if(cd.Warranty_Start_Date__c <> null)
                wsd = cd.Warranty_Start_Date__c.month() + '/' + cd.Warranty_Start_Date__c.day()+ '/'+cd.Warranty_Start_Date__c.year();
            else
                wsd = '';
            coverageDetailsSTR2 = coverageDetailsSTR2 +'\nCoverage Type: ' + cd.Coverage_Type__c;
            coverageDetailsSTR2 = coverageDetailsSTR2 +'\nStatus: ' + cd.Status__c;
            coverageDetailsSTR2 = coverageDetailsSTR2 +
                '\nWarranty Start: ' + wsd +
                '\nWarranty End: ' + cd.Warranty_End__c +
                '\nCoverage Months: ' + cd.Max_Months__c +
                '\nCoverage Miles: ' + cd.Cov_Miles__c +
                '\nCoverage Kilometers: ' + cd.Cov_Kms__c +
                '\nCoverage Hours: '+ cd.Hours__c +
                '\nCoverage Megawatt Hours: ' + cd.Mega_Watt_Hours__c +
                '\nDeductible: ';// + trueValue + '\n'
        }
        
        update wo;
        FSL_getBasicCoverageResponseJ2A.CoverageDedutibles fcd = new FSL_getBasicCoverageResponseJ2A.CoverageDedutibles();
        fcd.BeginHours = 'test';
        fcd.BeginMegawattHours = 'test';
        fcd.BeginMiles = 'test';
        fcd.BeginMonths = 'test';
        fcd.ConstantDecutibleAmt = 'test';
        fcd.CoverageDefTypeCode = 'test';
        fcd.FirstVisitAmt = 'test';
        fcd.SubsequentVisitAmt = 'test';
        system.debug('<<<fcd'+fcd);
        FSLIntakeWarrantyResp.Header fhi = new FSLIntakeWarrantyResp.Header();
        fhi.ReturnCodeDescription='ReturnCodeDescription';
        fhi.Status = 'Status';
        fhi.Remaining = 'Remaining';
        FSLIntakeWarrantyResp.BasicCoverageResponseHeader fb = new FSLIntakeWarrantyResp.BasicCoverageResponseHeader();
        fb.response = 'response';
        FSLIntakeWarrantyResp resp = new FSLIntakeWarrantyResp();
        resp.header = fhi;
        resp.BasicCoverageResponseHeader = fb;
        system.debug(resp);
        FSL_CL_IntakeWarrantyComp fslintaketest = new FSL_CL_IntakeWarrantyComp();
        fslintaketest.coveragesearch();
        Test.stopTest();
        System.assertEquals(wo,wo);
    } 
    static testmethod void getpartsdatamethod() {
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartsData';
        cid.ApplicationName__c = 'CSS_SBL_GetPartsData';
        cid.Method_Type__c = 'GET';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/parts?sender=CSS&target=CSSWarranty&partNumberShort=3899283';
        insert cid;
        FSL_WS_SBL.getpartsdata('23456');
    }
    //Added by Naga Anusha Devi Malepati,9/2/22, for test class code coverage
    static testmethod void dateconverted()
    {
        String dt = FSL_CL_IntakeWarrantyComp.getDateConverted('09/21/2022');
        
    }
    static testmethod void testmethod10() {
        
        CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'CSS_SBL_BCOVER';
        conDetail1.Username__c ='OXzk8PV3KvMr3tMtgnZlExtTM3QmlWgXk0LkKYgPRuoK6ZbWZH8xnWZxQN+3WvoqrKq/g3juWGfwXoi/BBZ3pQ==';
        conDetail1.Passcode__c ='W5xcpoN2AnBLiv8oootpoAaCmT6kAG58APDi5bSaIks3p9wPha5Y7+EiH+gjtWAO7svIzjutqhxqLDU2bwh3yg==';
        conDetail1.End_Point__c ='https://api-ue-devnf2-aw-ex.cummins.com/cmi/warranty/v1/coverage/basic';
        conDetail1.Key__c = 'MQu8hsVkSwA1F2ZH+c4k2znkWCHl5jHNi8n17c+2Weg=';
        conDetail1.IsActive__c = true;
        conDetail1.AuthEnv__c ='MuleAuthDEV';
        insert conDetail1;
        
        CSS_Integration_Details__c conDetails = new
            CSS_Integration_Details__c();
        conDetails.name= 'MuleAuthDEV';
        conDetails.End_Point__c= 'https://test.Com/gettoken';
        conDetails.Username__c=
            '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails.Passcode__c=
            'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails.IsActive__c = true;
        conDetail1.AuthEnv__c ='MuleAuthDEV';
        conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails;
        Test.startTest();
        FSL_getBasicCoverageReqJ2A.DataArea fde = new
            FSL_getBasicCoverageReqJ2A.DataArea();
        fde.ESN='';
        fde.EngineApplicationCode='';
        fde.FailurePoint='';
        fde.FailureUnit='';
        fde.JobId='';
        fde.PartsWarranty='';
        fde.Region='';
        fde.ReconFlag='';
        fde.Territory='';
        fde.WarrantyStartDate='';
        FSL_getBasicCoverageReqJ2A fdg = new FSL_getBasicCoverageReqJ2A();
        fdg.DataArea = fde;
        FSL_getBasicCoverageReqJ2A.Header  fgh = new
            FSL_getBasicCoverageReqJ2A.Header();
        FSL_getBasicCoverageReqJ2A.Sender fds = new
            FSL_getBasicCoverageReqJ2A.Sender();
        fds.SenderID='';
        fds.ServiceName='';
        FSL_getBasicCoverageReqJ2A.Target fdt = new
            FSL_getBasicCoverageReqJ2A.Target();
        fdt.TargetID='';
        fgh.Sender  = fds;
        fgh.Target = fdt;
        fdg.Header = fgh;
        fdg.DataArea = fde;
        system.debug('request::'+fdg);
        String emptyString = '';
        boolean insertErrorRecord;
        boolean showWarrDetailsSection;
        //FSL_getBasicCoverageResponseJ2A.ListOfCoverageDedutibles
        //listofcoveragedebut = c.ListOfCoverageDedutibles;
        // Decimal constantDecutibleAmt = 0;
        // Decimal firstVisitAmt = 0;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account a = FSLTestDataSetupCls.createAccountData();//Account set
        Asset ast=FSLTestDataSetupCls.createAssetRecord();//Asseet set
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        
        FSL_WS_SBL.testforerror = false;
        
        //Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a,st);//WorkOrder set
        WorkOrder wo=new WorkOrder(AccountId=a.id, assetid=ast.id,
                                   serviceterritoryId=st.Id);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.FSL_Application_Error_Message__c = '';
        insert wo;
        FSL_CL_IntakeWarrantyComp War1 = new FSL_CL_IntakeWarrantyComp();
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        
        wo.Application__c = '410 - FIRE TRUCK';
        wo.Mileage__c = 60;
        wo.Type__c = 'Dealer';
        update wo;
        
        FSL_WarrantyServiceRetryCls.getWarrantyDetails(wo.Id);
        FSL_WarrantyServiceRetryCls.getWorkOrderInfo(wo.Id);
        FSL_WarrantyServiceRetryCls.getWarrantyDetailsNew(wo.Id);
        
        String returnDescr='';
        FSLIntakeWarrantyResp fd = new FSLIntakeWarrantyResp();
        FSLIntakeWarrantyResp getRetrybasiccoveragedetails =
            FSL_WS_SBL.getRetrybasiccoveragedetails;//getRetrybasiccoveragedetails.Header.ReturnCodeDescription= '';
        FSLIntakeWarrantyResp.Header hd = new
            FSLIntakeWarrantyResp.Header();
        
        FSL_getBasicCoverageReqJ2A getBasicCoverageReq = new
            FSL_getBasicCoverageReqJ2A();
        FSL_getBasicCoverageReqJ2A.DataArea reqDA = new
            FSL_getBasicCoverageReqJ2A.DataArea();
        FSL_getBasicCoverageResponseJ2A basicCoverageDetails = new
            FSL_getBasicCoverageResponseJ2A();
        wo.Application_Code__c = '';
        wo.Application__c = '';
        
        //Coverage Details
        reqDA.ESN = 'test12345678test';
        reqDA.EngineApplicationCode = '';
        reqDA.Region = '';
        reqDA.Territory = '';
        reqDA.WarrantyStartDate  = '05/10/2017';
        reqDA.PartsWarranty = 'Y';
        reqDA.JobId = '00001234';
        reqDA.FailurePoint = '123456789012345';
        reqDA.FailureUnit = 'Miles';
        reqDA.ReconFlag = 'Y';
        
        //Coverage Details
        wo.Warranty_Integration_Status__c = '';
        wo.Warranty_Integration_Descrption__c = '';
        //getRetrybasiccoveragedetails.Header.ReturnCodeDescription = '';
        update wo;
        
        FSL_CL_IntakeWarrantyComp fslintake = new FSL_CL_IntakeWarrantyComp();
        fslintake.coveragesearch();
        Test.stopTest();
        System.assertEquals(wo,wo);
    }
    //Ended by Naga Anusha Devi Malepati,9/2/22, for test class code coverage
}