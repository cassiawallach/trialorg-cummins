@isTest
public class FSLFieldActionsServices_Test {  
    
    @isTest static void testCallout1() {
        // Set mock callout Test class 
        // Test.setMock(HttpCalloutMock.class, new FSLFaultCodeTokenMock());
        Test.setMock(HttpCalloutMock.class, new FSLFailModeMockToken());
        set<id> setCSS = new set<id>();
        list<CSS_Solution_Component__c> lstCSS = new list<CSS_Solution_Component__c>();
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OAGOAuth';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://services-stg-oauth.cummins.com/api/oauth/token/css ';
        csInt.AuthEnv__c='';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c = '20f56d87-8e65-46ce-9649-85d7c9335db7';
        csInt.Passcode__c = 'd95d65da-f878-489a-aa1e-20919269cc19';
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c csInt1 = new CSS_Integration_Details__c();
        csInt1.name = 'CSS_SBL_WarrantyDetailCoverage';
        csInt1.ApplicationName__c='SRT';
        csInt1.End_Point__c='https://services-test.cummins.com/csswarranty/accodecoverage';
        csInt1.AuthEnv__c='OAGOAuth';
        csInt1.Method_Type__c='POST';
        csInt1.Timeout__c=120000;
        csInt1.Key__c = '20f56d87-8e65-46ce-9649-85d7c9335db7';
        csInt1.Passcode__c = 'd95d65da-f878-489a-aa1e-20919269cc19';
        csInt1.IsActive__c=true;
        insert csint1;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.IsActive=true;
        insert sT;
        
        Asset ast = new Asset();
        ast.Name='79464647';
        ast.Type_PSN__c = 'Engines-79464647';
        ast.Type__c = 'Engines';
        insert ast;
        
        Date d = Date.Today();
        WorkOrder SerRec = new WorkORder();
        SerRec.DSID__c='12345';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d; 
        SerRec.ESN__c = '79464647';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        //SerRec.CSS_Job_Location_Code__c = '03520-04892';
        Insert SerRec;
        
        
        //  WO = FSL_TestDataUtility.createWorkOrder(null, null);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        // sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        // sol.Diagnostic_Response__c='test';
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        //sol.Symptom__c=sym.id;
        sol.FSL_Service_Job__c =SerRec.Id;
        insert sol;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        // sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        // sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'ans';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        insert sym;
        
        /* CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
srtComp.Solutions__c = sol.id;
srtComp.Quantity__c = 1;
srtComp.Action__c = 'asdsad';
//   srtComp.Service_Job__c =jo.id;
srtComp.Selected_Component__c = true;
lstCSS.add(srtComp);
insert lstCSS; */
        
        
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Solution = CSS_TestData.createSolutions(true,Job.id);
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = SerRec.Id;
        AddsolComp.FSL_Service_Order__c  = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = Solution.id;
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
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Activity__c = 'Test'+Math.random();
        AddsolComp.Performed_Review__c  = false;
        insert AddsolComp;
        lstCSS.add(AddsolComp);
         //insert lstCSS;
        
        AddsolComp.Performed_Review__c  = True;  
        //update AddsolComp;//commented
        SerRec.Field_Actions__c = AddsolComp.id;
        SerRec.Id = SerRec.Id;
        //update SerRec;//commented
        setCSS.add(lstCSS[0].id);
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.\
        List<css_solution_component__c> solList = [SELECT Id, Type__c, Component_Id__c, System_Code__c, Component_Code__c, AccountCode__c, FSL_Service_Order__c, FSL_Service_Order__r.ServiceTerritory.Location_Code__c, FSL_Service_Order__r.Application__c, FSL_Service_Order__r.Asset.Name, FSL_Service_Order__r.Asset.Service_Model__c, FSL_Service_Order__r.Asset.Equipment_Id__c, FSL_Service_Order__r.Asset.Engine_Family_Code__c, FSL_Service_Order__r.Failure_Date__c, FSL_Service_Order__r.Mileage__c, FSL_Service_Order__r.Mileage_Measure__c, FSL_Service_Order__r.Warranty_Start_Date__c FROM CSS_Solution_Component__c WHERE Id =: AddsolComp.id];
        system.debug('solList**'+solList);
        String strCSSComp = JSON.serialize(lstCSS);
        system.debug('strCSSComp**'+strCSSComp);
        FSLFieldActionsServices.fieldactionsrt(strCSSComp);
        
        test.starttest();  
        Test.setMock(HttpCalloutMock.class, new FSLSrtFieldActionMock());
        system.debug('setCSS**'+setCSS);
        FSLFieldActionsServices.fieldactionsrtwebservices(setCSS);
        List<Id> lstId = new List<Id>();
        lstId.add(lstCSS[0].id);
        //FSLFieldActionsServices.actionsfor4csforRemoval(lstId); //commented
        // 
        test.stoptest();
        FSLFieldActionswrapper.cls_FieldActionSRTTime fr = new FSLFieldActionswrapper.cls_FieldActionSRTTime(); 
        fr.SRTDetails = 'Test';
        fr.SRTAccessCode = 'Test';
        fr.Assignment = 'Test';
        fr.SRTQuantity = 10;
        fr.Type = 'Test';      
        FSLFieldActionswrapper.cls_FieldAction dr = new FSLFieldActionswrapper.cls_FieldAction();
        dr.FieldActionNumber = '1609';
        dr.FieldActionType = 'TRP';
        FSLFieldActionswrapper.cls_Header ar = new FSLFieldActionswrapper.cls_Header();
        ar.Status = 'Test';
        ar.ReturnCode = 'ORA-00000';
        ar.ReturnCodeDescription ='Test';
        ar.MessageIdentifier ='s';
        ar.FieldActionNumber ='1608';
        
        String json= '{ "Header": { "Target": { "TargetID": "SRT" }, "Sender": { "ServiceName": "GetFieldActionSRTs","SenderID": "SF","MessageID": "MID123456786" }}, "DataArea": { "ServiceModelName": "ISX15 CM2350 X101","Language": "en","FieldAction": [{ "SRTTab": null, "FieldActionType": "TRP", "FieldActionNumber": "1609"},{ "SRTTab":null,"FieldActionType": "TRP","FieldActionNumber": "1603"}],"EquipmentID": "EQ2564","EngineFamilyCode": "10","EffectiveDTTime": "2019-02-19T06:42:15", "DTTimestamp": "2019-02-19T06:42:15" }}';
        
        FSLfieldactionRequest.parse(json);
        FSLFieldActionswrapper.parse(json);
        delete lstCSS[0];
    }
    
