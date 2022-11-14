//Added for test codecoverage
@isTest
public class FSL_RecordTimesheetEntriesAbsences_Test {
    @TestSetup
    static void testDataSetup(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'testuserDivya@test.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testuserDivya@test.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        
        ServiceResource res = new ServiceResource();
        res.Name = 'Test Unqualified Resource';
        res.RelatedRecordId = u.Id;
        res.IsActive = true;
        res.ResourceType = 'T';
        insert res;
        
        OperatingHours  operatinghour = new OperatingHours ();
        operatinghour.Name = 'new';
        operatinghour.TimeZone = 'America/Chicago';
        insert operatinghour;
        
        TimeSlot timeslt = new TimeSlot();
        timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
        timeslt.StartTime = Time.newInstance(08,00,00,00);
        timeslt.EndTime =  Time.newInstance(17,00,00,00);
        timeslt.Operatinghoursid = operatinghour.id;
        insert timeslt;
        
        ServiceTerritory servTerritory = new ServiceTerritory();
        servTerritory.name = 'TEST ST Mobile';
        servTerritory.OperatingHoursId=operatinghour.id;
        servTerritory.Location_Code__c='03250-02851';
        servTerritory.FSL_Service_Territory_Code__c = '12345';
        servTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        servTerritory.Territory__c = 'AUSTRALIA';
        servTerritory.IsActive=true;
        
        insert servTerritory;    
        
        FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
        lm.Name = 'TIER B';
        insert lm;
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        acc.IAM_Service_Provider_Code__c = '29550';
        insert acc;
        
        Asset asst = new Asset();
        asst.Labor_Multiplier__c = lm.id;
        asst.Name = '79704393';
        asst.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c ='';
        insert asst;
        
        Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId(); //raghav
        
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        WorkOrder wo = new WorkOrder();
        Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        
        wo.AssetId=asst.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.createdDate=system.now().addDays(-10);
        // wo.FaultCodeId__c='1167';
        wo.Process_Step__c = '';
        wo.Status = 'Repair';
        wo.Type__c = 'Dealer';
        wo.RecordTypeId = woRecId;
        wo.CSS_Hours__c =  1000;
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Mileage__c = 234569.29;
        wo.Mileage_Measure__c = 'MILES'; 
        wo.ESN__c = '79704393';
        wo.Dealer_Shop_Work_Order__c = '13121';
        wo.EVL_DX_SONumber__c=true;
        wo.FSL_Active__c=true;
        wo.ERP__C='BMS';
        wo.recordTypeId=worecordTypeId;
        wo.ServiceTerritoryId=servTerritory.Id;
        WorkOrderList.add(wo);
        
        WorkOrder wo1 = new WorkOrder();
        wo1.AssetId=asst.id;
        wo1.Category1__c = 'Leak';
        wo1.Complaint_Type1__c='Air Leak';
        wo1.Available_for_Service__c=datetime.now()+3;
        // wo1.CaseId=cs.id;
        wo1.SelectedSolution__c='abc';
        // wo1.FaultCodeId__c='1167';
        wo1.Process_Step__c = '';
        wo1.Dealer_Shop_Work_Order__c = 'test';
        wo1.Mileage__c = 2232.21;
        wo1.CSS_Hours__c = 202;
        wo1.Mileage_Measure__c = 'MILES';
        wo1.Service_Model__c = 'New';
        wo1.EVL_DX_SONumber__c=true;
        wo1.Type__c= 'Dealer';
        wo1.FSL_Active__c=true;
        wo1.ERP__C='BMS';
        wo1.recordTypeId=worecordTypeId;
        wo1.ServiceTerritoryId=servTerritory.Id;

        WorkOrderList.add(wo1);
        
        insert WorkOrderList;
        
        Id recordTypeId =  Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Open_Timesheet').getRecordTypeId();
        Id allDayREcTypeID = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByDeveloperName().get('All_Day').getRecordTypeId();
        List<ResourceAbsence> absenceRecList = new List<ResourceAbsence>();
        
        ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(1),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                 ResourceId = res.id, RecordTypeId = allDayREcTypeID);
        ResourceAbsence ra1 = new ResourceAbsence(start=system.now().adddays(2),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                  ResourceId = res.id, RecordTypeId = allDayREcTypeID);
        absenceRecList.add(ra);
        absenceRecList.add(ra1);
        insert absenceRecList;
        Test.stopTest();
    }
    
    @isTest 
    static void testFSL_RecordTimesheetEntriesForAbsences(){
        List<WorkOrder> woList=[SELECT Id,ERP__c,ServiceTerritory.Id,ServiceTerritory.FSL_Service_Territory_Code__c FROM WorkOrder]; 
        List<ServiceTerritory> servTerrList =[Select id,OperatingHoursId, FSL_Service_Territory_Code__c from ServiceTerritory];
        List<OperatingHours>ophrList =[select id, (select StartTime, EndTime, DayofWeek from TimeSlots) FROM OperatingHours];
        List<ResourceAbsence> absenceRec = [select Id, resource.RelatedRecordId, start, end,RecordTypeId, 
                                            resource.relatedRecord.FSL_Primary_Service_Territory_Code__c,Resource_ERP__c,Billing_Type__c 
                                            from ResourceAbsence ];
        system.debug('absenceRec'+absenceRec.size());
        Test.startTest();
        FSL_RecordTimesheetEntriesForAbsences batch = new FSL_RecordTimesheetEntriesForAbsences();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}