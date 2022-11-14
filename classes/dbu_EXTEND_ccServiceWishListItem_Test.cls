@isTest
public class dbu_EXTEND_ccServiceWishListItem_Test {
    @isTest static void testmethod1(){
        
        Test.startTest();
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        dbu_EXTEND_ccServiceWishListItem ServiceWishListItem = new dbu_EXTEND_ccServiceWishListItem();
        
        Map<string,object> InputData = new Map<string,object>();
        Map<string,object> OutputData = ServiceWishListItem.getFieldsMap(InputData);
                
        Test.stopTest();
        
    }
    
    @isTest static void testMethod2(){
        
        Test.startTest();
        
        ccrz.cc_RemoteActionContext	ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        dbu_EXTEND_ccServiceWishListItem ServiceWishListItem = new dbu_EXTEND_ccServiceWishListItem();
        
        Map<string,object> InputData = new Map<string,object>{'DBU_SAVEFORLATER' => 'WishList'};
        Map<string,object> OutputData = ServiceWishListItem.getFilterMap(InputData);
        
        
        Test.stopTest();
        
    }
    
    @isTest static void testMethod3(){
        
        Test.startTest();
        
        ccrz.cc_RemoteActionContext	ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        dbu_EXTEND_ccServiceWishListItem ServiceWishListItem = new dbu_EXTEND_ccServiceWishListItem();
        
        Map<string,object> InputData = new Map<string,object>{'DBU_SAVEFORLATER' => 'Save For Later'};
            Map<string,object> OutputData = ServiceWishListItem.getFilterMap(InputData);
        
        
        Test.stopTest();
        
    }
}