    @isTest static void testCallout2() {
        // Set mock callout class 
        // Test.setMock(HttpCalloutMock.class, new FSLFaultCodeTokenMock());
        Test.setMock(HttpCalloutMock.class, new FSLFailModeMockToken());
        set<id> setCSS = new set<id>();
        list<CSS_Solution_Component__c> lstCSS = new list<CSS_Solution_Component__c>();
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OAGOAuth';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://services-stg-oauth.cummins.com/api/oauth/token/css ';
        csInt.AuthEnv__c='';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c = '20f56d87-8e65-46ce-9649-85d7c9335db7';
        csInt.Passcode__c = 'd95d65da-f878-489a-aa1e-20919269cc19';
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c csInt1 = new CSS_Integration_Details__c();
        csInt1.name = 'CSS_SBL_WarrantyDetailCoverage';
        csInt1.ApplicationName__c='SRT';
        csInt1.End_Point__c='https://services-test.cummins.com/csswarranty/accodecoverage';
        csInt1.AuthEnv__c='OAGOAuth';
        csInt1.Method_Type__c='POST';
        csInt1.Timeout__c=120000;
        csInt1.Key__c = '20f56d87-8e65-46ce-9649-85d7c9335db7';
        csInt1.Passcode__c = 'd95d65da-f878-489a-aa1e-20919269cc19';
        csInt1.IsActive__c=true;
        insert csint1;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.IsActive=true;
        insert sT;
        
        Asset ast = new Asset();
        ast.Name='79464647';
        ast.Type_PSN__c = 'Engines-79464647';
        ast.Type__c = 'Engines';
        insert ast;
        
        Date d = Date.Today();
        WorkOrder SerRec = new WorkORder();
        SerRec.DSID__c='12345';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d; 
        SerRec.ESN__c = '79464647';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        SerRec.Status = 'Repair';
        SerRec.Process_Step__c = 'Repair';
        //SerRec.CSS_Job_Location_Code__c = '03520-04892';
        Insert SerRec;
        
        
        //  WO = FSL_TestDataUtility.createWorkOrder(null, null);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        // sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        // sol.Diagnostic_Response__c='test';
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        //sol.Symptom__c=sym.id;
        sol.FSL_Service_Job__c =SerRec.Id;
        insert sol;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        // sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        // sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'ans';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        insert sym;
        
        /* CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
srtComp.Solutions__c = sol.id;
srtComp.Quantity__c = 1;
srtComp.Action__c = 'asdsad';
//   srtComp.Service_Job__c =jo.id;
srtComp.Selected_Component__c = true;
lstCSS.add(srtComp);
insert lstCSS; */
        
        
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Solution = CSS_TestData.createSolutions(true,Job.id);
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = SerRec.Id;
        AddsolComp.FSL_Service_Order__c  = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = Solution.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Type__c='CAMPAIGN';
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
       // AddsolComp.CSS_Claims__c = '';
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Activity__c = 'Test'+Math.random();
        AddsolComp.Performed_Review__c  = false;
        insert AddsolComp;
        WorkOrder wo = [SELECT Id, Status, Process_Step__c FROM WorkOrder WHERE Id=: SerRec.Id LIMIT 1];

        FSL_Parts__c part = new FSL_Parts__c();
        part.Name = '1122';
        part.CSS_Solution_Component__c = AddsolComp.id;
        part.Service_Order__c = wo.Id;
        insert part;
        
        AddsolComp.Performed_Review__c  = true;
        AddsolComp.FSL_Service_Job__c = wo.Id;
       	AddsolComp.Type__c = 'TRP';
        update AddsolComp;
        lstCSS.add(AddsolComp);
        
        List<Id> solIdsList = new List<Id>();
        List<Id> solIdsList1 = new List<Id>();
        List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();

        Id solId = AddsolComp.Id;
        CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c(FSL_Service_Job__c = SerRec.Id, Component_Id__c = 'testCmp', Solutions__c = sol.Id);
        insert solCmp;
        solIdsList1.add(solCmp.Id);
        solComp.add(solCmp);
        
        FSLFieldActionsServices.updateFACounts(lstCSS); //updateFACounts
        FSLFieldActionsServices.updatePerformed(lstCSS); //updatePerformed
        FSLFieldActionsServices.actionsfor4cs(solIdsList); //actionsfor4cs
        FSLFieldActionsServices.actionsfor4csforRemoval(solIdsList1); //actionsfor4csforRemoval
        delete lstCSS[0];
        /*CSS_Solution_Component__c solObjNew = [Select Id, Performed_Review__c from CSS_Solution_Component__c where Id=:solId];
        solObjNew.Performed_Review__c  = True;  
        update solObjNew;*/
        //Test Data
        
    }
    
    
    
    
    
}