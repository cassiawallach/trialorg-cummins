/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface cc_dao_iOutboundOrder extends ccrz.cc_if_dao {
    List<Account> readAccountData(String param0);
    List<ccrz__E_OrderItem__c> readOrderLines(String param0);
    List<ccrz__E_Order__c> readOrder(String param0, Boolean param1);
    List<ccrz__E_PaymentDetail__c> readPayments(String param0);
}
