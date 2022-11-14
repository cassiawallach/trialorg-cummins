@isTest
public class FSL_UpdateSiteToAddressBatch_Test{
    @testsetup
    public static void createTestData(){
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '40';
        con.Phone = '(042) 988-3045';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        
        IAM_CDH_Cross_references__c objSite1 = new IAM_CDH_Cross_references__c();
        objSite1.Name = 'TestNew';
        objSite1.IAM_Account__c = acc.Id;
        objSite1.FSL_MoveX_Contact_Id__c = '10';
        objSite1.FSL_MoveX_Site_Id__c = '1';
        objSite1.FSL_City__c = 'Brisbane';
        insert objSite1;
        
        Schema.Location loc = new Schema.Location();
        loc.Name = 'TestNew';
        loc.FSL_Account__c = acc.Id;
        loc.FSL_Contact_ID__c = '10';
        insert loc;
        
        Schema.Address addr = new Schema.Address();
        addr.parentId = loc.id;
        addr.FSL_Site_Name__c = 'TestNew';
        addr.FSL_Site_ID__c = '1';
        addr.street = '123 street';
        addr.City = 'Brisbane';
        addr.IAM_Site__c = objSite1.id;
        addr.state = 'Alabama';
        addr.postalCode = '12345';
        addr.country = 'United States';
        insert addr;
        
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'External-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = acc.Id;
        asset1.FSL_Site__c = addr.Id;
        asset1.Site__c = objSite1.id;
        insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        objWorkOrder.Repair_Site_Name__c = objSite1.id;
        insert objWorkOrder;
    }
    
    @isTest
    public static void testWorkOrder(){
        FSL_UpdateSiteToAddressBatch batchObj = new FSL_UpdateSiteToAddressBatch('WorkOrder');
        Database.executeBatch(batchObj);
    }
    
    @isTest
    public static void testAsset(){
        FSL_UpdateSiteToAddressBatch batchObj = new FSL_UpdateSiteToAddressBatch('Asset');
        Database.executeBatch(batchObj);
    }
}