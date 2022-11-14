@isTest
private class FSL_EmailUnsubscribe_Test {
   //test class run
    static testMethod void testUnsubscribe() {
 
       // Create a new test contact and insert it in the test method.
       Contact c = new Contact(firstName='john', 
                    lastName='smith',
                     //Mobile_Phone__c='1234567890', // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                    MobilePhone = '1234567890',        
                    Email='user@acme.com', 
                    HasOptedOutOfEmail=false,
                    Email_Notification_Frequency__c = 'Real-Time');
       insert c;
     List<string> emailAdd=new List<string>();
        string e1='user@acme.com';
        string e2='abc@ummins.com';
        string e3='abc@ummins.com';
        emailAdd.add(e1);
        emailAdd.add(e2);
        emailAdd.add(e3);
       FSL_EmailUnsubscribe_Invocable.updateContactRecords(emailAdd );
                            
    }

}