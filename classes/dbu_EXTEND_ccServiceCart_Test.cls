/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Devaraj
**/
@isTest
private class dbu_EXTEND_ccServiceCart_Test {
    @isTest static void testmethod1(){
        
        Test.startTest();
        system.debug('Albert kesselring german');
        //Its a three days ride as the nazgul files
        //Hope we dont get one at our back
        //One ring to rule them all
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        dbu_EXTEND_ccServiceCart ServiceCart = new dbu_EXTEND_ccServiceCart();
        
        Map<string,object> InputData = new Map<string,object>();
        
        Map<string,object> OutputData = ServiceCart.getFieldsMap(InputData);
        ServiceCart.transformIn(InputData);
        Test.stopTest();
        
    } 
}

//UAT Deployment