//Adding Comment for deployment 
@isTest
private class FSL_CL_RepairDisplaySolution_Test {
    public static void createData() {
        CSS_Integration_Details__c objIntegrationDetails1 = new CSS_Integration_Details__c();
        objIntegrationDetails1.Name = 'OAGOAuthTest';
        objIntegrationDetails1.ApplicationName__c = 'OAGOAuthTest';
        objIntegrationDetails1.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
        objIntegrationDetails1.IsActive__c = true;
        objIntegrationDetails1.Key__c = '12345';
        objIntegrationDetails1.Passcode__c= 'test';
        objIntegrationDetails1.Username__c= 'test';
        insert objIntegrationDetails1;
        
        CSS_Integration_Details__c objIntegrationDetails2 = new CSS_Integration_Details__c();
        objIntegrationDetails2.IsActive__c=true;
        objIntegrationDetails2.Key__c = '2344';
        objIntegrationDetails2.End_Point__c= 'https://services-test.cummins.com/css/getcampaigndetails';
        objIntegrationDetails2.Name = 'GetCampaign';
        objIntegrationDetails2.ApplicationName__c = 'GetCampaign';        
        objIntegrationDetails2.Passcode__c= 'test';
        objIntegrationDetails2.Username__c= 'test';
        objIntegrationDetails2.Timeout__c=120000.0;
        objIntegrationDetails2.Method_Type__c='POST' ;
        objIntegrationDetails2.Logging__c='BOTH';
        objIntegrationDetails2.AuthEnv__c='OAGOAuthTest';
        insert objIntegrationDetails2;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '03250-02851';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.FSL_Service_Territory_Code__c = '02851';
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.Type_PSN__c = 'Engines-79788868';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        // objWorkOrder.RecordType.Name = 'SolutionRepair';
        insert objWorkOrder;
    }
    
