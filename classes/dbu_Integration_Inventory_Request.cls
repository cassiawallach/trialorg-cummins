/**********************************************************************
Name: dbu_Integration_Inventory_Request
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    dbu_Integration_Inventory_Request request for REST API Service to import Product Inventory data
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         11/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/
global with sharing class dbu_Integration_Inventory_Request {
    public String SKU;
    //public String InventoryName;//default it to Product Name+ Inventory
    public String InventoryLocationCode;
    //public String Status;
    public String DistributorCode;
    //public String AVAILABILITYMESSAGE;
    public Double QtyAvailable;
}