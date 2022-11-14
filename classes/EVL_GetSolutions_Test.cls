//Adding Comment for Deployment - Sriprada
@isTest
public class EVL_GetSolutions_Test {
      @testSetup static void setup() {
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        Test.startTest();
        List<ServiceTerritory> ServiceTerritoryList = new List<ServiceTerritory>();        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        ServiceTerritoryList.add(st);
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        ServiceTerritoryList.add(st1);
        
        insert ServiceTerritoryList;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        cs.BusinessHoursId=bhs.id;
        //insert cs;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        //wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
        wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Triage & Diagnosis';
        wo.RecordTypeId     = recdtypeId;
        wo.Warranty_Start_Date__c = System.today();
        wo.Repair_Solution__c  = null;
        wo.ServiceTerritoryId=st1.Id;
        
        insert wo;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' one';
        insert fcode;
        
        wo.FaultCodeId__c = fcode.id;
        update wo;
        
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        
        
        List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.FSL_Service_Job__c=wo.Id;
        sol.userTimestamp__c=datetime.now();
        SolList.add(sol);
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.No_Access_SRT_required__c = true;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c=datetime.now();
        SolList.add(csol);
        
        CSS_Solutions__c csol1 = new CSS_Solutions__c();
        csol1.Name='T00000691';
        csol1.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol1.FSL_Solution_Position__c='1.1';
        csol1.Diagnostic_Notes__c='Test';
        csol1.Repair_Notes__c='Good';
        csol1.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol1.Repair_Response__c='Repair Successful.';
        csol1.FaultCode__c=fcode.Id;
        csol1.CSS_Nested_Solutions__c=sol.Id;
        csol1.FSL_Service_Job__c=wo.Id;
        csol1.userTimestamp__c=datetime.now();
        
        SolList.add(csol1);
        
        insert SolList;
        
        
        
        List<CSS_Solution_Component__c> solcmps = new List<CSS_Solution_Component__c>();
        solcmps.add(new CSS_Solution_Component__c(Solutions__c = csol.id, Fault_Code__c = 'test123'));
        
        solcmps.add(new CSS_Solution_Component__c(Solutions__c = csol1.id, Fault_Code__c = 'test1234'));
        insert solcmps;
        
        List<FSL_Parts__c> solpart = new List<FSL_Parts__c>();
        solpart.add(new FSL_Parts__c(Solution__c = csol.id, CSS_Solution_Component__c = solcmps[0].id, Service_Order__c=wo.Id, Replacement_Repair_Reason__c ='Campaign-TRP-ATC'));
        solpart.add(new FSL_Parts__c(Solution__c = csol1.id, CSS_Solution_Component__c = solcmps[1].id,Service_Order__c=wo.Id,Replacement_Repair_Reason__c    ='Campaign-TRP-ATC'));
        insert solpart;
        Test.stopTest();
        
    }
    public static testmethod void getSolutionsTestMethod() {
        workorder wo=[Select id from workorder Limit 1];
        CSS_Solutions__c sol=[Select Name,Solution_Title__c from CSS_Solutions__c Limit 1];
        
        List<CSS_Solution_Component__c> solcmps=[select id from CSS_Solution_Component__c ];
        List<FSL_Parts__c> solpart=[select id from FSL_Parts__c ];
        
        Knowledge__kav kv= new Knowledge__kav();
        list<Knowledge__kav> kList = new list<Knowledge__kav>();
        kv.Verification__c='abc';
        kv.Repairs__c='*#SnNo#*';
        kv.UrlName=sol.Name;
        kv.Title=sol.Solution_Title__c;
        kList.add(kv);
        insert kList;
        
        Test.startTest();
        knowledge__kav obj1 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: kList[0].Id];
        KbManagement.PublishingService.publishArticle(obj1.KnowledgeArticleId, true);
        EVL_GetSolutions.getknowledge(sol.Id);
        //    EVL_GetSolutions.getAccSRTCheck(sol.id);
        //EVL_GetSolutions.getSolknowledge(wo.Id);
        EVL_GetSolutions.continueToRepair(wo.id,sol.id);
        //   EVL_GetSolutions.continueToRepairNew(wo.id,sol.id,'Most likely the solution. Repair recommended.');
        wo.Process_Step__c = 'Triage & Diagnosis';
        //update wo;
        
