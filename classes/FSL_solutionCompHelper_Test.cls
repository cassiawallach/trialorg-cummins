//Adding Comment for Deployment -- Sriprada
//Comment added for deployment - Jan 2022 Release
@isTest
public class FSL_solutionCompHelper_Test {
    
    
    
    
    @isTest static void testCallout3() {
        
        
        
        list<CSS_Solution_Component__c> lstCSS = new list<CSS_Solution_Component__c>();
        
        
        OperatingHours  oh = new OperatingHours (); 
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
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
        SerRec.Customer_Name__c='Test Customer';
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
        
        insert AddsolComp;
        
        test.starttest();
        
        
        //   ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        //Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, acc, st);
        WorkOrder wo =  new WorkOrder();
        // SerRec = CSS_TestData.createJobOrder(false);
        
        wo.DSID__c='12345';
        // SerRec.DSID_Status__c='open';
        //SerRec.ESN__c ='79464647';
        wo.Customer_Name__c='ABC';
        wo.Failure_Date__c =d;
        wo.Service_Model__c='ESN';
        wo.Make__c='test';
        wo.Model__c='test1';
        wo.Customer_Name__c='Sam Torq';
        wo.Warranty_Start_Date__c=d;
        wo.ESN__c = '';
        wo.Mileage__c = 12345;
        wo.Mileage_measure__c = 'Miles';
        wo.ServiceTerritoryId = sT.Id;
        wo.AssetId = ast.id;
        
        Insert wo;    
        
        FSL_SRT__c fsr = new FSL_SRT__c(Solution_Number__c=sol.id,Service_Order__c=wo.id,SRT_Type__c='Diag Access',
                                        SRT_Title__c='Exhaust System Diagnostics - Contamination/Incorrect Fluid',Component_Id__c =AddsolComp.id);
        insert fsr;
        
        Delete AddsolComp;
        test.stoptest();
    }
    
    
    @isTest static void testCallout34() {
        
        
        
        list<CSS_Solution_Component__c> lstCSS = new list<CSS_Solution_Component__c>();
        
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
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
        
        FSL_Account_Code__c ac = new FSL_Account_Code__c();
        ac.Account_Code_Description__c = 'abc';
        ac.Name = '123';
        ac.Coverage_Type__c = 'cap';
        insert ac;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = Solution.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = '123';
        AddsolComp.Account_Code__c = ac.id;
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
        //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        
        insert AddsolComp;
        
    }
    
    static testMethod void test1()
    {
        // FSL_workorderListTriggerHandle.avoidAfterupdate = true;
        // FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        // wo.Failure_Date__c = system.now().addDays(-29);
        
        insert wo;
        
        FSL_Account_Code__c accCode = new FSL_Account_Code__c();
        accCode.Account_Code_Description__c = 'test';
        accCode.Name = 'NEW PARTS WARRANTY - 62';
        insert accCode;
        
        CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
        solCon.name = 'test';
        solCon.Component_Id__c = '123';
        solCon.System_Code__c = '68';
        solCon.Component_Code__c = '12';
        solCon.AccountCode__c = '1245';
        solCon.Account_Code__c= accCode.Id;
        solCon.FSL_Account_Code__c = 'NEW PARTS WARRANTY - 62';
        solCon.FSL_Service_Job__c = wo.Id;
        solCon.RoadRelay_Warranty__c='No';
        solCon.Fault_Code__c = '123';
        solCon.Selected_Component__c = true;
        
        insert solCon;
        
        //Added:CT3-277 -- Charan Teja
        solCon.FSL_Account_Code__c = 'DISTRIBUTOR WARRANTY - DW';
        update solCon;
        
        
        //Test Data
        
        
        
    }
    static testMethod void testTrigger()
    {
        // FSL_workorderListTriggerHandle.avoidAfterupdate = true;
        // FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        // wo.Failure_Date__c = system.now().addDays(-29);
        
        insert wo;
        
        FSL_Account_Code__c accCode = new FSL_Account_Code__c();
        accCode.Account_Code_Description__c = 'test';
        accCode.Name = 'NEW PARTS WARRANTY - 62';
        insert accCode;
        
        CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
        solCon.name = 'test';
        solCon.Component_Id__c = '123';
        solCon.System_Code__c = '68';
        solCon.Component_Code__c = '12';
        solCon.AccountCode__c = '1245';
        solCon.Account_Code__c= accCode.Id;
        solCon.FSL_Account_Code__c = 'NEW PARTS WARRANTY - 62';
        solCon.FSL_Service_Job__c = wo.Id;
        solCon.RoadRelay_Warranty__c='No';
        solCon.Fault_Code__c = '123';
        solCon.Selected_Component__c = true;
        solCon.Performed_Review__c = TRUE;
        solCon.Performed__c = TRUE;
        insert solCon;
        
        try{
            //Added:CT3-277 -- Charan Teja
            solCon.FSL_Account_Code__c = 'DISTRIBUTOR WARRANTY - DW';
            solCon.Performed_Review__c = False;
            //solCon.EVL_DX_Service_Order__c = wo.Id;
            solCon.Performed__c = False;
            update solCon;
        }
        Catch(Exception e){
            
        }
    }
    
