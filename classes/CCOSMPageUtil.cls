public with sharing class CCOSMPageUtil {
   
    public static ccrz.cc_RemoteActionResult remoteInit(ccrz.cc_RemoteActionContext ctx) {
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        result.inputContext = ctx;
        ccrz.cc_CallContext.initRemoteContext(ctx);
        return result;
    }


    
    public static ccrz.cc_bean_Message createMessage(ccrz.cc_bean_Message.MessageSeverity severity, String labelName, Object data, String className) {
        ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
        msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
        msg.classToAppend = className;
        msg.labelId = labelName;
        if (data != null)
            msg.message = String.valueOf(data);
        msg.severity = severity;
        return msg;
    }

    
     public static void buildResponseData(ccrz.cc_RemoteActionResult response, Boolean success, Map<String, Object> data){
        response.data = data;
        if(success == null){
            response.success = true;
        }
        else {
            response.success = success;
        }
     }
    public static ccrz.cc_RemoteActionResult combineResults (ccrz.cc_RemoteActionResult res1, ccrz.cc_RemoteActionResult res2){
        if(res1.data != null){
            System.debug(res1.data);
            System.debug(res2.data);
            ((Map<String, Object>)res1.data).putAll(((Map<String, Object>)res2.data));
        }
        else{
            res1.data = res2.data;
        }
        res1.messages.addAll(res2.messages);

        res1.success &= res2.success;
        return res1;        
    }     
    
    public class CartItemWrapper {
        
        public ccrz__E_CartItem__c cartItem;
        public String FPN;
        public String CPN;
        
        public CartItemWrapper() {
            this.cartItem = new ccrz__E_CartItem__c();
            this.FPN = '';
            this.CPN = '';
        }
    }
}