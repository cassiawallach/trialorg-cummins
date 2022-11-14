@isTest

public class FSL_serviceReqShare_Test {
    static TestMethod void serviceReqMethod() {
        Id recdtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reported Problem').getRecordTypeId();
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact objContact = new Contact();
        objContact.RecordTypeId = conRecId;
        objContact.FirstName='Steve';
        objContact.LastName = 'Smith';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.Type_PSN__c ='Engines-79788868';
        objAsset.Type__c = 'Engines';
        insert objAsset;
        
        Case cs= new Case();
        cs.Service_Territory__c = objServiceTerritory.Id;
        cs.AccountId = objAccount.Id;
        cs.ContactId = objContact.Id;
        cs.AssetId = objAsset.Id;
        cs.Status = 'new';
        //cs.RecordTypeId = recdtypeId;
        insert cs;
        list<case>  clist=new list<case>();
        clist.add(cs);
        Test.startTest();
        FSL_serviceReqShare.serviceReqRecShare(clist);
        Test.stopTest();
    }
}