@isTest
private class FSL_AccountCommunicationToggles_Test{
static testmethod void toggleUnitTest1(){
Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.FSL_Source_ERP__c = 'BMS';
        account.billingStreet = '1460 National Rd';
        account.billingCity = 'New York';
        account.BillingPostalCode = '47201';
        account.Authorize_Work_Started__c = false;
        account.Equipment_Available__c = false;
        account.Invoice_Ready__c = false;
        account.Service_Work_Completed__c = false;
        account.Troubleshooting_Started__c = false;
        account.Name = 'Test Account';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.FSL_Source_ERP__c = 'BMS';
        account1.billingStreet = '1460 National Rd';
        account1.billingCity = 'New York';
        account1.BillingPostalCode = '47201';
        account1.Authorize_Work_Started__c = false;
        account1.Equipment_Available__c = false;
        account1.Invoice_Ready__c = false;
        account1.Service_Work_Completed__c = false;
        account1.Troubleshooting_Started__c = false;
        account1.Text_SMS_Notification_Frequency__c = 'Real-Time';
        account1.Email_Notification_Frequency__c = 'Nightly';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        List<Id> accIdSet = new List<Id>();
        accIdSet.add(account.Id);
        accIdSet.add(account1.Id);
        FSL_AccountCommunicationToggles.updateAccountCommToggles(accIdSet);
 }       
}