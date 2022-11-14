//Sriprada - Added Comment to deploy changes as part of mule integration updates 
//Shirisha- Added Named Credentials
@isTest
public class FSL_JobContactInfo_Test {
    @testSetup static void dataSetup() 
    {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        acc.FSL_ERP_Customer_Code__c = '11234';
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
        asst.Type__c = 'Engines';
        insert asst;
        
        Id WORecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        WorkOrder wo    = new WorkOrder();
        wo.RecordTypeId = WORecId;
        wo.AssetId      = asst.Id;
        wo.AccountId    = acc.Id;
        wo.Payer__c     = acc.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'Intake';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        wo.ContactId = con.Id;
        wo.Shop_Work_Order__c = 'test1012';
        wo.Application__c = '130 - AUTOMOTIVE';
        //wo.createdDate=system.now().addDays(-29);
        wo.Repair_Location__c = 'Mobile';
        // wo.Failure_Date__c = system.now().addDays(-29);
        insert wo;
        
    }
    
    @isTest static void testCalloutForContactCreate()
    {
        // Set mock callout class 
        
        WorkOrder wo = new WorkOrder();
        wo = [Select id,Account.FSL_ERP_Customer_Code__c,Payer_ContactID__c,Payer__c,Payer__r.FSL_ERP_Customer_Code__c,ContactID from WorkOrder where Shop_Work_Order__c = 'test1012' Limit 1];
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        test.startTest();
        FSL_JobContactInfo.checkContactId(wo.id,wo.Account.FSL_ERP_Customer_Code__c);
        FSL_JobContactInfo.checkPayerContactId(wo.id,wo.Payer__r.FSL_ERP_Customer_Code__c);
        test.stopTest();
    }
    //Added Changes for Named Credentials
    @isTest static void testCalloutDirect()
    {
       Workorder wo = [Select id,Account.FSL_ERP_Customer_Code__c,Payer_ContactID__c,Payer__c,Payer__r.FSL_ERP_Customer_Code__c,ContactID from WorkOrder where Shop_Work_Order__c = 'test1012' Limit 1];
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Test.startTest();
        FSL_JobContactInfo.updatePayerContactId('{"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS"},"Target": {"TargetID": "MOVEX"},"Location": {"LocationID": "05340-05351"}},"DataArea": {"DistributorCode": "05340","BranchCode": "05351","JobContactName": "TRAVIS G","JobContactPhone": "041 842 1993","CustomerCode": "1310102","ContactID": "","JobContactEmail": "aaron.hilton@cummins.com","EmailNotAvailable": "Y","CSSJobID": "00002045","EmailNotification":"Y","TextNotification":"Y", "NightlyCommunication":"N", "LanguagePreference":"EN","MobilePhoneNumber":"3323456789"}}',wo.id);
        Test.stopTest();
    }
}