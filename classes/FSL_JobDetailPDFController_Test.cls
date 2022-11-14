//Adding comment for deployment- Sriprada
@isTest
public class FSL_JobDetailPDFController_Test {
    static testMethod void test1()
    {
        Test.startTest();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = 'SC102';
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
        //wo.Status       = 'closed';
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
        accCode.Name = '65';
        insert accCode;
        
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = 'test';
        fcObj.Primary_Fault_Code__c = 6;
        //  fcObj.Job_Order__c = cjo.Id;
        fcObj.isPole__c = true;
        fcObj.Service_Order__c = wo.Id;
        //fcObj.Job_Order__c = cjo.Id;
        fcObj.PoleMessage__c = true;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';       
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-29);
        Insert fcObj;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Service_Order__c=wo.id;
        sym.Name = 'Black Smoke';
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.createdDate=system.now().addDays(-29);
        insert sym;
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.Repair_Notes__c='test';
        // sol.Symptom__c=sym.id;
        // sol.Service_Job__c=cjo.id;
        sol.FaultCode__c = fcObj.id;
        sol.FSL_Service_Job__c=wo.id;
        sol.FaultCode__c = fcObj.Id;
        sol.createdDate=system.now().addDays(-29);   
        insert sol;
        
        CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
        solCon.name = 'test';
        solCon.Component_Id__c = '123';
        solCon.System_Code__c = '68';
        solCon.Component_Code__c = '12';
        solCon.AccountCode__c = '1245';
        solCon.Account_Code__c= accCode.Id;
        solCon.FSL_Service_Job__c = wo.Id;
        solCon.RoadRelay_Warranty__c='No';
        solCon.Fault_Code__c = '123';
        solCon.Selected_Component__c = true;
        insert solCon;
        
        ApexPages.currentPage().getParameters().put('id',wo.Id); 
        FSL_JobDetailPDFController readonly = new FSL_JobDetailPDFController();
        readonly.currentDate = system.Now();
        readonly.jobId=wo.Id;
        
        //FSL_JobDetailPDFController readonlyview = new FSL_JobDetailPDFController();
        readonly.getDtStart();
        DateTime dInputDate = system.Now();
        Test.stopTest();
    }
}