@isTest
public class FSL_Update_Send_Comm_field_BMS_Test {
    
    static TestMethod void testScheduler() {
        
        List<WorkOrder> list_WorkOrder = new List<WorkOrder>();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        acc.FSL_Source_ERP__c='BMS';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
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
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        insert ast;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.Id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Nightly';
        con.Text_SMS_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        con.Send_Nightly_Communication__c = true;
        insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.Id;
        wo.AccountId = acc.Id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
        insert wo;
        
        FSL_Nightly_Communications__c fsl = new FSL_Nightly_Communications__c();
        fsl.Event__c = 'Invoice Ready';
        fsl.Active__c = TRUE;
        fsl.Contact__c = con.Id;
        Insert fsl;
        
        FSL_Update_Send_Comm_field_BMS fslbatch = new FSL_Update_Send_Comm_field_BMS(new List<Id>{con.Id});
        database.executeBatch(fslbatch);
    }
}