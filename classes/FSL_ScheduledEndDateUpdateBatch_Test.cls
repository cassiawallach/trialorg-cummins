@isTest
public class FSL_ScheduledEndDateUpdateBatch_Test {
    public static testmethod void saHelper(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardusnew@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardunew@testorg.com'
                          , FederationIdentifier ='zxABCNew',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;
        
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy_Guidanz';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        insert oh;
        
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
        
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        sr.Is_a_Tech__c=true;
        insert sr;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory; 
        
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=sr.id;
        stm.ServiceTerritoryId=objServiceTerritory.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
        
        workorder wo=new workorder();
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.ServiceTerritoryId = objServiceTerritory.id;
        wo.Process_Step__c ='Schedule';
        wo.RPV_Notification_Flag__c='RNFLAG';
        insert wo;
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        //sa.EarliestStartTime = datetime.now().addDays(2);
        //sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addMinutes(3);
        sa.SchedEndTime = datetime.now().addMinutes(30);
        sa.Service_Order__c= wo.id;
        sa.Formatted_Scheduled_Start__c='FSS';
        sa.Assigned_ServiceResource__c = sr.Id;
        sa.Is_a_Tech_Appointment__c=true;
        insert sa;
        
        Test.startTest();
        FSL_ScheduledEndDateUpdateBatch x = new FSL_ScheduledEndDateUpdateBatch();
        database.executeBatch(x);
        Test.stopTest();
    }
    
    public static testMethod void testschedule() {
		Test.StartTest();
        FSL_ScheduleEndDateUpdate testsche = new FSL_ScheduleEndDateUpdate();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}