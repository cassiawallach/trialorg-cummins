@isTest

public class OSM_SW_ccLogicOrderCance_Test{
     static testMethod void OSM_SW_ccLogicOrderCance_Test(){
     
     //Preparing  the test data
      TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
      ccrz__E_OrderItem__c order=testCompletedTransactionSetUpRes1.orderitem;
      Map<string,ccrz__E_OrderItem__c> orderMap=new Map<string,ccrz__E_OrderItem__c>();
      string id=order.id;
      orderMap.put(id,order);
      User usr = [Select id from User where Id = :UserInfo.getUserId()];

      
     System.RunAs(usr)
     {                           
          test.StartTest();
          OSM_SW_ccLogicOrderCancel logicOrder=new OSM_SW_ccLogicOrderCancel();
          logicOrder.process(orderMap);
          test.StopTest();
      }
  }

}