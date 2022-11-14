/***************************************************************************************************
Class Name : FSL_EmailMessageHelper_Test
Description: Test class for FSL_CreateSOContactForAcoountContact 
Created By : Madhavi P
JIRA Story : CT4-177
25-11-2020 - Madhavi P - Created test class to cover code coverage for FSL_EmailMessageTrigger
07/15/2021 - Vamsi - Added comment for test class execution in deployment
*/
@isTest
public class FSL_EmailMessageHelper_Test {
    // Preparing test data for Workorder creation.
    static testMethod void insertServiceOrderContactList() {
        List<WorkOrder> list_WorkOrder = new List<WorkOrder>();
        Test.startTest();
        
       
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
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
        ast.Engine_Family_Code__c = 'test123';
        insert ast;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Real-Time';
        con.Text_SMS_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        //wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
       // insert wo;
         list_WorkOrder.add(wo); 
        
        WorkOrder wo1 = new WorkOrder();
        wo1.Payer__c = acc.id;
        wo1.AccountId = acc.id;
        wo1.ESN__c='79371784';
        wo1.Unit_Type__c='595769';
        wo1.Make__c='INTERNATIONAL';
        wo1.Model__c='PROSTAR';
        wo1.AssetId=ast.Id;
        wo1.ServiceTerritoryId=st.Id;
        wo1.FSL_Additional_Email_Notifications__c='test@cummins.com';
        //wo1.Payer_ContactID__c=con.Id;
        wo1.contactId = con.Id;
        list_WorkOrder.add(wo1); 
        
        insert  list_WorkOrder;
       
        
        Case cse = new Case();
        cse.Accountid = acc.Id;
        cse.Contactid = con.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.ServiceJob__c = wo1.Id;
        
        insert cse;
        Test.stopTest();
        
        list<EmailMessage> list_EmailMessages = new List<EmailMessage>();
        
        EmailMessage emailMessage = new EmailMessage(); 
        emailMessage.status = '0';
        emailMessage.fromName = 'Guidanz'; 
        emailMessage.RelatedToId = cse.Id; 
        emailMessage.subject = 'Communication Status Update'; 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>';  
        String[] toIds = new String[]{ cse.Id };  
        emailMessage.toIds = toIds; 
        emailMessage.toAddress = con.Email; 
        list_EmailMessages.add(emailMessage);
        
        EmailMessage emailMessage1 = new EmailMessage(); 
        emailMessage1.status = '0';
        emailMessage1.fromName = 'Guidanz'; 
        emailMessage1.RelatedToId = cse.Id; 
        emailMessage1.subject = 'Communication Status Update'; 
        emailMessage1.htmlBody = '<html><body><b>Hello</b></body></html>';  
        emailMessage1.toIds = toIds; 
        emailMessage1.toAddress = con.Email; 
        
        list_EmailMessages.add(emailMessage1);

        insert list_EmailMessages;
        
        FSL_CommunicationStatusHandler.totalCommunications(wo1.Id);
        delete emailMessage;
      }
    
}