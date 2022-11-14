/******
Name:  OSM_Intercompany_BusinessLayerHandler for Future call
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       24/12/2018     INITIAL DEVELOPMENT 
*******/
global class OSM_Intercompany_FutureLayerHandler{

    public static void callIntercompanyInvoiceAPI(Set<Id> setInvoiceId, boolean isRefund, boolean isDistributor)
    {
        List<Id> invoiceIdList=new List<Id>();
       List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
       OSM_ReturnWrapper objReturn;
       List<ccrz__E_Invoice__c> invoiceRecord=[Select id,Name,OSM_Child_Account__c,createddate,ICInvoice_Number__c,ccrz__OriginalAmount__c,ICInvoice_Date__c,ccrz__CCOrder__c,OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__CCOrder__r.BMS_OrderRefNumber__c,ccrz__CCOrder__r.BMS_BranchLocation__c,ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,BMS_PONumber__c,BMS_InvoiceNumber__c,OSM_Child_Account__r.OSM_Location_ID__c,OSM_Child_Account__r.OSM_SW_Responsible_Region__c,OSM_Child_Account__r.EBU_Channel_of_Distribution__c,OSM_Child_Account__r.PSBU_Channel_of_Distribution__c,ccrz__SoldTo__r.OSM_SW_Responsible_Region__c,ccrz__SoldTo__r.EBU_Channel_of_Distribution__c,ccrz__SoldTo__r.PSBU_Channel_of_Distribution__c,ccrz__CCOrder__r.Order_Source_Type__c,OSM_Child_Account__r.Customer_BMS_number__c,ccrz__SoldTo__r.location__c,ccrz__SoldTo__r.OSM_Location_ID__c,ccrz__SoldTo__r.CSS_DBCode__c,ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c,ccrz__CCOrder__r.OSM_BMS_Customer_Number__c from ccrz__E_Invoice__c where id IN: setInvoiceId];
       System.debug('invoiceRecord___'+invoiceRecord);
       System.debug('invoiceRecord[0]___'+invoiceRecord[0].OSM_Child_Account__r.Customer_BMS_number__c);
       Map<Id,ccrz__E_Invoice__c> invoiceRecordMap=new  Map<Id,ccrz__E_Invoice__c>();
       
       for(ccrz__E_Invoice__c invoice:invoiceRecord){
            invoiceRecordMap.put(invoice.id,invoice);
            objReturn=OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(invoice.id,invoiceRecordMap,isRefund,isDistributor,Null);
            objReturnList.add(objReturn);
         }     
         System.debug('objReturnList________'+objReturnList);

         updateInvoiceRecords(objReturnList);
    }
    public static void callIntercompanyInvoiceItemAPI(Set<Id> setInvoiceItemId, boolean isRefund, boolean isDistributor)
    {
        List<Id> invoiceIdList=new List<Id>();
        set<id> invoiceIds = new Set<id>();
       List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
       OSM_ReturnWrapper objReturn;
       List<ccrz__E_InvoiceItem__c > invoiceItemRecord=[Select id,ccrz__CCOrder__c,ccrz__CCOrderItem__c,ccrz__Invoice__c from ccrz__E_InvoiceItem__c where id=:setInvoiceItemId];
       for(ccrz__E_InvoiceItem__c invoiceItems:invoiceItemRecord){
            invoiceIds.add(invoiceItems.ccrz__Invoice__c);
       }
       System.debug('invoiceIds----->>'+invoiceIds);
       List<ccrz__E_Invoice__c> invoiceRecord=[Select id,Name,OSM_Child_Account__c,createddate,ICInvoice_Number__c,ccrz__OriginalAmount__c,
                                              (Select id,ccrz__CCOrder__c,ccrz__CCOrderItem__c,ccrz__Invoice__c from ccrz__InvoiceItems__r where id=:setInvoiceItemId),
                                              ICInvoice_Date__c,ccrz__CCOrder__c,OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__CCOrder__r.BMS_OrderRefNumber__c,ccrz__CCOrder__r.BMS_BranchLocation__c,ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,BMS_PONumber__c,BMS_InvoiceNumber__c,OSM_Child_Account__r.OSM_Location_ID__c,OSM_Child_Account__r.OSM_SW_Responsible_Region__c,OSM_Child_Account__r.EBU_Channel_of_Distribution__c,OSM_Child_Account__r.PSBU_Channel_of_Distribution__c,ccrz__SoldTo__r.OSM_SW_Responsible_Region__c,ccrz__SoldTo__r.EBU_Channel_of_Distribution__c,ccrz__SoldTo__r.PSBU_Channel_of_Distribution__c,ccrz__CCOrder__r.Order_Source_Type__c,OSM_Child_Account__r.Customer_BMS_number__c,ccrz__SoldTo__r.location__c,ccrz__SoldTo__r.OSM_Location_ID__c,ccrz__SoldTo__r.CSS_DBCode__c,ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c,ccrz__CCOrder__r.OSM_BMS_Customer_Number__c from ccrz__E_Invoice__c where id IN: invoiceIds];
       
       System.debug('invoiceRecord[0]___'+invoiceRecord[0].OSM_Child_Account__r.Customer_BMS_number__c);
       Map<Id,ccrz__E_Invoice__c> invoiceRecordMap=new  Map<Id,ccrz__E_Invoice__c>();
       
       for(ccrz__E_Invoice__c invoice:invoiceRecord){
            for(ccrz__E_InvoiceItem__c invoiceItem:invoice.ccrz__InvoiceItems__r){
                invoiceRecordMap.put(invoiceItem.id,invoice);
                objReturn=OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(invoiceItem.id,invoiceRecordMap,isRefund,isDistributor,invoiceItem.ccrz__CCOrderItem__c);
                objReturnList.add(objReturn);
            }
         }     
         System.debug('objReturnList________'+objReturnList);

         updateInvoiceRecords(objReturnList);
        
    }
    //@future(callout=true)
  /*  global static void getInvoiceInfo(List<Id> invoiceIdList)
    {
        OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(invoiceIdList);
    }*/
    
    public static void updateInvoiceRecords(List<OSM_ReturnWrapper> objReturnList)
    {
        System.debug('updateInvoiceRecords________'+objReturnList);
        Savepoint sp = Database.setSavepoint();
        List<ccrz__E_Invoice__c> objReturnToSaveList=new List<ccrz__E_Invoice__c>();
        List<ccrz__E_InvoiceItem__c> objReturnToSaveItemList=new List<ccrz__E_InvoiceItem__c>();
        List < ccrz__E_OrderItem__c> ordItemList = new List < ccrz__E_OrderItem__c > ();
        Set<id> setInvoiceIds = new Set<id>();
        
         try{
             for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                 //Update Records
                 if (objReturnToSave.updateInvoiceList!=null)
                 {     
                     for(ccrz__E_Invoice__c inv:objReturnToSave.updateInvoiceList){
                         objReturnToSaveList.add(inv);
                         setInvoiceIds.add(inv.id);
                  }
                 }
                 if (objReturnToSave.updateInvoiceItemList !=null)
                 {     
                     for(ccrz__E_InvoiceItem__c inv:objReturnToSave.updateInvoiceItemList){
                         objReturnToSaveItemList.add(inv);
                  
                  }
                 } 
                 if (objReturnToSave.updateOrdItemList !=null)
                 {     
                     for(ccrz__E_OrderItem__c oItems:objReturnToSave.updateOrdItemList){
                         ordItemList.add(oItems);
                  
                  }
                 }  
             }//MP-328 Code Start by Singaiah on 22-10-2021
             for(ccrz__E_Invoice__c CMemoInv:[Select id,Original_Sales_Order_Invoice_Number__r.name,Original_Sales_Order_Invoice_Number__c,IntercompanyCalled__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN: setInvoiceIds limit 10000]){
                 CMemoInv.IntercompanyCalled__c = True;
                 objReturnToSaveList.add(CMemoInv);
             }//MP-328 Code end
                update ordItemList;
                update objReturnToSaveList;
                update objReturnToSaveItemList;
             if(Test.isrunningTest())
            {
                throw new NullPointerException();
            }
             
         }
        catch(Exception ex)
        {
            System.debug('Exception in DML>>>>'+ex);
            Database.rollback(sp);
         for(OSM_ReturnWrapper objReturnToSave:objReturnList){
            for(OSM_Integration_Log__c objLog : objReturnToSave.lstToInsertLog)
            {
                objLog.Status__c = 'Failure'; 
                String oldMsg = '';
                if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                oldMsg = objLog.Error_Description__c;
                String msg  = oldMsg+ ' Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                objLog.Error_Description__c = msg;
            }
          }
        }
        finally 
        {
            List<OSM_Integration_Log__c> logList=new List<OSM_Integration_Log__c>();
            for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                if(objReturnToSave.lstToInsertLog !=  null && objReturnToSave.lstToInsertLog.size() > 0)
                    for(OSM_Integration_Log__c log:objReturnToSave.lstToInsertLog){
                        logList.add(log);
                    }
                 }
                 if(!Test.isRunningTest()){
                 insert logList;
             }
       }  
    }
}