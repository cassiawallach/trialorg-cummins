@isTest
public class OSM_SW_OrderDAEmailCtlr_Test{
    public static testmethod void test1(){
        try{
          
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;  
        User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
        list<account> tstAcc = new list<Account>();
        Account acc = new Account();
        acc.name = 'OSM_Test_Acc';
        acc.BMS_Customer_ID__c = '12345';
        tstAcc.add(acc);
        insert tstAcc;
        
        set<id> ordId = new set<id>();
        ccrz__E_Order__c ord1 = new ccrz__E_Order__c();
        ord1.ccrz__OrderStatus__c = 'Order Submitted';
        insert ord1;
        
        ordId.add(ord1.id);
        
        ord1.ccrz__OrderDate__c = system.today();
        ord1.ccrz__Account__c = tstAcc[0].id;
        update ord1;
        
        List<ccrz__E_Order__c> ordList = [select id,Name,ccrz__OrderStatus__c,BMS_Customer_ID__c,ccrz__Account__c from ccrz__E_Order__c where id =: ordId];
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        
        List<ccrz__E_TransactionPayment__c> tranList = new list<ccrz__E_TransactionPayment__c>();
        ccrz__E_TransactionPayment__c tran = new ccrz__E_TransactionPayment__c();
        tran.ccrz__AccountType__c = 'po';
        tran.ccrz__CCOrder__c = ordList[0].id;
        tran.ccrz__Account__c = tstAcc[0].id;
        tranList.add(tran);
        insert tranList[0];
        
        
        
        Test.startTest();
        OSM_SW_OrderDAEmailCtlr.SendEmailToDAFinance(ordList);
        Test.stopTest();
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
     
    }
  }