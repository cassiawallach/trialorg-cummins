@isTest
public class dbu_EXTEND_ccServiceCartItem_Test {

        @isTest static void testmethod1(){
        
        Test.startTest();
        system.debug('The Girl with Mr. Corso');
        
        //Declaring remote action context     
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        //Declaring class instance
        dbu_EXTEND_ccServiceCartItem ServiceCartItem = new dbu_EXTEND_ccServiceCartItem();
        
        //setting input data and perform execution
        Map<string,object> InputData = new Map<string,object>();
        Map<string,object> OutputData = ServiceCartItem.getFieldsMap(InputData);
                
        Test.stopTest();
        
    }

}