@isTest
public class FSL_getDetailCoverage_Test {
    
    static testMethod void test1() {
    
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Dummy Account ';
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
        accCode.Name = '65';
        insert accCode;
        
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
        
        Test.setMock(HttpCalloutMock.class, new FSL_getDetailCoverage_TestMock());
        test.startTest();
        FSL_getDetailCoverage.getSolutionCoverage(solCon.id);	
        system.debug('solution id:'+solCon.id);
        FSL_getDetailCoverage.checkCoverage(solCon);
        system.debug('Solution:'+solCon);
        test.stopTest();
    }
}