    @isTest
    public static void testGetWorkOrderRecordType() {
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        fsl_cl_repairdisplaysolution.getWorkOrderRecordType(objWorkOrder.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getknowledgeTest() {
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        
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
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       // wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        Service_Order_Extension__c extn = new Service_Order_Extension__c();
        extn.Service_Order_Id__c = wo.Id;
        extn.FaultCodeId__c = '145';
        insert extn;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        Test.startTest();
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        insert fcode;
        extn.FaultCodeId__c=fcode.id;
      	update extn;
        
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=extn.FaultCodeId__c;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        //Test.startTest();
        CSS_Solutions__c csol= new CSS_Solutions__c();
        csol.Name='T00000691';
        sol.FSL_Service_Job__c = wo.Id;
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=extn.FaultCodeId__c;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.userTimestamp__c=datetime.now();
        insert csol;
        CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c(Solutions__c=csol.id, Fault_Code__c='test123');
        insert solcmp;
        Knowledge__kav kv= new Knowledge__kav();
        list<Knowledge__kav> kList = new list<Knowledge__kav>();
        kv.Verification__c='abc';
        kv.Repairs__c='*#SnNo#*';
        kv.UrlName=sol.Name;
        kv.Title=sol.Solution_Title__c;
        kList.add(kv);
        insert kList;
        //KbManagement.PublishingService.publishArticle(kv.id, true);
        knowledge__kav obj1 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: kList[0].Id];
        
        KbManagement.PublishingService.publishArticle(obj1.KnowledgeArticleId, true);
        
        FSL_CL_RepairDisplaySolution.getknowledge(sol.Id);
        //FSL_CL_RepairDisplaySolution.woselecomnull(wo.Id);
        FSL_CL_RepairDisplaySolution.getSolknowledge(wo.Id);
        //FSL_CL_RepairDisplaySolution.solUpdate(sol.Id,'repair','response',wo.id);    
        FSL_CL_RepairDisplaySolution.changeRecord(wo.Id,sol.Id);
        FSL_CL_RepairDisplaySolution.getjobordernumber(wo.id);
        FSL_CL_RepairDisplaySolution.insertSelectedRootCauseOnRepair(csol.Id, new List<ID>{solcmp.id}, wo.id);
        FSL_CL_RepairDisplaySolution.insertViewedSolutionOnRepair(csol.id, wo.id);
        test.stopTest();
    }
    
    public static testmethod void getSolutionsTestMethod() {
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
        ase.Type_PSN__c='Engines-79644334';
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
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        Service_Order_Extension__c extn = new Service_Order_Extension__c();
        //extn.Service_Order_Id__c = wo.Id;
        extn.FaultCodeId__c = '';
        insert extn;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       // wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.EVL_Stage__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        wo.ServiceTerritoryId=st1.Id;
        update wo;
       
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        Test.startTest();
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        insert fcode;
        
         
        extn.Service_Order_Id__c = wo.Id;        
        extn.FaultCodeId__c=fcode.id;
        update extn;
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=extn.FaultCodeId__c;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        // Test.startTest();
        CSS_Solutions__c csol= new CSS_Solutions__c();
        csol.Name='T00000691';
        sol.FSL_Service_Job__c = wo.Id;
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=extn.FaultCodeId__c;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        insert csol;
        List<CSS_Solution_Component__c> solcmps=new List<CSS_Solution_Component__c>();
        solcmps.add(new CSS_Solution_Component__c(Solutions__c=csol.id, Fault_Code__c='test123'));
        solcmps.add(new CSS_Solution_Component__c(Solutions__c=csol.id, Fault_Code__c='test12344'));
        insert solcmps;
        List<CSS_Parts_Options__c> solpart =new List<CSS_Parts_Options__c>();
        solpart.add(new CSS_Parts_Options__c(Solutions__c=sol.id, FailurepartId__c=solcmps[0].id));
        solpart.add(new CSS_Parts_Options__c(Solutions__c=sol.id, FailurepartId__c=solcmps[1].id));
        insert solpart;
        List<FSL_Parts__c> fslParts = new List<FSL_Parts__c>();
        
        
        fslParts.add(new FSL_Parts__c(Solution__c = csol.id, CSS_Solution_Component__c = solcmps[0].id, Service_Order__c=wo.Id));
        //fslParts.add(new FSL_Parts__c(Solution__c = csol1.id, CSS_Solution_Component__c = solcmps1[0].id,Service_Order__c=wo.Id));
        insert fslParts;
        
        Knowledge__kav kv= new Knowledge__kav();
        list<Knowledge__kav> kList = new list<Knowledge__kav>();
        kv.Verification__c='abc';
        kv.Repairs__c='*#SnNo#*';
        kv.UrlName=sol.Name;
        kv.Title=sol.Solution_Title__c;
        kList.add(kv);
        insert kList;
        
        knowledge__kav obj1 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: kList[0].Id];
        KbManagement.PublishingService.publishArticle(obj1.KnowledgeArticleId, true);
        FSL_CL_RepairDisplaySolution.getknowledge(sol.Id);
        FSL_CL_RepairDisplaySolution.getSolknowledge(wo.Id);
        //FSL_CL_RepairDisplaySolution.continueToRepair(wo.id,sol.id);
        FSL_CL_RepairDisplaySolution.getjobordernumber(wo.id);
        FSL_CL_RepairDisplaySolution.solUpdate(sol.id, 'Most likely the solution. Repair recommended.', 'Repair Successful.', wo.id, new List<String>{solcmps[0].id}, 
                                               new List<String>{solcmps[1].id},
                                               new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, fslParts[0].id, true)}, 
                                               new List<FSLSolCompWrappers.CSSCompPartOptionsWrp>{new FSLSolCompWrappers.CSSCompPartOptionsWrp('testpart1', '', 123, fslParts[0].id, true)},
                                               new List<FSLSolCompWrappers.CSSCompsWrp>());
        //FSL_CL_RepairDisplaySolution.insertSelectedRootCauseOnSol(sol.id, new list<Id>{solcmps[0].id}, sol.Id);
        FSL_CL_RepairDisplaySolution.insertViewedSolutionOnRepair(sol.id, wo.Id);
        FSL_CL_RepairDisplaySolution.insertPerformedRepairAuditEvent('','','','');//String cssSolutionId, String repairRadio, String comments,String solId
       // FSL_CL_RepairDisplaySolution.getFCOverview(wo.Id);
        FSL_CL_RepairDisplaySolution.fetchFCSolData(wo.Id);
        Test.stopTest();
    }
    
}