/*
 * Test Class for Apex Controller - FSL_CL_MROMessages
 * Author - Piyush Rani
 * Updated- Harsha Ragam
 */

    
@isTest
public class FSL_CL_MROMessages_Test {
   
   @isTest static void testMROMessages() {
       
        WorkOrder workOrd = New WorkOrder();
        
       
            workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
            String responseJSON = FSL_TestDataUtility.getMROMessageJSON();
            Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        Test.startTest();
             List<FSL_CL_MROMessages.messageWrapper> messageList = FSL_CL_MROMessages.getMROMessage(workOrd.id);
            System.assertEquals(messageList.size()>0,true);
        Test.stopTest();
 }
    
  @isTest static void testMROMessagesFromERPMessage() {
      
        ERP_Message__c ERPMessage = new ERP_Message__c();
       
        Test.startTest();
        ERPMessage = FSL_TestDataUtility.createERPMessage('createMRO', null);
        String responseJSON = FSL_TestDataUtility.getMROMessageJSON();
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(responseJSON)); 
        List<FSL_CL_MROMessages.messageWrapper> messageList = FSL_CL_MROMessages.getMROMessage(ERPMessage.Service_Order__c);
        System.assertEquals(messageList.size()>0,true);
        Test.stopTest();
    }
    
    @isTest static void testMROMessagesUpdates() {
        WorkOrder workOrd = new WorkORder();
      
        List<Account> accList = new List<Account>();
        Test.startTest();
        
       
        //workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
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
        
        wo.AccountId = accList[0].Id;
        update wo;
        
        Test.stopTest();
    }
    
     //method to Test WOCommentInboundfailure
    static TestMethod void testMROMessagesfailure() {
         WorkOrder workOrd = new WorkOrder(); 
        workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC(null));         
        Test.startTest();
            List<FSL_CL_MROMessages.messageWrapper> messageList = FSL_CL_MROMessages.getMROMessage(workOrd.id);
            System.assertEquals(messageList.size()>0,false);
        Test.stopTest();
    }
}