@isTest
public class FSL_SMNTriggerHandler_Test {
     @isTest 
    public static void test() 
    {
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
        con.Phone='1234567890';
        con.AccountId=acc.id;
        //con.FSL_Contact_Id__c= con.Id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        st.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        asst.Service_Model__c = 'ISB CM2150';
        insert asst;
       
        FSL_SMN_DTC__c sm = new FSL_SMN_DTC__c();
        sm.Name = asst.Service_Model__c;
        sm.FaultTypeFC__c = 'No';
        insert sm;
        
        
        List<WorkOrder> woInfo    = new List<WorkOrder>();
         woInfo = [SELECT id, Asset.Name,Asset.Service_Model__c from WorkOrder WHERE AssetId =: asst.id];
        
        WorkOrder wo = new WorkOrder();
        wo.AssetId      = asst.Id;
        wo.AccountId    = acc.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'Intake';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        wo.ContactId = con.Id;
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        wo.Repair_Location__c = 'Mobile';
      //  wo.FSL_SMN__c =;
        woInfo.add(wo);
          
        insert woInfo;
        
        List<workorder> woInfo1 = new List<workorder>();
        workorder wo2 = new workorder();
        wo2.id = woInfo[0].id;
        wo2.EditComplaint__c = 'Testing Info';
        wo2.EditCause__c = 'Testing Info';
        wo2.EditCorrection__c = 'Testing Info';
        wo2.EditCoverage__c = 'Testing Info1';
        wo2.ServiceTerritoryid = sT.id;
        woInfo1.add(wo2);
        
        update woInfo1;
        
        List<FSL_Failure__c> fc1 = new List<FSL_Failure__c>();
        FSL_Failure__c fc = new FSL_Failure__c();
        fc.Name = 'test';
        fc.Service_Model_Name__c = 'CM2350';
        fc1.add(fc);
        insert fc1;
        
        List<FSL_Failure__c> fcList = new List<FSL_Failure__c>();
        FSL_Failure__c fc2 = new FSL_Failure__c();
        fc2.Name = 'test';
        fc2.Service_Model_Name__c = 'CM2350';
        fcList.add(fc);
        update fcList;
        
         Map<id,FSL_Failure__c> fcInfoTest = new Map<id,FSL_Failure__c>();
        
        fcInfoTest.put(fc1[0].id,fc1[0]);
        
         Map<id,FSL_Failure__c> fcInfoTest1 = new Map<id,FSL_Failure__c>();
        
        fcInfoTest1.put(fcList[0].id,fcList[0]);
        
       
        FSL_SMNTriggerHandler so = new FSL_SMNTriggerHandler();
        so.BeforeInsert(fc1);
        so.BeforeUpdate(fcInfoTest, fcInfoTest1);
    }

}