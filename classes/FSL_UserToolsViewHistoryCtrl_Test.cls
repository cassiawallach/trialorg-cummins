//Adding comment for deployment -- Akansha MV_688 8/25/2022

// Adding Comment for deploying changes --- Sriprada
@isTest
public class FSL_UserToolsViewHistoryCtrl_Test {
    
    static testMethod void test1111() {
        
        // FSL_IntakeViewHistoryCtrl vh = new FSL_IntakeViewHistoryCtrl();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        List<ServiceTerritory> stList = new List<ServiceTerritory>();
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'Test ServiceTerritory Parent';
        sT.IsActive = true;
        sT.Location_Code__c = '01234-01235';
        sT.FSL_Service_Territory_Code__c = '01235';
        sT.OperatingHoursId = oh.Id;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.Type__c =  'Group';
        stList.add(sT);
        
        sT = new ServiceTerritory();
        sT.Name = 'Test ServiceTerritory Mobile';
        sT.IsActive = true;
        sT.Location_Code__c = '01234-01234';
        sT.FSL_Service_Territory_Code__c = '01234';
        sT.OperatingHoursId = oh.Id;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        st.ParentTerritoryId = stList[0].Id;
        sT.Type__c =  'DISTRIBUTOR-BRANCH';
        stList.add(sT);
        insert stList;
        
        FSL__User_Territory__c ut = new FSL__User_Territory__c();
        ut.FSL__User__c = UserInfo.getUserId();
        ut.FSL__ServiceTerritory__c = stList[0].Id;
        insert ut;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c='Engines-79704393';
        asst.Type__c = 'Engines';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = stList[1].Id;
        wo.Available_for_Service__c = datetime.now()+3;
        wo.Status       = 'Closed';
        // wo.Category1__c = 'Leak';
        // wo.Complaint_Type1__c = 'COOLANT LOSS - OVERFLOW';        
        wo.Shop_Work_Order__c = '12345';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId 	= recdtypeId; 
        wo.createdDate=system.now().addDays(-29);
        insert wo;
        
        /*
        FSL_IntakeViewHistoryCtrl.assetName = '79704393';
        FSL_IntakeViewHistoryCtrl.createdDate = System.now();
        FSL_IntakeViewHistoryCtrl.jobId = System.now();
        FSL_IntakeViewHistoryCtrl.sLocation = System.now();
        */
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', wo.Id);
        FSL_UserToolsViewHistoryCtrl vh = new FSL_UserToolsViewHistoryCtrl();
        vh.workOrderId = wo.Id;
        Test.stopTest();
    }
    
    static testMethod void test2() {
      user u = [select Id, username,User_Location__c,ERP__c,IAM_Distributorbranchcode__c,IAM_Distributorcode__c,FSL_Primary_Service_Territory_Code__c from User where ERP__c ='BMS' LIMIT 1];
        user u2 = [select id from user where id=: UserInfo.getUserId()];
        // FSL_IntakeViewHistoryCtrl vh = new FSL_IntakeViewHistoryCtrl();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        
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
        sT.Name = 'Test ServiceTerritory Mobile';
        sT.IsActive = true;
        sT.Location_Code__c = '01234-01234';
        sT.FSL_Service_Territory_Code__c = '01234';
        sT.OperatingHoursId = oh.Id;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.Type__c =  'DISTRIBUTOR-BRANCH';
        insert st;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c='Engines-79704393';
        asst.Type__c = 'Engines';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = st.Id;
        wo.Available_for_Service__c = datetime.now()+3;
        wo.Status       = 'Closed';
        // wo.Category1__c = 'Leak';
        // wo.Complaint_Type1__c = 'COOLANT LOSS - OVERFLOW';        
        wo.Shop_Work_Order__c = '12345';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId 	= recdtypeId; 
        wo.createdDate=system.now().addDays(-29);
        insert wo;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = TestUtility.newJobOrder();
        insert JO;
        
        /*
        FSL_IntakeViewHistoryCtrl.assetName = '79704393';
        FSL_IntakeViewHistoryCtrl.createdDate = System.now();
        FSL_IntakeViewHistoryCtrl.jobId = System.now();
        FSL_IntakeViewHistoryCtrl.sLocation = System.now();
        */
        system.runAs(u){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', wo.Id);
        FSL_UserToolsViewHistoryCtrl vh = new FSL_UserToolsViewHistoryCtrl();
        vh.workOrderId = wo.Id;
        Test.stopTest();
        }
    }
}