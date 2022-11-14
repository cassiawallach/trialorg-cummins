/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_batch_Subscriptions_Renewal implements Database.Batchable<ccrz__E_OrderItem__c> {
    global Integer subscriptionReorderBatchSize {
        get;
        set;
    }
    global ccrz.cc_hk_Subscriptions subscriptionsHook {
        get;
        set;
    }
    global cc_batch_Subscriptions_Renewal(ccrz__E_StorefrontSettings__c storefront) {

    }
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global List<ccrz__E_OrderItem__c> start(Database.BatchableContext BC) {
        return null;
    }
}