    static testMethod void testTrigger1()
    {
        // FSL_workorderListTriggerHandle.avoidAfterupdate = true;
        // FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        // wo.Failure_Date__c = system.now().addDays(-29);
        
        insert wo;
        
        FSL_Account_Code__c accCode = new FSL_Account_Code__c();
        accCode.Account_Code_Description__c = 'test';
        accCode.Name = 'NEW PARTS WARRANTY - 62';
        insert accCode;
        
        CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
        solCon.name = 'test';
        solCon.Component_Id__c = '123';
        solCon.System_Code__c = '68';
        solCon.Component_Code__c = '12';
        solCon.AccountCode__c = '1245';
        solCon.Account_Code__c= accCode.Id;
        solCon.FSL_Account_Code__c = 'NEW PARTS WARRANTY - 62';
        solCon.FSL_Service_Job__c = wo.Id;
        solCon.RoadRelay_Warranty__c='No';
        solCon.Fault_Code__c = '123';
        solCon.Selected_Component__c = true;
        solCon.Performed_Review__c = TRUE;
        solCon.Performed__c = TRUE;
        
        insert solCon;
        
        //try{
        //Added:CT3-277 -- Charan Teja
        solCon.FSL_Account_Code__c = 'DISTRIBUTOR WARRANTY - DW';
        //solCon.EVL_DX_Service_Order__c = wo.Id;
        solCon.Performed_Review__c = FALSE;
        solCon.Performed__c = false;
        update solCon;
        
        
    }
    
    static testMethod void testTrigger2()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;  
        System.runAs(newUser){
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            insert acc;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT = new ServiceTerritory(); 
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '05340-05351';
            sT.FSL_Service_Territory_Code__c = '05351';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            Asset asst = new Asset();
            asst.Name = '79704393';
            asst.Type_PSN__c = 'Engines-79704393';
            insert asst;
            
            WorkOrder wo    = new WorkOrder();
            wo.AccountId    = acc.Id;
            wo.AssetId      = asst.Id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Status       = 'closed';
            wo.Category1__c = 'Leak';
            wo.Process_Step__c = 'Intake';
            //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
            wo.Shop_Work_Order__c = 'test';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.createdDate=system.now().addDays(-29);
            // wo.Failure_Date__c = system.now().addDays(-29);
            
            insert wo;
            
            FSL_Account_Code__c accCode = new FSL_Account_Code__c();
            accCode.Account_Code_Description__c = 'test';
            accCode.Name = 'NEW PARTS WARRANTY - 62';
            insert accCode;
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            cjo.Customer_Name__c = 'Wonder Trucks';
            cjo.Assigned_To__c=newUser.id;
            cjo.Additional_Tech1__c=newUser.id;
            cjo.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Closed';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            cjo.createdDate=system.now().addDays(-9);
            // cjo.createdBy.User_Location__c= '05340-05351';
            cjo.Shop_Work_Order__c='abcd';
            // cjo.dField='Visible';
            cjo.ESN__c='79704393';
            cjo.Category__c = 'Leak';
            cjo.Complaint_Type__c='Air Leak';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Mileage__c=9.9;
            cjo.Mileage_Measure__c='Miles';
            cjo.Service_Model__c='werwe';
            insert cjo;
            
            CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
            solCon.name = 'test';
            solCon.Component_Id__c = '123';
            solCon.System_Code__c = '68';
            solCon.Component_Code__c = '12';
            solCon.AccountCode__c = '1245';
            solCon.Account_Code__c= accCode.Id;
            solCon.FSL_Account_Code__c = 'NEW PARTS WARRANTY - 62';
            solCon.FSL_Service_Job__c = wo.Id;
            solCon.RoadRelay_Warranty__c='No';
            solCon.Fault_Code__c = '123';
            solCon.Selected_Component__c = true;
            solCon.Performed_Review__c = TRUE;
            solCon.Performed__c = TRUE;
            solCon.Service_Job__c  = cjo.Id;
            
            insert solCon;   
            
            delete solCon;
        }
    }
}