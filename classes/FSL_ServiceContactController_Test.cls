//Adding Comment for deployment
@isTest
public class FSL_ServiceContactController_Test {
    
     public static testMethod void fetchAccId() {
         Test.startTest();
         Id conRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         List<Id> accIdList = new List<Id>();
         Account acc = new Account();
         acc.Name = 'Freightliner of Arizona LLC';
         acc.RecordTypeId = conRecId;
         insert acc;
         WorkOrder wo = new WorkOrder();
         wo.Payer__c = acc.id;
         accIdList.add(acc.id);
         insert wo;
         
         system.debug('wo>>>'+wo);
         FSL_ServiceContactController.fetchAccountId(wo.id);
         FSL_ServiceContactController.deleteNewServiceOrderContacts(accIdList);
         Id accid = [SELECT Id,Payer__c FROM WorkOrder WHERE Id=:wo.id].Payer__c;
         Test.stoptest();
     }
        public static testMethod void fetchAccIdCatchCover() {
         Test.startTest();
         Id conRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         List<Id> accIdList = new List<Id>();
         Account acc = new Account();
         acc.Name = 'Freightliner of Arizona LLC';
         acc.RecordTypeId = conRecId;
         insert acc;
       /*  Contact con = new Contact();
         con.AccountId = acc.Id;
         con.FirstName = 'Test_FirstName';
         con.LastName = 'Test_LastName';
         con.IAM_Contact_Status__c = 'Active';
         insert con;*/
         WorkOrder wo = new WorkOrder();
         wo.Payer__c = acc.id;
        // wo.Payer_ContactID__c = con.Id;
         insert wo;
         ServiceOrderContact__c serCon = new ServiceOrderContact__c();
         serCon.Payer_Account__c = wo.Payer__c;
         serCon.Payer_Contact__c = wo.Payer_ContactID__c;
         //insert serCon;
         system.debug('wo>>>'+wo);
         FSL_ServiceContactController.fetchAccountId('wo');
         FSL_ServiceContactController.deleteNewServiceOrderContacts(accIdList);
         Id accid = [SELECT Id,Payer__c FROM WorkOrder WHERE Id=:wo.id].Payer__c;
         Test.stoptest();
     }

         

}