@isTest
public class dbu_EXTEND_ccServiceOrder_Test {

    @isTest static void testmethod1(){
        
        Test.startTest();
        system.debug('Baroness Kessler france');
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        dbu_EXTEND_ccServiceOrder ServiceOrder = new dbu_EXTEND_ccServiceOrder();
        
        Map<string,object> InputData = new Map<string,object>();
        Map<string,object> OutputData = ServiceOrder.getFieldsMap(InputData);
                
        Test.stopTest();
        
    }
    
}