//Subbu update
public without sharing class OSM_SW_TransactionPaymentTriggerHandler{
        
    public static List<Id> tpIDList = new List<Id>();
    public static List<Id> invoicelst = new List<Id>();
    public static List<ccrz__E_TransactionPayment__c> tplist = new List<ccrz__E_TransactionPayment__c>(); 
    public static Map<Id,Id> mapCTPInvcid {get;set;}
    public static String state;
    public static boolean recursiveCall = true;
    
    //Constructor
    public OSM_SW_TransactionPaymentTriggerHandler(){       
    } 
       
    //Before Insert
    public static void OnBeforeInsert(List<ccrz__E_TransactionPayment__c> lstTP){   
        
        populateTransactionStatusForRecurringInvoice(lstTP);
    
    }
    
    //After Insert
    public static void OnAfterInsert(Map<Id,ccrz__E_TransactionPayment__c> newMap){
        
        mapCTPInvcid = new Map<Id,Id>();
        invoicelst = new List<Id>();   
        String TPStatus='';         
        for(ccrz__E_TransactionPayment__c ctp :newMap.values()){
            if(ctp.ccrz__InvoiceAppliedTo__c != null)
            {
                invoicelst.add(ctp.ccrz__InvoiceAppliedTo__c);
                mapCTPInvcid.put(ctp.ccrz__InvoiceAppliedTo__c, ctp.id);
                TPStatus=ctp.Transaction_Status__c;
                
                
            }
        }      
        system.debug('mapCTPInvcidHandler'+mapCTPInvcid);
        system.debug('invoicelst'+invoicelst);

        //For CC
        List<Id> invoicelst1 = new List<Id>();
        List<Id> invoiceListToCallVertex = new List<Id>();
        
        Map<Id,Id> mapCTPInvcid1 = new Map<Id, Id>();
        for(ccrz__E_TransactionPayment__c ctp :newMap.values()){
            if(ctp.ccrz__InvoiceAppliedTo__c != null && ctp.ccrz__AccountType__c == 'cc')
            {
                invoicelst1.add(ctp.ccrz__InvoiceAppliedTo__c);
                mapCTPInvcid1.put(ctp.ccrz__InvoiceAppliedTo__c, ctp.id);
                if(ctp.Transaction_Status__c == 'Recurring Payment Success')
                    invoiceListToCallVertex.add(ctp.ccrz__InvoiceAppliedTo__c);
                
            }
        } 
        system.debug('invoicelst1'+invoicelst1);
        system.debug('mapCTPInvcid1'+mapCTPInvcid1);

        if(invoiceListToCallVertex != null && invoiceListToCallVertex.size() > 0)   
            callVertexForRecurringCC(invoiceListToCallVertex);
        
        
        if(invoicelst1.size() > 0)
        {          
          
        }
        
        if(invoicelst.size() > 0)
        {    
            //Code added by Vaibhav on 29-Jul-18
            if(!System.isBatch()){
                system.debug('Inside after insert');
                if(TPStatus=='Order Item Cancel' || TPStatus=='Order Cancel Success')
                state = 'Order Cancel';
                else
                state = 'Order Placed';
               //Added by neha mehta for story 169621invoiceDetailsList____
               List<ccrz__E_Invoice__c> invoiceDetailsList= new List<ccrz__E_Invoice__c>();
               System.debug('Number of Queries performed'+Limits.getQueries());
               System.debug('Number of Queries actuall Limit'+Limits.getLimitQueries());
                if(Limits.getQueries()<Limits.getLimitQueries()) {
                    System.debug('Printing inside the limits Transaction Payment.');
                    invoiceDetailsList=[Select id,ccrz__BillTo__r.Is_OEM_Acount__c,ccrz__BillTo__r.Is_Training_Account__c,ccrz__BillTo__r.Is_Internal_Account__c,ccrz__BillTo__r.BOLT_Account_Number__c,ccrz__BillTo__r.Customer_BMS_number__c,ccrz__BillTo__r.BillingCountry from ccrz__E_Invoice__c where id in:invoicelst];
                    System.debug(''+invoiceDetailsList);
                    for(ccrz__E_Invoice__c invoice:invoiceDetailsList){
                        System.debug('invoiceDetailsList__boltnumber__'+invoice.ccrz__BillTo__r.BOLT_Account_Number__c);
                        System.debug('invoiceDetailsList__bms custid_'+invoice.ccrz__BillTo__r.Customer_BMS_number__c);


                        if(invoice.ccrz__BillTo__r.BOLT_Account_Number__c!=null || invoice.ccrz__BillTo__r.Customer_BMS_number__c!=null){
                            if(Label.OSM_North_America_Country.contains(invoice.ccrz__BillTo__r.BillingCountry) &&  !invoice.ccrz__BillTo__r.Is_OEM_Acount__c && !invoice.ccrz__BillTo__r.Is_Training_Account__c && !invoice.ccrz__BillTo__r.Is_Internal_Account__c)
                            {
                                if(!invoicelst.IsEmpty()&&!mapCTPInvcid.IsEmpty()){
                                    OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(invoicelst, mapCTPInvcid, state);
                                    OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(invoicelst, mapCTPInvcid, state);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static void callVertexForRecurringCC(List<Id> invoiceListToCallVertex)
    {
        List<OSM_Orders_In_Invoice__c> lstToUpdateJunctionObject = new List<OSM_Orders_In_Invoice__c>();
        List<Id> lstInvoiceJunId = new List<Id>();
            lstToUpdateJunctionObject = [Select Id,CC_Order__r.ccrz__Account__r.Is_Training_Account__c, CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c,CC_Order__r.ccrz__Account__r.Is_Internal_Account__c, Vertex_Call_Status__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: invoiceListToCallVertex];
            
            for(OSM_Orders_In_Invoice__c objJun : lstToUpdateJunctionObject)
            {
                if(!objJun.CC_Order__r.ccrz__Account__r.Is_Training_Account__c && !objJun.CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c && !objJun.CC_Order__r.ccrz__Account__r.Is_Internal_Account__c)
                lstInvoiceJunId.add(objJun.Id);
            }
                  
                OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTaxFuture(lstInvoiceJunId);
    }
    
    
    //After Update
    public static void OnAfterUpdate(Map<Id,ccrz__E_TransactionPayment__c> afterUpdateTpOldMap,Map<Id,ccrz__E_TransactionPayment__c> afterUpdateTpNewMap){
       if(recursiveCall)
       {
            System.debug('on tp trigger handler after update');
            recursiveCall = false;
            mapCTPInvcid = new Map<Id,Id>();
            List<ccrz__E_TransactionPayment__c> lstTPforRefund = new List<ccrz__E_TransactionPayment__c>();
            invoicelst = new List<Id>();
            List<Id> lstInvoiceId = new List<Id>();
            List<Id> lstInvoiceIdForVertex = new List<Id>();
            for(Id TransactionId : afterUpdateTpNewMap.keySet())
            {
                if(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c != afterUpdateTpOldMap.get(TransactionId).ccrz__InvoiceAppliedTo__c)
                {
                    invoicelst.add(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c);
                    mapCTPInvcid.put(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c, TransactionId);
                }
                if(afterUpdateTpNewMap.get(TransactionId).Transaction_Status__c != afterUpdateTpOldMap.get(TransactionId).Transaction_Status__c && afterUpdateTpOldMap.get(TransactionId).Transaction_Status__c !='Order Item Cancel')
                {
                    if(afterUpdateTpNewMap.get(TransactionId).Transaction_Status__c == 'Order Cancel Success' )
                    {
                        if(afterUpdateTpNewMap.get(TransactionId).ccrz__AccountType__c == 'po')
                        {
                        lstInvoiceId.add(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c);
                        mapCTPInvcid.put(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c, TransactionId);
                        }
                        lstTPforRefund.add(afterUpdateTpNewMap.get(TransactionId));
                    }
                    if(afterUpdateTpNewMap.get(TransactionId).Transaction_Status__c == 'Recurring Payment Success' && afterUpdateTpNewMap.get(TransactionId).ccrz__AccountType__c == 'cc')
                    {
                        if(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c != null)
                            lstInvoiceIdForVertex.add(afterUpdateTpNewMap.get(TransactionId).ccrz__InvoiceAppliedTo__c);
                    }
                }
                if(afterUpdateTpNewMap.get(TransactionId).Transaction_Status__c != afterUpdateTpOldMap.get(TransactionId).Transaction_Status__c)
                {
                    if(afterUpdateTpNewMap.get(TransactionId).Transaction_Status__c == 'OrderItem Cancel Success' )
                        {
                            lstTPforRefund.add(afterUpdateTpNewMap.get(TransactionId));
                        }
                }
                System.debug('invoicelst'+invoicelst);
                System.debug('mapCTPInvcid'+mapCTPInvcid);
                System.debug('lstInvoiceId'+lstInvoiceId);
                System.debug('lstTPforRefund'+lstTPforRefund);
                System.debug('lstInvoiceIdForVertex'+lstInvoiceIdForVertex);
            }
            
            if(invoicelst.size() > 0)
            {
                //Start by Vaibhav on 6-Aug-2018
                if(!System.isBatch()){
                //End by Vaibhav on 6-Aug-2018
                    system.debug('Inside after update with invoicelst');
                    state = 'Order Placed';
                    //Added by neha mehta for story 169621    
                  List<ccrz__E_Invoice__c> invoiceDetailsList=[Select id,OSM_SW_IsIntercompanyInvoice__c,Invoice_Type__c,ccrz__BillTo__r.BOLT_Account_Number__c,ccrz__BillTo__r.Is_Training_Account__c,ccrz__BillTo__r.Is_OEM_Acount__c,ccrz__BillTo__r.Is_Internal_Account__c,ccrz__BillTo__r.Customer_BMS_number__c,ccrz__BillTo__r.BillingCountry from ccrz__E_Invoice__c where id in:invoicelst];
                    for(ccrz__E_Invoice__c invoice:invoiceDetailsList){
                    System.debug('AfterUpdateinvoiceDetailsList__boltnumber__'+invoice.ccrz__BillTo__r.BOLT_Account_Number__c);
                    System.debug('AfterUpdateinvoiceDetailsList__bms custid_'+invoice.ccrz__BillTo__r.Customer_BMS_number__c);
                     if(!invoice.OSM_SW_IsIntercompanyInvoice__c  && invoice.Invoice_Type__c != 'Credit Memo' && state == 'Order Placed'){
                        if(invoice.ccrz__BillTo__r.BOLT_Account_Number__c!=null || invoice.ccrz__BillTo__r.Customer_BMS_number__c != null){
                            if(Label.OSM_North_America_Country.contains(invoice.ccrz__BillTo__r.BillingCountry) && !invoice.ccrz__BillTo__r.Is_Training_Account__c && !invoice.ccrz__BillTo__r.Is_OEM_Acount__c && !invoice.ccrz__BillTo__r.Is_Internal_Account__c)
                            {
                                if(!invoicelst.IsEmpty()&&!mapCTPInvcid.IsEmpty()){
                                OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(invoicelst, mapCTPInvcid, state);
                                OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(invoicelst, mapCTPInvcid, state);
                                }
                            }
                        }
                       } 
                    }

              //      OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(invoicelst, mapCTPInvcid, state);
               //     OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(invoicelst, mapCTPInvcid, state);
                }
            }
            
            if(lstInvoiceId != null && lstInvoiceId.size() > 0)
            {
                //Start by Vaibhav on 6-Aug-2018
                if(!System.isBatch()){
                //End by Vaibhav on 6-Aug-2018
                    system.debug('Inside after Update with lstInvoiceId');
                    List<ccrz__E_Invoice__c> invoiceDetailsList=[Select id,OSM_SW_Is_Bolt_PO__c,ccrz__BillTo__r.Is_Training_Account__c,ccrz__BillTo__r.Is_OEM_Acount__c,ccrz__BillTo__r.Is_Internal_Account__c, ccrz__BillTo__r.BOLT_Account_Number__c,ccrz__BillTo__r.Customer_BMS_number__c from ccrz__E_Invoice__c where id in:lstInvoiceId];
                    state = 'Order Cancel';
                    for(ccrz__E_Invoice__c invoice:invoiceDetailsList){
                        if(invoice.OSM_SW_Is_Bolt_PO__c  && ! invoice.ccrz__BillTo__r.Is_Training_Account__c && !invoice.ccrz__BillTo__r.Is_Internal_Account__c && !invoice.ccrz__BillTo__r.Is_OEM_Acount__c)
                        {
                            //OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(lstInvoiceId, mapCTPInvcid, state);
                            //OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(lstInvoiceId, mapCTPInvcid, state);
                        }
                    }
                }
            }
            
            
            if(lstInvoiceIdForVertex != null && lstInvoiceIdForVertex.size() > 0)
            {
                List<OSM_Orders_In_Invoice__c> lstToUpdateJunctionObject = new List<OSM_Orders_In_Invoice__c>();
                lstToUpdateJunctionObject = [Select Id, Vertex_Call_Status__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: lstInvoiceIdForVertex];
                
                for(OSM_Orders_In_Invoice__c objJun : lstToUpdateJunctionObject)
                {
                    objJun.Vertex_Call_Status__c = 'Pending';
                }
                if(lstToUpdateJunctionObject != null && lstToUpdateJunctionObject.size() > 0)
                    update lstToUpdateJunctionObject;
            }
            
            
            List<Id> invoicelst1 = new List<Id>();
            for(ccrz__E_TransactionPayment__c ctp :afterUpdateTpNewMap.values()){
                if(ctp.ccrz__InvoiceAppliedTo__c != null )
                {
                    if(ctp.OSM_Vertex_Integration_Failure__c)
                        invoicelst1.add(ctp.ccrz__InvoiceAppliedTo__c);
                }
            }   
            system.debug('invoicelst1 '+invoicelst1);     
            
            
            System.debug('lstTPforRefund: '+lstTPforRefund.size());
            
            if(lstTPforRefund != null && lstTPforRefund.size() > 0)
            {
                Set<Id> setInvoiceId = new Set<Id>();
                Set<Id> setOrderId = new Set<Id>();
                List<OSM_Orders_In_Invoice__c> lstJunctionObjToProced = new List<OSM_Orders_In_Invoice__c>();
                for(ccrz__E_TransactionPayment__c objTP : lstTPforRefund)
                {
                    if(objTP.ccrz__InvoiceAppliedTo__c != null && objTP.ccrz__CCOrder__c != null)
                    {
                        setInvoiceId.add(objTP.ccrz__InvoiceAppliedTo__c);
                        setOrderId.add(objTP.ccrz__CCOrder__c);
                    }
                }
                System.debug('setInvoiceId: '+setInvoiceId);
                System.debug('setOrderId: '+setOrderId);
                boolean isFWOrder = false;
                if(setInvoiceId.size() > 0 && setOrderId.size() > 0)
                {
                    List<OSM_Orders_In_Invoice__c> lstJunObj = new List<OSM_Orders_In_Invoice__c>();
                    List<Id> lstJunctionObjId = new List<Id>();
                    Map<String,OSM_Orders_In_Invoice__c> mapKeyToJunObj = new Map<String,OSM_Orders_In_Invoice__c>();
                    lstJunObj = [Select Id,CC_Order__r.FW_Product_Count__c,CC_Order__r.ccrz__Account__r.Is_Training_Account__c,CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c,CC_Order__r.ccrz__Account__r.Is_Internal_Account__c,CC_Invoice__c,CC_Order__c,Vertex_Refund_Call_Status__c,OSM_SW_Is_Refund_Request__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: setInvoiceId and CC_Order__c IN: setOrderId ];
                    
                    System.debug('lstJunObj: '+lstJunObj.size());
                    for(OSM_Orders_In_Invoice__c objJun : lstJunObj){
                        mapKeyToJunObj.put(objJun.CC_Invoice__c+'-'+objJun.CC_Order__c, objJun);
                        if(objJun.CC_Order__r.FW_Product_Count__c > 0){
                            isFWOrder = true;
                        }
                    }
                    
                    System.debug('mapKeyToJunObj: '+mapKeyToJunObj);
                    
                    for(ccrz__E_TransactionPayment__c objTP : lstTPforRefund)
                    {
                        if(mapKeyToJunObj.containsKey(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c) )
                        {
                            mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).OSM_SW_Is_Refund_Request__c = true;
                            if(!mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).CC_Order__r.ccrz__Account__r.Is_Training_Account__c && !mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c && !mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).CC_Order__r.ccrz__Account__r.Is_Internal_Account__c)
                            {
                            mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).Vertex_Refund_Call_Status__c = 'Pending';
                            lstJunctionObjId.add(mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c).Id);
                            }
                            lstJunctionObjToProced.add(mapKeyToJunObj.get(objTP.ccrz__InvoiceAppliedTo__c+'-'+objTP.ccrz__CCOrder__c));
                        }
                        
                    }
                    System.debug('lstJunctionObjToProced: '+lstJunctionObjToProced);
                    System.debug('lstJunctionObjId: '+lstJunctionObjId);
                    if(lstJunctionObjToProced != null && lstJunctionObjToProced.size() > 0)
                        update lstJunctionObjToProced;
                    if(lstJunctionObjId != null && lstJunctionObjId.size() > 0)
                    {   List<Id> invoiceIds = new List<Id>();
                        Id OrderId;
                        system.debug('===Before making Refund Invoice call==');
                        List<OSM_Orders_In_Invoice__c> obj = [select id,CC_Order__c,CC_Invoice__c,CC_Invoice__r.IsCredited__c,CC_Invoice__r.Credit_Memo_need_to_create_for__c from OSM_Orders_In_Invoice__c where ID IN : lstJunctionObjId];
                        if(obj.size() > 0 && obj != null){
                        for(OSM_Orders_In_Invoice__c oo : obj) 
                        {
                            if(!oo.CC_Invoice__r.IsCredited__c && oo.CC_Invoice__r.Credit_Memo_need_to_create_for__c > 0)
                                invoiceIds.add(oo.CC_Invoice__c);
                            OrderId = oo.CC_Order__c;
                        }
                        }
                        List<ccrz__E_Invoice__c> lstInv2 = new List<ccrz__E_Invoice__c>();
                        lstInv2 = [Select Id,Credit_Memo_need_to_create_for__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN : invoiceIds and IsCredited__c = false and Credit_Memo_need_to_create_for__c > 0];
                        for(ccrz__E_Invoice__c objInv : lstInv2)
                            invoiceIds.add(objInv.Id);
                        if(invoiceIds.size() > 0 && invoiceIds != null){
                            system.debug('===Before making Refund Invoice call calling credit memo==');
                            //OSM_Create_CreditMemo.createCreditMemo(invoiceIds,null);
                        }
                        
                        //code start call fw refund submit order
                        /*
                        {
                            Set<Id> cancleOrderId = new Set<Id>();
                            Map<Id,List<Id>> MapcancleOrderIdForFWRefund = new Map<Id,List<Id>>();
                            
                            
                                cancleOrderId.add(orderId);
                            
                            
                            if(cancleOrderId.size() > 0)
                            {
                                List<ccrz__E_Order__c> lstOrder = new List<ccrz__E_Order__c>();
                                lstOrder = [Select Id,FW_Product_Count__c,(Select Id,ccrz__ParentOrderItem__c from ccrz__E_OrderItems__r where IsRefundSubmitOrder_Done_for_FW__c = false and Group_Name__c =: Label.OSM_SW_FluidWatch) from ccrz__E_Order__c where  FW_Product_Count__c > 0 and Id IN: cancleOrderId];
                                for(ccrz__E_Order__c order : lstOrder)
                                {
                                    for(ccrz__E_OrderItem__c ordrItem : order.ccrz__E_OrderItems__r)
                                    {
                                        if(ordrItem.ccrz__ParentOrderItem__c == null)
                                        {
                                            if(!MapcancleOrderIdForFWRefund.containsKey(order.Id))
                                                MapcancleOrderIdForFWRefund.put(order.Id,new List<Id>());
                                            MapcancleOrderIdForFWRefund.get(order.Id).add(ordrItem.Id);
                                        }
                                    }
                                }
                            }
                            
                            if(MapcancleOrderIdForFWRefund.keySet().size() > 0)
                            {
                                for(Id key : MapcancleOrderIdForFWRefund.keySet() )
                                {
                                    if(MapcancleOrderIdForFWRefund.get(key).size() > 0)
                                        OSM_FW_SubmitOrder_FutureLayer.callFWSubmitOrderFuture(key,true,MapcancleOrderIdForFWRefund.get(key));
                                }
                            }
                        }
                        */
                        //code end call fw refund submit order
                        
                        System.debug('Before Calling invoice tax : '+lstJunctionObjId);
                        List<Id> lstJunctionObjId2 = new List<Id>();
                        List<OSM_Orders_In_Invoice__c> obj2 = new List<OSM_Orders_In_Invoice__c>();
                        List<Id> lstForBMSInvoice = new List<Id>();
                        List<Id> lstForCCorBoltInvoice = new List<Id>();
                        List<Id> intercompanyInvId = new List<Id>();
                        List<Id> salesInvId = new List<Id>();
                        obj2 = [select id,CC_Invoice__c,CC_Invoice__r.Payment_Method__c,CC_Invoice__r.OSM_SW_Is_Bolt_PO__c  from OSM_Orders_In_Invoice__c where ID IN : lstJunctionObjId];
                        for(OSM_Orders_In_Invoice__c objjun : obj2)
                        {
                            if(objjun.CC_Invoice__r.Payment_Method__c == 'po' && !objjun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c)
                            {
                                lstForBMSInvoice.add(objjun.CC_Invoice__c);
                            }
                            else
                            {
                                lstForCCorBoltInvoice.add(objjun.CC_Invoice__c);
                            }
                        }
                        System.debug('lstForBMSInvoice: '+lstForBMSInvoice);
                        if(lstForBMSInvoice.size() > 0)
                        {
                            List<ccrz__E_Invoice__c> lstInv = new List<ccrz__E_Invoice__c>();
                            lstInv = [Select Id from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN: lstForBMSInvoice and IsCredited__c = false];
                            System.debug('lstInv: '+lstInv);
                            if(lstInv.size() > 0)
                            {   
                                
                                for(ccrz__E_Invoice__c objinv : lstInv)
                                {
                                    intercompanyInvId.add(objinv.Id);
                                }
                                
                            }
                        }
                        System.debug('intercompanyInvId: '+intercompanyInvId);
                        List<Id> commonInvId = new List<Id>();
                        if(lstForCCorBoltInvoice.size() > 0)
                        {
                            for(Id objId : lstForCCorBoltInvoice)
                                commonInvId.add(objId);
                        }
                        if(intercompanyInvId.size() > 0)
                        {
                            for(Id objId : intercompanyInvId)
                                commonInvId.add(objId);
                        }
                        System.debug('lstForCCorBoltInvoice: '+lstForCCorBoltInvoice);
                        
                        if(commonInvId.size() > 0)
                        {
                            List<ccrz__E_Invoice__c> lstInv23 = new List<ccrz__E_Invoice__c>();
                            lstInv23 = [Select Id,Original_Sales_Order_Invoice_Number__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN: commonInvId and IsCredited__c = true order by CreatedDate DESC];
                            if(lstInv23.size() > 0)
                            {
                                Map<Id,Id> invoicesMap = new Map<Id,Id>();
                                for(ccrz__E_Invoice__c objInv : lstInv23)
                                {
                                    if(!invoicesMap.containsKey(objInv.Original_Sales_Order_Invoice_Number__c))
                                        invoicesMap.put(objInv.Original_Sales_Order_Invoice_Number__c,objInv.Id);
                                }
                                if(invoicesMap.size() > 0)
                                {
                                    List<OSM_Orders_In_Invoice__c> obj33 = new List<OSM_Orders_In_Invoice__c>();
                                    obj33 = [select id,CC_Invoice__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN:  invoicesMap.Values()];
                                    if(obj33.size() > 0)
                                    {
                                        for(OSM_Orders_In_Invoice__c objOI : obj33)
                                            lstJunctionObjId2.add(objOI.Id);
                                    }
                                }
                            }
                        }
                        System.debug('final : '+lstJunctionObjId2);
                        if(lstJunctionObjId2.size() > 0)
                        {
                            if(System.isBatch())
                                OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTax(lstJunctionObjId2); 
                            else
                            {
                                OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTaxFuture(lstJunctionObjId2);
                                
                            }
                        }
                        
                        
                        
                        
                        /*
                        List<OSM_Orders_In_Invoice__c> obj2 = new List<OSM_Orders_In_Invoice__c>();
                        List<Id> lstJunctionObjId2 = new List<Id>();
                        List<Id> invoiceIds2 = new List<Id>();
                        obj2 = [select id,CC_Invoice__c,CC_Invoice__r.Original_Sales_Order_Invoice_Number__c,CC_Invoice__r.Credit_Memo_need_to_create_for__c from OSM_Orders_In_Invoice__c where ID IN : lstJunctionObjId and CC_Invoice__r.IsCredited__c = true];
                        for(OSM_Orders_In_Invoice__c oo : obj2) 
                        {
                            invoiceIds2.add(oo.CC_Invoice__r.Original_Sales_Order_Invoice_Number__c);
                        }
                        Map<Id,Id> invoicesMap = new Map<Id,Id>();
                        List<ccrz__E_Invoice__c> lstInv3 = new List<ccrz__E_Invoice__c>();
                        List<OSM_Orders_In_Invoice__c> obj33 = new List<OSM_Orders_In_Invoice__c>();
                        if(invoiceIds2.size() > 0)
                        {
                            lstInv3 = [Select Id,Original_Sales_Order_Invoice_Number__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN: invoiceIds2 and IsCredited__c = true order by CreatedDate DESC];
                            if(lstInv3.size() > 0)
                            {
                                for(ccrz__E_Invoice__c objInv : lstInv3)
                                {
                                    if(!invoicesMap.containsKey(objInv.Original_Sales_Order_Invoice_Number__c))
                                        invoicesMap.put(objInv.Original_Sales_Order_Invoice_Number__c,objInv.Id);
                                }
                                obj33 = [select id,CC_Invoice__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN:  invoicesMap.Values()];
                                if(obj33.size() > 0)
                                {
                                    for(OSM_Orders_In_Invoice__c objOI : obj33)
                                        lstJunctionObjId2.add(objOI.Id);
                                }
                            
                            }
                        
                        }
                        if(lstJunctionObjId2.size() > 0)
                        {
                            if(System.isBatch())
                                OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTax(lstJunctionObjId); 
                            else
                            {
                                OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTaxFuture(lstJunctionObjId);
                                
                            }
                        }*/
                    }
                }
            }
        }
    }
    
    //Before Update
    public static void OnBeforeUpdate(Map<Id,ccrz__E_TransactionPayment__c> oldMap,Map<Id,ccrz__E_TransactionPayment__c> beforeUpdateTpNewMap){
        //Update Invoice Applied To field on Transaction Object--
    }
    
    
    public static void populateTransactionStatusForRecurringInvoice(List<ccrz__E_TransactionPayment__c> lstTP)
    {
        if(lstTP != null && lstTP.size() > 0)
        {
            Set<Id> setId = new Set<Id>();
            for(ccrz__E_TransactionPayment__c ObjTP : lstTP)
            {
                if(ObjTP.ccrz__InvoiceAppliedTo__c != null && ObjTP.ccrz__Token__c != null && ObjTP.ccrz__Token__c != '' && ObjTP.ccrz__TransactionCode__c != null && ObjTP.ccrz__TransactionCode__c != '')
                    setId.add(ObjTP.ccrz__InvoiceAppliedTo__c);
            }
            if(setId != null && setId.size() > 0)
            {
                Map<Id, boolean> mapInvoiceIsRecurring = new Map<Id, boolean>();
                List<ccrz__E_Invoice__c> lstInvoice = new List<ccrz__E_Invoice__c>();
                   
                lstInvoice = [Select Id, Recurring_Invoice__c from ccrz__E_Invoice__c where Id IN: setId and Payment_Method__c = 'cc'];
                
                if(lstInvoice != null && lstInvoice.size() > 0)
                {
                    for(ccrz__E_Invoice__c objInvoice : lstInvoice)
                    {
                        mapInvoiceIsRecurring.put(objInvoice.Id, objInvoice.Recurring_Invoice__c);
                    }
                
                
                    for(ccrz__E_TransactionPayment__c ObjTP : lstTP)
                    {
                        if(mapInvoiceIsRecurring.containsKey(ObjTP.ccrz__InvoiceAppliedTo__c) && mapInvoiceIsRecurring.get(ObjTP.ccrz__InvoiceAppliedTo__c) && ObjTP.ccrz__Token__c != null && ObjTP.ccrz__Token__c != '' && ObjTP.ccrz__TransactionCode__c != null && ObjTP.ccrz__TransactionCode__c != '')
                            ObjTP.Transaction_Status__c = 'Recurring Payment Success';
                    }
                    
                }
                
                
            }
        }
    }
    
    
}