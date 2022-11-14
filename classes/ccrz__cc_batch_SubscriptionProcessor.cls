/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_batch_SubscriptionProcessor extends ccrz.ccBatchJob implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global static String CONTINUATION_SCOPE;
    global static String PROC_CONTEXT;
    global static String STOREFRONT;
    global ccrz.cc_hk_Subscriptions subscriptionsHook {
        get;
        set;
    }
    global static String USE_CONTINUANCE;
    global cc_batch_SubscriptionProcessor() {

    }
    global cc_batch_SubscriptionProcessor(Map<String,Object> params) {

    }
    global cc_batch_SubscriptionProcessor(String theStorefront, String processContext, Boolean useContinuance) {

    }
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
