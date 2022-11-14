@isTest
public class FSL_NightlyComm_Active_MOVEXUK_Test {
       @isTest static void testmethod1(){
       
         Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        acc.FSL_Source_ERP__c='MOVEX-UK';
        insert acc;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Nightly';
        
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        
        con.Send_Nightly_Communication__c= true;
        insert con;
        
        FSL_Nightly_Communications__c fsl = new FSL_Nightly_Communications__c();
        fsl.Event__c = 'Invoice Readyk';
        fsl.Active__c = TRUE;
        fsl.Contact__c = con.Id;
        //Datetime yesterday = Datetime.now().addDays(-1);
        //Test.setCreatedDate(fsl.Id, yesterday); 
       
        Insert fsl;
          Test.setCreatedDate(fsl.Id, Datetime.now().addDays(-1));

       
          Test.startTest();
          FSL_NightlyComm_Active_MOVEXUK job = new FSL_NightlyComm_Active_MOVEXUK();
          Database.executeBatch(job);
          Test.stopTest();
          System.assertEquals(1, [SELECT count() from FSL_Nightly_Communications__c where Event__c ='Invoice Readyk']);  
         
       }
}