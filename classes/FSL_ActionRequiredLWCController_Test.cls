@isTest
Private class FSL_ActionRequiredLWCController_Test{
    
    static testMethod void ActionRequiredLWCControllermethod(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='9895634567';
        con.Email='av456@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
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
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c = '';
        insert asst;
        
        
        
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId=sT.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=asst.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.FaultCodeId__c='1167';
        wo.Process_Step__c = 'Repair';
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Shop_Work_Order__c = 'test';
        wo.Mileage__c = null;
        wo.CSS_Hours__c = null;
        wo.Mileage_Measure__c = 'Miles';
        wo.Service_Model__c = 'New';
        wo.Status = 'Intake';
        WorkOrderList.add(wo);
        
        WorkOrder wo1 = new WorkOrder();
        wo1.ServiceTerritoryId=sT.id;
        wo1.AccountId=acc.id;
        wo1.ContactId=con.id;
        wo1.Repair_Location__c='In Shop';
        wo1.AssetId=asst.id;
        wo1.Available_for_Service__c=datetime.now()+3;
        wo1.SelectedSolution__c='abc';
        wo1.FaultCodeId__c='1167';
        wo1.Process_Step__c = 'Repair';
        wo1.Category1__c = 'Leak';
        wo1.Complaint_Type1__c='Air Leak';
        wo1.Shop_Work_Order__c = 'test';
        wo1.Mileage__c = 2232.21;
        wo1.CSS_Hours__c = 202;
        wo1.Mileage_Measure__c = 'MILES';
        wo1.Service_Model__c = 'New';
        wo1.Status = 'Repair';
        WorkOrderList.add(wo1);
        insert WorkOrderList;
        
        FSL_ActionRequiredLWCController ActionRequiredLWC = new FSL_ActionRequiredLWCController();
        FSL_ActionRequiredLWCController.getWorkOrders();
        
    }
}