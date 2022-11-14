/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_api_OutboundOrderCancel implements ccrz.cc_if_api {
    global static String CANCEL_TYPE_CANCEL;
    global static String CANCEL_TYPE_EDIT;
    global static String HK_ID;
    global static String ORDER_DATA_PARAM;
    global static String ORDER_OBJ_PARAM;
    global static String PARAM_STOREFRONT;
    global static String TYPE_PARAM;
    global cc_api_OutboundOrderCancel() {

    }
    global virtual Map<String,Object> cancelOrder(String orderId, Map<String,Object> params) {
        return null;
    }
    global virtual Boolean eligibleForCancellation(Map<String,Object> params) {
        return null;
    }
    global static ccrz.cc_api_OutboundOrderCancel getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> settings) {

    }
}
