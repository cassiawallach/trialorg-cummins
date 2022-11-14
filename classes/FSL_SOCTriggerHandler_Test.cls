@isTest
public class FSL_SOCTriggerHandler_Test {
    
    @isTest static void insertServiceOrderContactData(){
            
            Account acc = new Account();
            
            WorkOrder wo = new WorkOrder();
            ServiceOrderContact__c soCon = new ServiceOrderContact__c();
            OperatingHours  oh = new OperatingHours ();
            List<WorkOrder> woList = new List<WorkOrder>();
            Asset ast = new Asset();
            List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            acc.Name = 'Freightliner of Arizona LLC';
            acc.RecordTypeId = accRecId;
            insert acc;
        
        
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        insert ast;
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName='test';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        //con.Nightly_Communications__c = true;
        con.Language_Preferences__c = 'English';
        con.IAM_Contact_Status__c = 'Active'; 
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        
        conList.add(con);
        
         
        Contact con2 = new Contact();
        con2.FirstName='test';
        con2.LastName='test';
        con2.AccountId=acc.id;
        con2.Email = 'test@cummins.com';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        
        con2.Language_Preferences__c = 'English';
        con2.IAM_Contact_Status__c = 'Active'; 
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con2.MobilePhone ='1234567890';
        
        conList.add(con2);
        
        Contact con3 = new Contact();
        con3.FirstName='test';
        con3.LastName='test';
        con3.AccountId=acc.id;
        con3.Email = 'test@cummins.com';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        
        con3.Language_Preferences__c = 'English';
        con3.IAM_Contact_Status__c = 'Active'; 
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con3.MobilePhone ='1234567890';
        conList.add(con3);
        insert conList;
        
             
       
        system.debug('** con '+con.IAM_Contact_Status__c);
        system.debug('** con Id '+con.Id);
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        woList.add(wo);
        system.debug('** con Id '+con.Id);
        system.debug('** con '+wo.Payer_ContactID__c);
        system.debug('** con '+wo.Payer_ContactID__r.IAM_Contact_Status__c);
        //system.debug('** con '+wo.Payer_ContactID__r.Nightly_Communications__c);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.Payer__c = acc.id;
        wo2.AccountId = acc.id;
        wo2.ESN__c='79371784';
        wo2.Unit_Type__c='595769';
        wo2.Make__c='INTERNATIONAL';
        wo2.Model__c='PROSTAR';
        wo2.AssetId=ast.Id;
        wo2.ServiceTerritoryId=st.Id;
        wo2.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo2.Payer_ContactID__c=con2.Id;
        woList.add(wo2);
        
        
        WorkOrder wo3 = new WorkOrder();
        wo3.Payer__c = acc.id;
        wo3.AccountId = acc.id;
        wo3.ESN__c='79371784';
        wo3.Unit_Type__c='595769';
        wo3.Make__c='INTERNATIONAL';
        wo3.Model__c='PROSTAR';
        wo3.AssetId=ast.Id;
        wo3.ServiceTerritoryId=st.Id;
        wo3.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo3.Payer_ContactID__c=con2.Id;
        woList.add(wo3);

        insert woList; 
        
        Test.startTest();

        //soCon.Payer_Account__c = woList[0].Payer__r.Id;
        //soCon.Payer_Contact__c = woList[0].Payer_ContactID__r.Id;
        soCon.Payer_Account__c = acc.id;
        soCon.Payer_Contact__c = con.id;
        soCon.Payer_Contact_Flag__c = true;
        soCon.Service_Order__c = woList[0].Id;
        socList.add(soCon);

        ServiceOrderContact__c soCon2 = new ServiceOrderContact__c();
        soCon2.Payer_Account__c = acc.id;
        soCon2.Payer_Contact__c = con2.id;
        soCon2.Payer_Contact_Flag__c = true;
        soCon2.Service_Order__c = woList[1].Id;
        //soCon.Is_Inserted_Account_contact_del__c = true;
        //soCon.Opt_In__c = true;
        socList.add(soCon2);
        Insert socList;

        FSL_workorderListTriggerHandle.insertServiceOrderContactList(woList);
        FSL_serviceOrderContactTriggerHandler.insertServiceOrderContactList(socList);
        FSL_serviceOrderContactTriggerHandler.ServiceOrderContactAfterInsert(socList);
        
        
        List<ServiceOrderContact__c> updateList = new List<ServiceOrderContact__c>();

        try{
            soCon2.Payer_Account__c = acc.id;
            soCon2.Payer_Contact__c = con3.id;
            soCon2.Payer_Contact_Flag__c = true;
            soCon2.Service_Order__c = woList[1].Id;
            soCon.Is_Inserted_Account_contact_del__c = true;
            soCon.Opt_In__c = true;
            updateList.add(soCon2);
            
            update updateList;
        }
        catch (Exception e) {
            System.AssertEquals(e.getMessage().contains('Payer Contact already exists'), true);            
        }
            //soCon2.Payer_Contact_Flag__c = true;
//       update soCon2;        
       
        Test.stopTest();
        
    } 
    
}