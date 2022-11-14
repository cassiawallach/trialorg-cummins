@isTest
public class dbu_EXTEND_ccServiceOrderItem_Test {

        @isTest static void testmethod1(){
        
        Test.startTest();
        system.debug('Mr. Dean Corso swiss');
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        dbu_EXTEND_ccServiceOrderItem ServiceOrderItem = new dbu_EXTEND_ccServiceOrderItem();
        
        Map<string,object> InputData = new Map<string,object>();
        Map<string,object> OutputData = ServiceOrderItem.getFieldsMap(InputData);
                
        Test.stopTest();
        
    }
    
}