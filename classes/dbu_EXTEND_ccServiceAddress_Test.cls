@isTest
public class dbu_EXTEND_ccServiceAddress_Test {
    @isTest static void testmethod1(){
        
        Test.startTest();
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        dbu_EXTEND_ccServiceAddress ServiceAddress = new dbu_EXTEND_ccServiceAddress();
        
        Map<string,object> InputData = new Map<string,object>();
        
        Map<string,object> OutputData = ServiceAddress.getFieldsMap(InputData);
        
        Test.stopTest();        
        
    }
}