        EVL_GetSolutions.continueToRepair(wo.id,sol.id);
        
        EVL_GetSolutions.getjobordernumber(wo.id);
        EVL_GetSolutions.solUpdate(sol.id, 'Most likely the solution. Repair recommended.', 'commentValue', wo.id, new List<String>{solcmps[0].id}, new List<String>{solcmps[1].id}, 
                                   new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, solpart[0].id, true)}, 
                                   new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, solpart[0].id, true)},
                                   new List<FSLSolCompWrappers.CSSCompsWrp>());
        boolean  setErrorMsg = true;
        EVL_GetSolutions.insertSelectedRootCauseOnSol(sol.id, new list<Id>{solcmps[0].id}, sol.Id);
        EVL_GetSolutions.insertViewedSolutionOnRepair(sol.id, wo.Id);
        EVL_GetSolutions.insertViewedSolutionOnDiag(sol.id, wo.Id);
        EVL_GetSolutions.insertPerformedDiagAuditEvent (sol.id,'', 'test', wo.Id);
        FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp resp= new FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp();
        FSLDiagSRTIntegrationWrappers.DiagSRTDataArea fsld = new FSLDiagSRTIntegrationWrappers.DiagSRTDataArea();
        fsld.Assignment='test';
        fsld.CaseNumber='test';
        fsld.FlexSRT='test';
        fsld.SRTAccessCode='test';
        fsld.SRTID='test';
        fsld.SRTTitle='test';
        
        //SRT Time
        FSLDiagSRTIntegrationWrappers.SRTTime srtTime = new FSLDiagSRTIntegrationWrappers.SRTTime();
        srtTime.AccessCodeA='testaccesscodeA';
        srtTime.AccessCodeB='testaccesscodeA';
        srtTime.AccessCodeC='testaccesscodeA';
        srtTime.AccessCodeD='testaccesscodeA';
        srtTime.AccessCodeR='testaccesscodeA';
        srtTime.SpecialAccessCode='SpecialtestaccesscodeA';
        srtTime.SpecialAccessCodeDescription=new List<String>{'SpecialtestaccesscodeA'};
            //Step
            FSLDiagSRTIntegrationWrappers.Step step=  new FSLDiagSRTIntegrationWrappers.Step();
        step.Percentage='10';
        step.SRTStatusMessage='test';
        step.StepID='Test';
        step.SRTTime=srtTime;
        step.StepDescription=new List<String>{'test'};   
            
            FSLDiagSRTIntegrationWrappers.VerifyRepeatValue verifyValue = new FSLDiagSRTIntegrationWrappers.VerifyRepeatValue();
        verifyValue.SRTEventPerfDateTime='test';
        verifyValue.Step=step;
        fsld.VerifyRepeatValue=verifyValue;
        
        FSLAccessibilityCheckRSTRespWrp.DataArea Da = new FSLAccessibilityCheckRSTRespWrp.DataArea ();
        //DataAre.Da = 'test';
        //FSLAccessibilityCheckRSTRespWrp.Header 
        
        FSLDiagSRTREPWrappers.Step step1=  new FSLDiagSRTREPWrappers.Step();
        step1.Percentage='10';
        //step1.='test';
        step1.StepID='Test';
        //step1.=srtTime;
        step1.StepDescription=new List<String>{'test'};   
            FSLDiagSRTREPWrappers.VerifyRepeatValue verifyValue1 = new FSLDiagSRTREPWrappers.VerifyRepeatValue();
        verifyValue1.SRTEventPerfDateTime='test';
        verifyValue1.Step=step1;
        
        FSLDiagSRTREPWrappers.CaseResponse cr = new FSLDiagSRTREPWrappers.CaseResponse();
        cr.AccessCodeA='testA';
        cr.AccessCodeB='testA';
        cr.AccessCodeC='testA';
        cr.AccessCodeD='testA';
        cr.AccessCodeR='testA';
        cr.AccessCodeS1='testA';
        cr.AccessCodeS2='testA';
        cr.AccessCodeS3='testA';
        cr.AccessCodeS4='testA';
        cr.AccessCodeS5='testA';
        cr.AccessCodeS6='testA';
        cr.AccessCodeS7='testA';
        cr.AccessCodeS8='testA';
        cr.AccessCodeS9='testA';
        cr.Assignment='testA';
        cr.FailureID='testA';
        cr.FailureName='testA';
        cr.S1Desc='testA';
        cr.S1Desc='testA';
        cr.S2Desc='testA';
        cr.S3Desc='testA';
        cr.S4Desc='testA';
        cr.S5Desc='testA';
        cr.S6Desc='testA';
        cr.S7Desc='testA';
        cr.S8Desc='testA';
        cr.S9Desc='testA';
        cr.SRTAccessCode='test';
        cr.SRTDesc='test';
        cr.SRTDetails='test';
        cr.SRTMessage='test';
        cr.SRTQuantity=1;
        cr.SRTTime=10;
        cr.SRTTitle='test';
        //cr.VerifyRepeatValue='test';
        cr.VerifyRepeatValue=verifyValue1;
        FSLDiagSRTREPWrappers.DataArea dr = new FSLDiagSRTREPWrappers.DataArea();
        dr.CaseResponse=new List<FSLDiagSRTREPWrappers.CaseResponse>{cr};
            FSLGetPartsSRTListWrapper.DataArea drw = new FSLGetPartsSRTListWrapper.DataArea();
        drw.Assignment = 'Test';
        drw.PartNumberService = 'Test';
        drw.OEM = 'Test';
        drw.FailureName = 'Test';
        drw.Qty = 'Test';
        drw.OptionNumber = 'Test';
        drw.PartNumberMfg = 'Test';
        drw.PartSize = 'Test';
        drw.PartNameService = 'Test';
        drw.FailureID = 'Test';
        drw.Notes = 'Test';
        FSLStepDescriptionResp.CaseResponse cpsr = new  FSLStepDescriptionResp.CaseResponse();
        cpsr.SRTAccessCode = 'test';
        cpsr.SRTContent = 'test';
        cpsr.SRTGroupProcedure = 'test';
        cpsr.SRTTime = 'test';
        cpsr.SRTTitle = 'test';
        FSLStepDescriptionResp.DataArea dddr = new FSLStepDescriptionResp.DataArea();
        //cpsr.CaseResponse=new List<FSLStepDescriptionResp.CaseResponse>{cpsr};
        FSLStepDescriptionResp.dataarea drp = new FSLStepDescriptionResp.dataarea();
        
        
        Test.stopTest();
        //EVL_GetSolutions.continueToRepairNew(wo.id,sol.id,'Most likely the solution. Repair recommended.');
        //EVL_GetSolutions.getAccSRTCheck(sol.id);
        //EVL_GetSolutions.upsertAdminSRT(wo.id);
    }
    
  
    
    public static testmethod void testSolutionsUpdate() {
        
        Test.startTest();
        workorder wo=[Select id from workorder Limit 1];
        CSS_Solutions__c csol=[Select Name,Solution_Title__c from CSS_Solutions__c Limit 1];
        List<FSL_Parts__c> solpart=[select id from FSL_Parts__c ];
        
        List<CSS_Solution_Component__c> solcmps=[select id from CSS_Solution_Component__c ];
        
        EVL_GetSolutions.getSolknowledge(wo.Id);
        EVL_GetSolutions.solUpdate(csol.id, 'Most likely the solution. Repair recommended.', 'commentValue', wo.id, new List<String>{solcmps[0].id}, new List<String>{solcmps[1].id}, 
                                   new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, solpart[0].id, true)}, 
                                   new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, solpart[1].id, true)},
                                   new List<FSLSolCompWrappers.CSSCompsWrp>());
        
        Test.stopTest();
        
    }
}