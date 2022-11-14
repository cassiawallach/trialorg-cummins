//recompilation
public class OSM_ReturnWrapper {

    
    public boolean exceptionFlag{get;set;}
    public String exceptionMessage{get;set;}
    
    //returned from OSM_SW_Batch_Subscription_Helper
    public Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper> accountIdVsInvoiceWrapperMap;
    public Map<String,Map<String,String>> invoiceIdVsEmailMap; 
    
    //Returned from AR Invoice and Journal Entry
    public Map<id,OSM_Integration_Log__c> mapToInsertLogs;
    public Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag;
    public Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag;
     
     
    // Returned from Invoice vertex call
    public List<OSM_Orders_In_Invoice__c> lstJunctionObjInvoiceToOrder;
    public List<ccrz__E_InvoiceItem__c> lstToUpdateInvoiceItem;
    public List<OSM_InvoiceLine_And_OrderLine__c> lstToUpdateJunctionItem;
    public List<OSM_Integration_Log__c> lstToInsertLog;
    
    //Returned from Revocation Process
    public Map<Id,String> invoiceIdVsStatusMap = new Map<Id,String>();
    
    //Retrurned BMS contact address,address book & Account list
   Public List<ccrz__E_ContactAddr__c> updateContactAddressList;
   Public List<Account> updateAccountList;
   public List<ccrz__E_ContactAddr__c> insertContactAddressList;
   public List<ccrz__E_AccountAddressBook__c> insertAddressBookList;
   public List<SObject> insertList;
    //for 1846
     public List<ccrz__E_InvoiceItem__c> updateInvoiceItemList;
     public List<ccrz__E_OrderItem__c> updateOrdItemList;

    //code ended for 1846

    //Retrurned FSD invoice and order list
     public List<ccrz__E_Order__c> updateOrderList;
     public List<ccrz__E_Invoice__c> updateInvoiceList;
    
    //Retrurned FSD invoice and order list
     public List<ccrz__E_OrderItem__c> updateOrderItemList;
     
     //returned orderItem list
     public List<ccrz__E_OrderItem__c> orderItemsToUpdateList;
     
     //returned orderItemLicenseList

     public List<OSM_Order_Item_License__c> orderItemLicenseList;

}