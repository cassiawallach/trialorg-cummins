/************************************************************
Name:  OSM_InvokeInterCompanyProcess
Copyright © 2021  Cummins
=============================================================
=============================================================
Purpose:                                                            
This Trigger  will be used to initiate the Intercompanyorder process.
============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Nandigam Sasi     12/04/2021        INITIAL DEVELOPMENT          
*************************************************************/
trigger OSM_InvokeInterCompanyProcess on OSM_IntercompanyProcess__e (after insert) {
    Set<id> orderIds = new Set<id>();
    for(OSM_IntercompanyProcess__e orderevent :trigger.new){
        list<string> orders = orderevent.SalesOrder_ID__c.split(',');
        for(string order :orders)orderIds.add(Id.valueOf(order));
    }
    
    
    if(!Test.isrunningtest())OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(orderIds); 
}