@IsTest(SeeAllData=true)
Private class FSL_ServiceOrderRecentVisit_Test {
    
    static testMethod void FSL_serviceOrderRecentVisit_Method() {
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest()); 
        //  Test.setMock(HttpCalloutMock.class, new CSS_ESNHistory_Test()); 
        // Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        // createTestUser
        WorkOrder SerRec =  new WorkOrder();
        
        Account acc = new Account();
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-T2851';
        sT.FSL_Service_Territory_Code__c = 'T2851';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.IsActive=true;
        insert sT;
        
        Asset ast = new Asset();
        ast.Name='794646471';
        ast.Type_PSN__c = 'Engines-794646471';
        insert ast;
        
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d; 
        SerRec.ESN__c = '794646471';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        //SerRec.CSS_Job_Location_Code__c = '03520-04892';
        Insert SerRec;
        Map<Id,WorkOrder> jOrd = new Map<Id,WorkOrder>();
        jOrd.put(SerRec.id,SerRec);
        WorkOrder cjb = [select id from WorkOrder where id =:SerRec.id];
        cjb.AssetId = SerRec.AssetId;
        //cjb.Make__c='test123';
        update cjb;
        List<WorkOrder> jobOrder = new List<WorkOrder>();
        //jobOrder.add(cjb);
        jobOrder.add(SerRec);
        system.debug(SerRec); 
        // FSL_ServiceOrderRecentVisit recV= new FSL_ServiceOrderRecentVisit();
        
        test.startTest();
        set<id> esnList = new set<id>();
        esnList.add(ast.id);
        List<WorkOrder> lstWO = [SELECT Id, RecentVisit__c, CreatedDate,AssetId, Asset.Name FROM WorkOrder WHERE AssetId IN : esnList AND Asset.Name != null];
        system.debug('lstWO :: '+lstWO);
        FSL_ServiceOrderRecentVisit.recentVisitFlag(jobOrder,jOrd);
        SerRec.Customer_Name__c='test';
        update SerRec;
        test.stopTest();
        
    }
    
    static Testmethod void FSL_serviceJobRecentVisit_Method2() {
        
        Account acc = new Account();
        acc.Name = 'Test Account ';
        insert acc;
        
        Contact con=new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-T2851';
        sT.FSL_Service_Territory_Code__c = 'T2851';
        sT.IsActive=true;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        Asset ast = new Asset();
        ast.Name = 'yueiirourr';
        ast.Type_PSN__c = 'Engines-yueiirourr';
        insert ast;
        
        Asset ast1 = new Asset();
        ast1.Name = 'jkdiawpqeuwq';
        ast1.Type_PSN__c = 'Engines-jkdiawpqeuwq';
        insert ast1;
        
        WorkOrder SerRec =  new WorkOrder();
        // SerRec = CSS_TestData.createJobOrder(false);
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        // SerRec.DSID_Status__c='open';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.ESN__c = '';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles';
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        
        Insert SerRec; 
        test.startTest();
        Map<Id,WorkOrder> jOrd = new Map<Id,WorkOrder>();
        jOrd.put(SerRec.id,SerRec);
        SerRec.AssetId =null;
        update SerRec;
        List<WorkOrder> jobOrder = new List<WorkOrder>();
        jobOrder.add(SerRec);
        system.debug(SerRec); 
        
        FSL_ServiceOrderRecentVisit.recentVisitFlag(jobOrder,jOrd);
        test.stopTest();
    }
    
    static Testmethod void FSL_serviceJobRecentVisit_Method3() {
        Account acc = new Account();
        acc.Name = 'Test Account ';
        insert acc;
        
        Contact con=new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-T2851';
        sT.FSL_Service_Territory_Code__c = 'T2851';
        sT.IsActive=true;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        Asset ast = new Asset();
        ast.Name='eoewieouiewoewo';
        ast.Type_PSN__c = 'Engines-eoewieouiewoewo';
        insert ast;
        
        WorkOrder SerRec =  new WorkOrder();
        //SerRec = CSS_TestData.createJobOrder(false);
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.ESN__c = '00000000';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        SerRec.ServiceTerritoryId = sT.id;
        SerRec.AssetId = ast.Id;
        insert SerRec;   
        
        Map<Id,WorkOrder> jOrd = new Map<Id,WorkOrder>();
        jOrd.put(SerRec.id,SerRec);
        WorkOrder cjb = [select id from WorkOrder where id =:SerRec.id];
        cjb.AssetId =SerRec.AssetId;
        //cjb.ESN__c='0000000001';
        //cjb.Make__c='test123';
        update cjb;
        List<WorkOrder> jobOrder = new List<WorkOrder>();
        jobOrder.add(cjb);
        system.debug(SerRec); 
        test.startTest();
        FSL_ServiceOrderRecentVisit.recentVisitFlag(jobOrder,jOrd);
        test.stopTest();
    }
}