/*
 * Test Class for Apex Controller - FSL_CL_CustomerCreditMessages
 * Author - Piyush Rani
 * Updated - Harsha Ragam
 */ 
@isTest
public class FSL_CL_CustomerCreditMessages_Test {
   @isTest static void testCustomerCreditMessages() {
        WorkOrder workOrd = new WorkOrder();
        workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
        Account acc = FSL_TestDataUtility.createAccount();
        workOrd.Payer__c = acc.Id;
        update workOrd;
        String responseJSON = FSL_TestDataUtility.getCustomerCreditMessage();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        Test.startTest();
            List<FSL_CL_CustomerCreditMessages.messageWrapper> messageList = FSL_CL_CustomerCreditMessages.getCustomerCreditMessageData(workOrd.id);
            System.assertEquals(true,messageList.size()>0);
        Test.stopTest();
    }
    
    @isTest static void testCustomerCreditMessagesFromERPMessage() {
        WorkOrder workOrd = new WorkOrder();
        ERP_Message__c ERPMessage = new ERP_Message__c();
        String responseJSON = FSL_TestDataUtility.getCustomerCreditMessage();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        Test.startTest();
            ERPMessage = FSL_TestDataUtility.createERPMessage(null, 'createCC');
            List<FSL_CL_CustomerCreditMessages.messageWrapper> messageList = FSL_CL_CustomerCreditMessages.getCustomerCreditMessageData(ERPMessage.Service_Order__c);
            System.assertEquals(true,messageList.size()>0);
        Test.stopTest();
    }
    @isTest static void testupdateMessages() {
        WorkOrder workOrd = new WorkORder();
        ERP_Message__c ERPMessage = new ERP_Message__c();
        String responseJSON = FSL_TestDataUtility.getCustomerCreditMessage();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        ERPMessage = FSL_TestDataUtility.createERPMessage(null, 'createCC');
        Account acc = FSL_TestDataUtility.createAccount();
        WorkOrder wo = New WorkOrder(Id = ERPMessage.Service_Order__c,Payer__c = acc.id);
        update wo;
        ERPMessage.Customer_Credit_Message__c = '';
        update ERPMessage;
        Test.startTest();
            List<FSL_CL_CustomerCreditMessages.messageWrapper> messageList1 = FSL_CL_CustomerCreditMessages.updateCreditMessageData(ERPMessage.Service_Order__c);
            System.assertEquals(true,messageList1.size()>0);
        Test.stopTest();
    }
    
    @isTest static void testupdateBlankMessages() {
        String responseJSON = FSL_TestDataUtility.getCustomerCreditMessage();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        WorkOrder workOrd = new WorkOrder();
        ERP_Message__c ERPMessage = new ERP_Message__c();
        ERPMessage = FSL_TestDataUtility.createERPMessage(null, 'createCC');
        Account acc = FSL_TestDataUtility.createAccount();
        WorkOrder wo = New WorkOrder(Id = ERPMessage.Service_Order__c,Payer__c = acc.id);
        update wo;
        ERP_Message__c ERPMessageNew = [Select Id, Service_Order__c, Customer_Credit_Error_Msg__c From ERP_Message__c];
    	ERPMessageNew.Customer_Credit_Error_Msg__c = null;
    	update ERPMessageNew;
        System.debug('::: ERP PMessageNew = '+ERPMessageNew);
        Test.startTest();
            List<FSL_CL_CustomerCreditMessages.messageWrapper> messageList = FSL_CL_CustomerCreditMessages.updateCreditMessageData(ERPMessageNew.Service_Order__c);
            System.assertEquals(true,messageList.size()>0);
        Test.stopTest();
    }
    
    @isTest static void testCustomerCreditMessagesUpdates() {
        String responseJSON = FSL_TestDataUtility.getCustomerCreditMessage();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        WorkOrder workOrd = new WorkORder();
        List<Account> accList = new List<Account>();
        Test.startTest();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = FSL_TestDataUtility.createAccount().Id;
        wo.AssetId = FSL_TestDataUtility.createAsset().Id;
        wo.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        wo.Available_for_Service__c = datetime.now()+3;
        wo.Status = 'Intake ';        
        wo.Shop_Work_Order__c = 'test';
        wo.Process_Step__c = 'Intake';
        wo.RecordTypeId = recdtypeId; 
        wo.createdDate=system.now().addDays(-10);
        insert wo;
        
        accList = FSL_TestDataUtility.createAccounts(2);
        System.debug('::: WorkOrder in CCM = '+wo.Id+' and Acc Id = '+accList[0].Id);
        wo.Payer__c = accList[0].Id;
        update wo;
        List<WorkOrder> wolst = [Select Id,Payer__c From WorkOrder where id= :wo.id];
        System.assertEquals(wolst[0].Payer__c,accList[0].Id);
        Test.stopTest();
    }
    
    static TestMethod void testCustomerCreditMessagesfailure() {
         WorkOrder workOrd = new WorkOrder(); 
        workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(null));         
        Test.startTest();
            List<FSL_CL_CustomerCreditMessages.messageWrapper> messageList = FSL_CL_CustomerCreditMessages.getCustomerCreditMessageData(workOrd.id);
            System.assertEquals(false,messageList.size()>0);
        Test.stopTest();
    }
}