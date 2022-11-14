@IsTest
public class OSM_SW_cc_api_OutboundOrderCancel_Test {

    static testmethod void testMethod1(){
    
    Map<String,Object> inputData = new Map<String,Object>();
     List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        ord.CreatedDate = system.today();
        ordList.add(ord);
        insert ordList;
        inputData.put(ccrz.cc_api_OutboundOrderCancel.ORDER_OBJ_PARAM,ordList[0]);
        
        
    Test.StartTest();
      OSM_SW_cc_api_OutboundOrderCancel obj = new OSM_SW_cc_api_OutboundOrderCancel();
      try{
       
      obj.eligibleForCancellation(inputData);
      }
      catch (exception ex){}
    Test.StopTest();
    }
}