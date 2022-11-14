/*
======================================================================
Purpose:                                                            
This is OSM_SW_OrderTriggerHandler utility class which will call future 
method of Order Update and Order Cancelled
=======================================================================
*/

public class OSM_SW_OrderTriggerHandlerUtility{

    @future(callout = true)
    public static void getOrderUpdate(Set<Id> orderIdLst){
        OSM_SW_OrderActions.call_DA_OrderUpdatesAsync(orderIdLst); //order update
    }
    
    @future(callout = true)
    public static void getOMSOrderIdAndActivKey_OrderUpdate(Set<Id> orderIdLst){
        // calling OMS Create Order Service on after insertion of a CC Order Record
       OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(orderIdLst,null,null,false);
        system.debug('Order Idss>>>'+orderIdLst);
    }
        
    @future(callout = true)
    public static void getOrderCancel(Set<Id> orderIdLst){
        OSM_SW_OrderActions.call_DA_OrderCancellationAsync(orderIdLst); // order cancel
    }
    @future(callout = true)
    public static void getOrderItemCancel(Set<Id> orderIdLst){
        OSM_SW_OrderActions.call_DA_OrderItemCancellationAsync(orderIdLst); // order cancel
    }
    /*@future
    public static void intercompanyProcess(Set<Id> orderIdLst)
    {
        OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(orderIdLst);
    }*/
}