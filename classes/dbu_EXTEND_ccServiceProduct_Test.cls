@isTest
//2/0
private class dbu_EXTEND_ccServiceProduct_Test {
    
    @isTest static void TestMethod1(){
        Test.startTest();
        system.debug('Boris Balkan swiss');
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        dbu_EXTEND_ccServiceProduct serviceProduct = new dbu_EXTEND_ccServiceProduct();
        
        Map<string,object> inputData = new Map<string,object>();
        inputData.put('dBUProductLocation', 'US');
        
        Map<string,object> outputData = serviceProduct.getFieldsMap(inputData);
        Map<string,object> outputData2 = serviceProduct.getFilterMap(inputData);
        
        Test.stopTest();
    }
    
}