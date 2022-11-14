@isTest
private class CCOSMPageUtilTest {
    
    @isTest static void test_remoteInit() {

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        
        ccrz.cc_RemoteActionResult result = CCOSMPageUtil.remoteInit(ctx);
  
        System.assert(result != NULL);
    }

    @isTest static void test_createMessage() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = CCOSMPageUtil.remoteInit(ctx);

        ccrz.cc_bean_Message msg =  CCOSMPageUtil.createMessage(ccrz.cc_bean_Message.MessageSeverity.INFO, 'label', ctx, 'testclass');
        result.messages.add(msg);
        System.assert(result != NULL);
        System.assert(result.messages.size() > 0);
    }

    @isTest static void test_buildResposeData() {
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = CCOSMPageUtil.remoteInit(ctx);

        CCOSMPageUtil.buildResponseData(result, true, new Map<String, Object>{'ctx' => ctx});

        CCOSMPageUtil.buildResponseData(result, null, new Map<String, Object>{'ctx' => ctx});

        System.assert(result != NULL);

    }

    @isTest static void test_combineResults() {
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result1 = CCOSMPageUtil.remoteInit(ctx);
        ccrz.cc_RemoteActionResult result2 = CCOSMPageUtil.remoteInit(ctx);
        CCOSMPageUtil.buildResponseData(result1, true, new Map<String, Object>{'ctx' => ctx});
        CCOSMPageUtil.buildResponseData(result2, true, new Map<String, Object>{'ctx' => ctx});

        ccrz.cc_RemoteActionResult result = CCOSMPageUtil.combineResults(result1, result2);

        System.assert(result != NULL);
    }
  
}