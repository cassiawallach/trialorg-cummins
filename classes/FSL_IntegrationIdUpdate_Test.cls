@isTest
public class FSL_IntegrationIdUpdate_Test {
    
    static testMethod void test1() {
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        //Test cls fix Address //CT3- Korea and Singapore Rollouts
        acc.Name = 'East Bronxx2';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '489234-USA';
        acc.FSL_Credit_Limit__c = 78888.5;
        acc.Email_Notification_Frequency__c='Real-Time';
        acc.BillingStreet = 'testline1,testline2';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567880';
        con.AccountId=acc.id;
        con.FSL_Contact_Id__c= '12';
        con.email = 'test@test.com';
        insert con;
        
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
        
        FSL_Labor_Multiplier__c objLaborMultiplier = new FSL_Labor_Multiplier__c(Name='TIER B');
        insert objLaborMultiplier;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = '796';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56';
        ast.Individual__c  = '0450090578';
        ast.Type__c = 'Engines';
        insert ast;
        
        //Test cls fix Address //CT3- Korea and Singapore Rollouts
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test cross reff1';
        locationObj.FSL_Account__c = acc.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
        addressObj.Street = '345 Dr';
        addressObj.Country = 'Australia';
        addressObj.Geolocation__Latitude__s = 87.00;
        addressObj.Geolocation__Longitude__s = 170.00;
        addressObj.FSL_Site_ID__c = '39';
        addressObj.FSL_Tax_District__c ='';
        addressObj.ParentId = locationObj.Id;
        addressObj.Account__c = acc.Id;
        insert addressObj;

        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.ContactId    = con.Id;
        wo.AssetId      = ast.Id;
        wo.Repair_Site_Address__c = addressObj.Id;//CT2-416
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        wo.Repair_Location__c = 'Mobile';
        // wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        // wo.Failure_Date__c = system.now().addDays(-29);
        insert wo;
      
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        test.startTest();
        FSL_IntegrationIdUpdate.getAccountId(acc.Id, acc.FSL_ERP_Customer_Code__c);
        FSL_IntegrationIdUpdate.getContactId(con.Id, con.FSL_Contact_Id__c);
        FSL_IntegrationIdUpdate.getAssetId(ast.Id, ast.Individual__c, acc.FSL_ERP_Customer_Code__c);
        FSL_IntegrationIdUpdate.getSiteId(addressObj.Id, addressObj.FSL_Site_ID__c); //CT2-416
        test.stopTest();
        Account objAccount = [Select FSL_ERP_Customer_Code__c,FSL_BMS_Instance__c from account where id=: acc.Id];
        system.assertEquals('USA', objAccount.FSL_BMS_Instance__c);
    }
}