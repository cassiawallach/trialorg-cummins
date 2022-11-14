/******************************************************************************************************************************************
Name : FSL_DiscoFormTrigger_Test
Description :Test class for FSL_DiscoFormTrigger

Version                 Date                    Author                        Summary Of Change
--------------------------------------------------------------------------------------------------------------------------------------------
1.0                                             Cummins                       class created          
2.0                   02/09/2022               Madhavi Potluri                To improve the code coverage for FSL_DiscoFormTrigger
*********************************************************************************************************************************************/

@isTest
public class FSL_DiscoFormTrigger_Test {
    
     @testSetup static void setup() {
        test.starttest();
         BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
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
        
        Asset ase= new Asset();
        ase.name='79788861New';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644834';
        ase.Engine_Family_Code__c = '10';
        insert ase;
        
       
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
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
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
        wo.AssetId=ase.id;
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.ServiceTerritoryId = objServiceTerritory.id;
        wo.Process_Step__c ='Schedule';
        wo.RPV_Notification_Flag__c='RNFLAG';
        insert wo;
        
        List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.now().addDays(2);
        sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addDays(3);
        sa.SchedEndTime = datetime.now().addDays(4);
        sa.Service_Order__c= wo.id;
        sa.Formatted_Scheduled_Start__c='FSS';
        sa.Assigned_ServiceResource__c = sr.Id;
        sa.Is_a_Tech_Appointment__c=true;
        //sa.ser
        //insert sa;
        serviceappointmentList.add(sa);
        
        //sa.Status = 'Scheduled';
        //update sa;
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = wo.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.now().addDays(2);
        sa1.DueDate = System.now().addDays(30);
        sa1.SchedStartTime=datetime.now().addDays(3);
        sa1.SchedEndTime = datetime.now().addDays(4);
        sa1.Service_Order__c= wo.id;
        sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
        sa1.Is_a_Tech_Appointment__c=true;
        //insert sa1;
        serviceappointmentList.add(sa1);
        insert serviceappointmentList;
        
        sa.Status = 'Scheduled';
        update sa;
        test.stoptest();
    }
    
    public static testmethod void DeleteDiscoFormRecord(){
        serviceappointment getSA=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        Account getA=[Select id from Account where Name='Timothy_Guidanz'];
        workorder getWO=[Select id from workorder Where RPV_Notification_Flag__c='RNFLAG']; 
        user u = [Select id from User where email  = 'standardusnew@testorg.com'];
        test.startTest();
        getSA.Status = 'Dispatched';
        update getSA;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = stype.Id;
        ftm.FSL_Work_Type__c = pmWorkType.Id;
        ftm.Account__c =getA.Id;
        ftm.One_Form_Per_Service_Order__c = true;
        insert ftm;
        // system.runAs(u){
        disco__Form__c dis = new disco__Form__c(Service_Order__c=getWO.id,disco__Save_Complete__c = true,disco__Form_Template__c=formTemplate.id,Form_Template_Matrix__c=ftm.id);
        insert dis;
        test.stopTest();
             try{
                 delete dis;
             }
             catch (exception e){
                 system.debug('Exception caused while delteing record___ '+e.getCause());
             }
             
      //  }
       
    }
    
}