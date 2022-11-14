@isTest
public class EVL_DX_UpdateCampaigns_Test {
     @isTest static void testCallout1() {
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
        //SerRec.CSS_Job_Location_Code__c = '03520-04892';
        Insert SerRec;
                
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
        // from the class that implements HttpCalloutMock
        List<id> solCmpIds = new List<id>();
        List<css_solution_component__c> solList = [SELECT Id, Type__c, Component_Id__c, System_Code__c, Component_Code__c, AccountCode__c, FSL_Service_Order__c, FSL_Service_Order__r.ServiceTerritory.Location_Code__c, FSL_Service_Order__r.Application__c, FSL_Service_Order__r.Asset.Name, FSL_Service_Order__r.Asset.Service_Model__c, FSL_Service_Order__r.Asset.Equipment_Id__c, FSL_Service_Order__r.Asset.Engine_Family_Code__c, FSL_Service_Order__r.Failure_Date__c, FSL_Service_Order__r.Mileage__c, FSL_Service_Order__r.Mileage_Measure__c, FSL_Service_Order__r.Warranty_Start_Date__c FROM CSS_Solution_Component__c WHERE Id =: AddsolComp.id];
        system.debug('solList**'+solList);
        String strCSSComp = JSON.serialize(lstCSS);
        system.debug('strCSSComp**'+strCSSComp);
       // FSLFieldActionsServices.fieldactionsrt(strCSSComp);
        solCmpIds.add(lstCSS[0].id);
        test.starttest();  
        Test.setMock(HttpCalloutMock.class, new FSLSrtFieldActionMock());
        test.stoptest();
        EVL_DX_UpdateCampaigns updater = new EVL_DX_UpdateCampaigns(solCmpIds);
        System.enqueueJob(updater);
        
    }

}