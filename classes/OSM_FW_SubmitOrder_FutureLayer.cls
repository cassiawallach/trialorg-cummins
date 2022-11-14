/************************************************************
Name:  OSM_FW_SubmitOrder_FutureLayer
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
To call fw submit order as a future method.              
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            02/09/2021     INITIAL DEVELOPMENT          

*************************************************************/
  
public class OSM_FW_SubmitOrder_FutureLayer
{
    @future(callout = true)
    public static void callFWSubmitOrderFuture(Id OrderId,boolean iscancel,List<Id> orderItemLst1) 
    {
        OSM_FW_SubmitOrder_Handler.getOrderInfo(OrderId,iscancel,orderItemLst1);     
    }
    
}