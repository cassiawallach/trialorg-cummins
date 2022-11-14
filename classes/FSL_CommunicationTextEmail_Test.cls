@isTest
public class FSL_CommunicationTextEmail_Test {
    
    public static testMethod void fetchEmailTextData() {
        Test.startTest();
        Id conRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = conRecId;
        insert acc;
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        insert wo;
        system.debug('wo>>>'+wo);
        FSL_CommunicationTextEmail.fetchEmailTextData(wo.id);
       // FSL_CommunicationTextEmail.fetchLanguagePref(wo.id);
        //FSL_CommunicationTextEmail.fetchLanguagePref('wo');
        FSL_CommunicationTextEmail.saveEmailTextData(wo.id,'abc@gmail.com','textcommunication');
       // FSL_CommunicationTextEmail.getLangPref();
        //Id accid = [SELECT Id,Payer__c FROM WorkOrder WHERE Id=:wo.id].Payer__c;
        
        Test.stoptest();
    }
    public static testMethod void TestmethodForNegative() {
        Test.startTest();
        Id conRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = conRecId;
        acc.Language_Preference__c = 'English';
        insert acc;
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        //wo.Language_Preferences__c=null;
        insert wo;
        system.debug('wo>>>'+wo);
        //FSL_CommunicationTextEmail.fetchLanguagePref(wo.id);
        //FSL_CommunicationTextEmail.fetchLanguagePref(null);
        FSL_CommunicationTextEmail.fetchEmailTextData(null);
        FSL_CommunicationTextEmail.saveEmailTextData(null,'abc@gmail.com','textcommunication');
        Test.stoptest();
    }
        

        

}