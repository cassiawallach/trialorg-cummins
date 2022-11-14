@istest
public class OSM_AccountGroupCheck_Test {
    public static testMethod void testocc()
        
    {
        Account acc = new Account();
    acc.name = 'NewAccount';
        acc.OSM_Accountgroupbatch__c=true;
        //acc.address = ‘USA’;  
    insert acc;
     System.assertnotEquals(null,acc.id);     
    }
}