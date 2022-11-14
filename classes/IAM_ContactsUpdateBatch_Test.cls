@isTest
public class IAM_ContactsUpdateBatch_Test {
static testMethod void testMethod1()
    {
        List<Id> lstContact= new List<Id>();
        for(integer i=1;i<=5;i++)
        {
            Contact con = new Contact();
            con.LastName ='Name'+i;
          con.IAM_Contact_Status__c = 'Active';
          con.IAM_Reason__c = '';
          con.Username__c = i+'test@gmail.com';
          insert con;
      lstContact.add(con.id);
        }
            
        Test.startTest();
            IAM_ContactsUpdateBatch obj = new IAM_ContactsUpdateBatch(lstContact);
            DataBase.executeBatch(obj);
        Test.stopTest();
    }
}