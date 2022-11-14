/**********************************************************************
Name: FSLAccessibilityChecklistCls_Test
Copyright Â© 2019  Cummins
=========================================================================
=======================================================================
Purpose:                                                            
-------  
These is used for the display of the solution components Test class.
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE          	Details                         
1.0		 Vinod Yelala				4/19/2019
2.0		Rajender Mittapalli			05/26/2022		Added OverlapSRTSuccess and OverlapSRTFailure Methods
***********************************************************************/
@isTest
public class FSLAccessibilityChecklistCls_Test {
    
    static testMethod void testlogic1() {
        
        Test.startTest();
        FSLTestDataSetupCls.createIntegrationConfigs();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.IAM_Service_ProvIder_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.8;
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.Id;
        con.FSL_Contact_Id__c='1';
        insert con;
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '03520-04892';
        sT.FSL_Service_Territory_Code__c = '04892';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        
        Asset ast = new Asset(name='Assst1', Type_PSN__c='aset1223', Make__c='test make', Model__c='test model', Engine_Family_Code__c='testef');
        insert ast;
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        Date d = Date.Today();
        wo.DSID__c = '12345';
        wo.Customer_Name__c = 'ABC';
        wo.Failure_Date__c = d;
        wo.Service_Model__c = 'ESN';
        wo.Make__c = 'test';
        wo.Model__c = 'test1';
        wo.Customer_Name__c = 'Sam Torq';
        wo.Warranty_Start_Date__c = d;
        wo.ESN__c = '';
        wo.Mileage__c = 12345;
        wo.Mileage_measure__c = 'Miles';
        wo.ServiceTerritoryId = sT.Id;
        wo.AssetId = ast.Id;
        
        Insert wo;
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId = recdtypeId;
        Update wo;
        Test.stopTest();
        
        try {
            CSS_Make_Model_Access__c csm = new CSS_Make_Model_Access__c(Make__c='test make',Model__c='test model',Access__c='TestABC',EngineFamilyCode__c='testef');
            insert csm;
            knowledge__kav knw=new knowledge__kav(urlname = 'testurl', title = 'testtitile');
            insert knw; 
            CSS_Solutions__c sol1 = new CSS_Solutions__c(FSL_Service_Job__c = wo.Id, Solution_Title__c = 'testSol', Solution__c = 'Solution1');
            insert sol1;
            
            
            FSL_SRT__c fsr = new FSL_SRT__c(Solution_Number__c = sol1.Id,
                                            Service_Order__c = wo.Id,
                                            Type__c = 'Diag Access',
                                            SRT_Select__c = TRUE,
                                            SRT_Quantity__c = 2,
                                            SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
            insert fsr;
            CSS_SRT__c csr = new CSS_SRT__c(Solution_Number__c = sol1.Id,
                                            SRT_Select__c = TRUE,
                                            SRT_Quantity__c = 2,
                                            SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
            insert csr;
            ServiceOrderContact__c SOC = new ServiceOrderContact__c();
            SOC.Service_Order__c = wo.id;
            SOC.Payer_Account__c = acc.id;
            SOc.Payer_Contact__c = con.id;
            insert SOC;
            
            FSLAccessibilityChecklistCls.saveSRTsToDB(FSLAccessibilityChecklistCls.getAccessbilitySRTs(wo.Id, sol1.Id), wo.Id, Sol1.Id);
            FSLAccessibilityChecklistCls.CSSSRTWrps srtwrp = new FSLAccessibilityChecklistCls.CSSSRTWrps(fsr);
            srtwrp.cssSrt = fsr;
            srtwrp.isSelected = true;
            
            FSLAccessibilityChecklistCls.saveSRTDealer(FSLAccessibilityChecklistCls.getAccessbilitySRTs(wo.Id, sol1.Id), wo.Id, Sol1.Id, 'Diagnostic');
            FSLAccessibilityChecklistCls.saveSRTDealer(FSLAccessibilityChecklistCls.getAccessbilitySRTs(wo.Id, sol1.Id), wo.Id, Sol1.Id, 'Repair');
            
            //FSLAccessibilityChecklistCls.getAccessbilitySRTs(wo.Id, Sol1.Id);
            FSLAccessibilityChecklistCls.getWorkOrderRecordType(wo.Id);
            FSLAccessibilityChecklistCls.logAccessSRTAuditEvent(wo.Id, Sol1.Id);
            FSLAccessibilityChecklistCls.getAccSRTCheck(Sol1.Id);
            FSLAccessibilityChecklistCls.getSRTCount(Sol1.Id);
            
            FSLAccessibilityChecklistCls.saveAccSRTCheck(Sol1.Id,true);
            FSLAccessibilityCheckRSTRespWrp fsttt = new FSLAccessibilityCheckRSTRespWrp();
            FSLAccessibilityCheckRSTRespWrp.DataArea da = new FSLAccessibilityCheckRSTRespWrp.DataArea ();
            FSLAccessibilityCheckRSTRespWrp.Header ha = new  FSLAccessibilityCheckRSTRespWrp.Header ();
            ha.Status = 'Success';
            ha.ReturnCodeDescription = 'test';
            FSLAccessibilityCheckRSTRespWrp.CaseResponse cr = new FSLAccessibilityCheckRSTRespWrp.CaseResponse();
            cr.SRTDetails='test';
            cr.SRTTitle='test';
            FSLAccessibilityCheckRSTRespWrp.AccessTokenWrp acct = new FSLAccessibilityCheckRSTRespWrp.AccessTokenWrp();
            acct.access_token = 'KS6hb6LmaUqrJRf0d3JdS4uznlaT82D2XUlKhA7ZAC2pgUsPL5JH4U';
            acct.token_type = 'Bearer';
            acct.expires_in = '1200';
            acct.refresh_token = 'YWP8Jy31FhCok2tqcUp7sNfyno7hp5G3ghj6JPaqoOIueZ';
            acct.scope = 'CSSCloud';
            da.CaseResponse = new List<FSLAccessibilityCheckRSTRespWrp.CaseResponse>{cr};
                
                FSLStepDescriptionResp fstttt = new FSLStepDescriptionResp();
            FSLStepDescriptionResp.DataArea Daa = new FSLStepDescriptionResp.DataArea ();
            FSLStepDescriptionResp.Header haa = new  FSLStepDescriptionResp.Header ();
            haa.Status = 'Success';
            haa.ReturnCodeDescription = 'test';
            FSLStepDescriptionResp.CaseResponse crrr = new FSLStepDescriptionResp.CaseResponse();
            crrr.SRTAccessCode='test';
            crrr.SRTGroupProcedure = 'test';
            crrr.SRTTime = 'test';
            crrr.SRTTitle = 'test';
        } catch(exception e) {
            
        }
    }
    
    
    static testMethod void testlogic2() {
        
        Test.startTest();
        FSLTestDataSetupCls.createIntegrationConfigs();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.IAM_Service_ProvIder_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.8;
        insert acc;
        try{
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567891';
            con.AccountId=acc.Id;
            con.FSL_Contact_Id__c='1';
            insert con;
            worktype  wType = new worktype();
            wType.EstimatedDuration = Decimal.valueOf('40.02');
            wType.Name = 'Test';
            insert wType;
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            insert sT;
            
            Asset ast = new Asset(name='Assst1', Type_PSN__c='aset1223', Make__c='test make', Model__c='test model', Engine_Family_Code__c='testef');
            insert ast;
            
            Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
            WorkOrder wo = new WorkOrder();
            Date d = Date.Today();
            wo.DSID__c = '12345';
            wo.Customer_Name__c = 'ABC';
            wo.Failure_Date__c = d;
            wo.Service_Model__c = 'ESN';
            wo.Make__c = 'test';
            wo.Model__c = 'test1';
            wo.Customer_Name__c = 'Sam Torq';
            wo.Warranty_Start_Date__c = d;
            wo.ESN__c = '';
            wo.Mileage__c = 12345;
            wo.Mileage_measure__c = 'Miles';
            wo.ServiceTerritoryId = sT.Id;
            wo.AssetId = ast.Id;
            Insert wo;
            wo.Process_Step__c = 'Repair';
            wo.RecordTypeId = recdtypeId;
            Update wo;
            Test.stopTest();
            
            CSS_Make_Model_Access__c csm = new CSS_Make_Model_Access__c(Make__c='test make',Model__c='test model',Access__c='TestABC',EngineFamilyCode__c='testef');
            insert csm;
            knowledge__kav knw=new knowledge__kav(urlname = 'testurl', title = 'testtitile');
            insert knw; 
            CSS_Solutions__c sol1 = new CSS_Solutions__c(FSL_Service_Job__c = wo.Id, Solution_Title__c = 'testSol', Solution__c = 'Solution1');
            insert sol1;
            FSL_SRT__c fsr = new FSL_SRT__c(Solution_Number__c = sol1.Id,
                                            Service_Order__c = wo.Id,
                                            Type__c = 'Diag Access',
                                            SRT_Select__c = TRUE,
                                            SRT_Quantity__c = 2,
                                            SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
            insert fsr;
            CSS_SRT__c csr = new CSS_SRT__c(Solution_Number__c = sol1.Id,
                                            SRT_Select__c = TRUE,
                                            SRT_Quantity__c = 2,
                                            SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
            insert csr;
            ServiceOrderContact__c SOC = new ServiceOrderContact__c();
            SOC.Service_Order__c = wo.id;
            SOC.Payer_Account__c = acc.id;
            SOc.Payer_Contact__c = con.id;
            insert SOC;
            
            FSLAccessibilityChecklistCls.saveSRTsToDB(FSLAccessibilityChecklistCls.getAccessbilitySRTs(wo.Id, sol1.Id), wo.Id, Sol1.Id);
            FSLAccessibilityChecklistCls.CSSSRTWrps srtwrp = new FSLAccessibilityChecklistCls.CSSSRTWrps(fsr);
            srtwrp.cssSrt = fsr;
            srtwrp.isSelected = true;
            
            FSLAccessibilityChecklistCls.getAccessbilitySRTs_EVL(wo.Id, sol1.Id);
            
            FSLAccessibilityChecklistCls.saveAccSRTCheck(Sol1.Id,true);
            FSLAccessibilityCheckRSTRespWrp fsttt = new FSLAccessibilityCheckRSTRespWrp();
            FSLAccessibilityCheckRSTRespWrp.DataArea da = new FSLAccessibilityCheckRSTRespWrp.DataArea ();
            FSLAccessibilityCheckRSTRespWrp.Header ha = new  FSLAccessibilityCheckRSTRespWrp.Header ();
            ha.Status = 'Success';
            ha.ReturnCodeDescription = 'test';
            FSLAccessibilityCheckRSTRespWrp.CaseResponse cr = new FSLAccessibilityCheckRSTRespWrp.CaseResponse();
            cr.SRTDetails='test';
            cr.SRTTitle='test';
            FSLAccessibilityCheckRSTRespWrp.AccessTokenWrp acct = new FSLAccessibilityCheckRSTRespWrp.AccessTokenWrp();
            acct.access_token = 'KS6hb6LmaUqrJRf0d3JdS4uznlaT82D2XUlKhA7ZAC2pgUsPL5JH4U';
            acct.token_type = 'Bearer';
            acct.expires_in = '1200';
            acct.refresh_token = 'YWP8Jy31FhCok2tqcUp7sNfyno7hp5G3ghj6JPaqoOIueZ';
            acct.scope = 'CSSCloud';
            da.CaseResponse = new List<FSLAccessibilityCheckRSTRespWrp.CaseResponse>{cr};
                
                FSLStepDescriptionResp fstttt = new FSLStepDescriptionResp();
            FSLStepDescriptionResp.DataArea Daa = new FSLStepDescriptionResp.DataArea ();
            FSLStepDescriptionResp.Header haa = new  FSLStepDescriptionResp.Header ();
            haa.Status = 'Success';
            haa.ReturnCodeDescription = 'test';
            FSLStepDescriptionResp.CaseResponse crrr = new FSLStepDescriptionResp.CaseResponse();
            crrr.SRTAccessCode='test';
            crrr.SRTGroupProcedure = 'test';
            crrr.SRTTime = 'test';
            crrr.SRTTitle = 'test';
        }catch(exception e){
            
        }
    }
    
    static testMethod void testlogic3() {
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.IAM_Service_ProvIder_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.8;
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.Id;
        con.FSL_Contact_Id__c='1';
        insert con;
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '03520-04892';
        sT.FSL_Service_Territory_Code__c = '04892';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        Asset ast = new Asset(name='Assst1', Type_PSN__c='aset1223', Make__c='test make', Model__c='test model', Engine_Family_Code__c='testef');
        insert ast;
        Test.startTest();  
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        Date d = Date.Today();
        wo.DSID__c = '12345';
        wo.Customer_Name__c = 'ABC';
        wo.Failure_Date__c = d;
        wo.Service_Model__c = 'ESN';
        wo.Make__c = 'test';
        wo.Model__c = 'test1';
        wo.Customer_Name__c = 'Sam Torq';
        wo.Warranty_Start_Date__c = d;
        wo.ESN__c = '';
        wo.Mileage__c = 12345;
        wo.Mileage_measure__c = 'Miles';
        wo.ServiceTerritoryId = sT.Id;
        wo.AssetId = ast.Id;
        Insert wo;
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId = recdtypeId;
        Update wo;
        
        CSS_Make_Model_Access__c csm = new CSS_Make_Model_Access__c(Make__c='test make',Model__c='test model',Access__c='TestABC',EngineFamilyCode__c='testef');
        insert csm;
        knowledge__kav knw=new knowledge__kav(urlname = 'testurl', title = 'testtitile');
        insert knw; 
        CSS_Solutions__c sol1 = new CSS_Solutions__c(FSL_Service_Job__c = wo.Id, Solution_Title__c = 'testSol', Solution__c = 'Solution1');
        insert sol1;
        FSL_SRT__c fsr = new FSL_SRT__c(Solution_Number__c = sol1.Id,
                                        Service_Order__c = wo.Id,
                                        Type__c = 'Diag Access',
                                        SRT_Select__c = TRUE,
                                        SRT_Quantity__c = 2,
                                        SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
        insert fsr;
        CSS_SRT__c csr = new CSS_SRT__c(Solution_Number__c = sol1.Id,
                                        SRT_Select__c = TRUE,
                                        SRT_Quantity__c = 2,
                                        SRT_Title__c = 'Exhaust System Diagnostics - Contamination/Incorrect Fluid');
        insert csr;
        ServiceOrderContact__c SOC = new ServiceOrderContact__c();
        SOC.Service_Order__c = wo.id;
        SOC.Payer_Account__c = acc.id;
        SOc.Payer_Contact__c = con.id;
        insert SOC;
        
        
        Test.stopTest();       
        FSLStepDescriptionResp fstttt = new FSLStepDescriptionResp();
        FSLStepDescriptionResp.DataArea Daa = new FSLStepDescriptionResp.DataArea ();
        FSLStepDescriptionResp.Header haa = new  FSLStepDescriptionResp.Header ();
        haa.Status = 'Success';
        haa.ReturnCodeDescription = 'test';
        FSLStepDescriptionResp.CaseResponse crrr = new FSLStepDescriptionResp.CaseResponse();
        crrr.SRTAccessCode='test';
        crrr.SRTGroupProcedure = 'test';
        crrr.SRTTime = 'test';
        crrr.SRTTitle = 'test';
        
    }
    
    //Road 267 - Success method for getOverlapSRTRecords
    public static testMethod void OverlapSRTSuccess() {
        String responseBody;
        Integer responseStatus;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"Header":{"MessageIdentifier":"2-1816cb60-e33d-11ec-9c74-126ffe1a44cc","ReturnCode":"ORA-00000","ReturnCodeDescription":"Normal, Successful completion.","Status":"SUCCESS","MessageType":"S"},"DataArea":{"TotalOverlapHours":0.6,"Steps":[{"StepId":1234,"Qty":2,"SRTHours":0,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"AccessCode":"R","SRTAdjustedHours":0},{"StepId":1235,"Qty":1,"SRTHours":0.6,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"AccessCode":"B","SRTAdjustedHours":0.6}],"OverlapSRTTime":[],"MutualExMessage":"","TotalAdjustedHours":0.6}}'));
        string overlapSRTReq = '{"Header":{"Sender":{"ServiceName":"GetOverlapSRT","SenderID":"CSS"},"Target":{"TargetID":"SRT"}},"DataArea":{"Jobid":"CSS-000001234","ClaimID":"C100002045","Languagecode":"en","DTTimestamp":"","EffectiveDTTime":"","Steps":[{"StepId":1234,"Qty":2,"AccessCode":"R"},{"StepId":1235,"Qty":1,"AccessCode":"B"}]}}';
        CSS_OverlapSRTReq srt = CSS_OverlapSRTReq.parse(overlapSRTReq);
        CG_OP_OAGWrapper overlapSRT = FSLSRTIntegrationHelperCls.getOverlapSRTRecords(srt);
        responseBody = overlapSRT.response.getbody();
        responseStatus = overlapSRT.response.getStatusCode();
        System.assert(responsebody.contains('SUCCESS'));
        System.assertEquals(200,responseStatus);
        test.stopTest();
    }
    
    //Road 267 - Failure method for getOverlapSRTRecords
    public static testMethod void OverlapSRTFailure() {
        Integer responseStatus;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Reclaim());
        string overlapSRTReq = '{"Header":{"Sender":{"ServiceName":"Mock_Service","SenderID":"CSS"}},"DataArea":{"Jobid":"test","ClaimID":"test","Languagecode":"en","DTTimestamp":"","EffectiveDTTime":""}}';
        CSS_OverlapSRTReq srt = CSS_OverlapSRTReq.parse(overlapSRTReq);
        CG_OP_OAGWrapper overlapSRT = FSLSRTIntegrationHelperCls.getOverlapSRTRecords(srt);
        CG_OP_OAGWrapper olSRT = FSLSRTIntegrationHelperCls.getOverlapSRTRecords(null);
        responseStatus = overlapSRT.response.getStatusCode();
        System.assertEquals(400,responseStatus);
        Boolean resExceptionFlag = olSRT.exceptionFlag;
        System.assertEquals(true,resExceptionFlag);
        test.stopTest();
    }
    // Added by Sriprada S for code coverage 
    //runDiagnosticSRTInterface
     public static testMethod void runDiagnosticSRTInterface() {
         Integer responseStatus;
         
         test.startTest();
         CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
         conDetail.Name = 'CG_GETDiagnosticSRT';
         conDetail.Username__c = 'Testing';
         conDetail.Passcode__c = '74784848Test';
         conDetail.End_Point__c = 'https://test.com/cmi-claims/history';
         insert conDetail;
         
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Reclaim());
         FSLDiagSRTIntegrationWrappers fsrt = new FSLDiagSRTIntegrationWrappers();
         WorkOrder wo = new WorkOrder();
         FSLSRTIntegrationHelperCls.runDiagnosticSRTInterface(wo, 'Diag Access','');
         test.stopTest();
    }
    //runRepairSRTInterface
     public static testMethod void runRepairSRTInterface() {
         Integer responseStatus;
         
         test.startTest();
         CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
         conDetail.Name = 'CG_GETDiagnosticSRT';
         conDetail.Username__c = 'Testing';
         conDetail.Passcode__c = '74784848Test';
         conDetail.End_Point__c = 'https://test.com/cmi-claims/history';
         insert conDetail;
         
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Reclaim());
         FSLDiagSRTIntegrationWrappers fsrt = new FSLDiagSRTIntegrationWrappers();
         WorkOrder wo = new WorkOrder();
         CSS_Fault_Code__c fc = new CSS_Fault_Code__c();
         fc.Name = '145';
         insert fc;
         
         CSS_Solutions__c sol = new CSS_Solutions__c(FSL_Service_Job__c = wo.Id, Solution_Title__c = 'testSol', Solution__c = 'Solution1');
         insert sol;
         List<String> solCmps = new List<String>();
         CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c(FSL_Service_Job__c = wo.Id, Component_Id__c = 'testCmp', Solutions__c = sol.Id);
		 insert solCmp;
        // CSS_Solution_Component__c solCmps = [SELECT Id, Name from CSS_Solution_Component__c WHERE Solutions__c =: sol.Id LIMIT 1];
         solCmps.add(solCmp.Name);

         FSLSRTIntegrationHelperCls.runRepairSRTInterface(wo, 'Repair','',sol.Id,solCmps);
         test.stopTest();
    }
}