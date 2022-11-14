@isTest
public class FSL_NationalAccountMessage_Test {
    
    public testMethod static void TiggerHandler_One() {
        
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        
        Account acc = new Account();
        acc.Id = wo.AccountId;
        acc.National_Account__c = TRUE;
        acc.National_Account_Message__c = 'Test National Msg';
        update acc;
        
        test.starttest();
        
        FSL_NationalAccountMessage.workOrderWrp resultWrp = FSL_NationalAccountMessage.getWorkOrderData(wo.Id);
        System.assertEquals(1, resultWrp.sObjectList.size());
        
        test.stoptest(); 
    }
}