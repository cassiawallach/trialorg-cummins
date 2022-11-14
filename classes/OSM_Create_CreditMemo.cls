public class OSM_Create_CreditMemo
{
    public static void createCreditMemo(List<Id> invoiceIds,List<ccrz__E_OrderItem__c> lstOrderItem){
        Map<Id,ccrz__E_Invoice__c> mapIdToNewInvoice = new Map<Id, ccrz__E_Invoice__c>();
        Map<Id,ccrz__E_InvoiceItem__c> mapIdToNewInvoiceItem = new Map<Id, ccrz__E_InvoiceItem__c>();
        Map<Id,OSM_Orders_In_Invoice__c> mapIdToNewOrderInvoiceJunction = new Map<Id, OSM_Orders_In_Invoice__c>();
        Map<Id,OSM_InvoiceLine_And_OrderLine__c> mapIdToNewOrderInvoiceJunctionItem = new Map<Id, OSM_InvoiceLine_And_OrderLine__c>();
        List<ccrz__E_InvoiceItem__c > list_IIUPdate = new List<ccrz__E_InvoiceItem__c>();
        // Creation of credit memo invoices
        {
            List<String> fieldsToClone = new List<String>();
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get('ccrz__E_Invoice__c').getDescribe().fields.getMap();
            
      Map<Id,Id> map_InvIdOrderId = new Map<Id,Id>();
            Map<Id, Integer> map_OrderIdCreditMemoIndex = new Map<id, Integer>();
            for(ccrz__E_Invoice__c inv : [SELECT Id, ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE Id IN :invoiceIds]){
                map_InvIdOrderId.put(inv.Id, inv.ccrz__CCOrder__c);
            }
            
            for(ccrz__E_Order__c ordr : [SELECT Id, (SELECT Id FROM ccrz__CCInvoices__r WHERE Invoice_Type__c = 'Credit Memo') FROM ccrz__E_Order__c WHERE Id IN: map_InvIdOrderId.values()]){
                map_OrderIdCreditMemoIndex.put(ordr.Id, ordr.ccrz__CCInvoices__r.size());
            }
      
      for(Schema.SObjectField sfield : fieldMap.Values()) {
                schema.describefieldresult dfield = sfield.getDescribe();
                fieldsToClone.add(dfield.getName());
            }
            
            String query;
            for(String key :fieldsToClone )
            {
                if(query != null) {
                    query = query+','+key;
                }
                else {
                    query = key;
                }
            }
            
            
            
            query = 'Select '+query+' from ccrz__E_Invoice__c where Id IN: invoiceIds FOR UPDATE';
            
            System.debug(query);
            
            List<ccrz__E_Invoice__c> lstInvoice = new List<ccrz__E_Invoice__c>();
            
            lstInvoice = Database.query(query);
            
            System.debug(lstInvoice);
            List<Id> invoiceIdDupl = new List<Id>();
            
            if(lstInvoice.size() > 0 && lstOrderItem == Null)
            {
                for(ccrz__E_Invoice__c objInvoice : lstInvoice)
                {
                    ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
                    invoiceIdDupl.add(objInvoice.Id);
                    newInvoice = objInvoice.clone(false, false, false, false);
                    newInvoice.Invoice_Type__c = 'Credit Memo';
          newInvoice.IsCredited__c = true;
                    System.debug('OSM_Create_CreditMemo: lstInvoice: '+lstInvoice);
                    System.debug('OSM_Create_CreditMemo: objInvoice: '+objInvoice);
          
          integer creditIndex = 0;
                    if(map_InvIdOrderId.containsKey(objInvoice.Id) && map_OrderIdCreditMemoIndex.containsKey(map_InvIdOrderId.get(objInvoice.Id))){
                        creditIndex = map_OrderIdCreditMemoIndex.get(map_InvIdOrderId.get(objInvoice.Id)) + 1;
                    }else{
                        creditIndex = 1;
                    }
                    string invNmbr = objInvoice.Name;
                    newInvoice.CreditMemo_Number__c = 'C'+ creditIndex + '-' + invNmbr.substring(2);
                    if(objInvoice.Payment_Method__c == 'cc')
                        newInvoice.ccrz__Status__c = 'Pending Refund';
                    System.debug(newInvoice);
                    //GOMS changes
                    newInvoice.GOMS_Invoice_ID__c='';
                    newInvoice.GOMS_Invoice_ID_Received__c=false;
                    newInvoice.Is_GOMS_Integration_Processed__c=false;
                    newInvoice.Original_Sales_Order_Invoice_Number__c=objInvoice.id;
                    mapIdToNewInvoice.put(objInvoice.Id, newInvoice);
                }
                
                if(mapIdToNewInvoice.size() > 0)
                {
                    insert mapIdToNewInvoice.values();
                }
                
            }else{
                for(integer i=0; i>lstOrderItem.size(); i++){
                    for(ccrz__E_Invoice__c objInvoice : lstInvoice)
                    {
                        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
                        invoiceIdDupl.add(objInvoice.Id);
                        newInvoice = objInvoice.clone(false, false, false, false);
                        newInvoice.Invoice_Type__c = 'Credit Memo';
            newInvoice.IsCredited__c = true;
                        System.debug('OSM_Create_CreditMemo: lstInvoice: '+lstInvoice);
                        System.debug('OSM_Create_CreditMemo: objInvoice: '+objInvoice);
            
            string invNmbr = objInvoice.Name;
                        integer creditIndex = 0;
                        if(map_InvIdOrderId.containsKey(objInvoice.Id) && map_OrderIdCreditMemoIndex.containsKey(map_InvIdOrderId.get(objInvoice.Id))){
                            creditIndex = map_OrderIdCreditMemoIndex.get(map_InvIdOrderId.get(objInvoice.Id)) + 1;
                        }else{
                            creditIndex = 1;
                        }
                        
                        newInvoice.CreditMemo_Number__c = 'C'+ creditIndex + '-' + invNmbr.substring(2);
                        if(objInvoice.Payment_Method__c == 'cc')
                            newInvoice.ccrz__Status__c = 'Pending Refund';
                        System.debug(newInvoice);
                        //GOMS changes
                        newInvoice.GOMS_Invoice_ID__c='';
                        newInvoice.GOMS_Invoice_ID_Received__c=false;
                        newInvoice.Is_GOMS_Integration_Processed__c=false;
                        newInvoice.Original_Sales_Order_Invoice_Number__c=objInvoice.id;

                        // code for MAR-1786 start
                        if(objInvoice.OSM_SW_Is_third_Party_BMS_Payment2__c && !objInvoice.OSM_SW_IsIntercompanyInvoice__c)
                        {
                            newInvoice.ccrz__BillTo__c = objInvoice.Third_Party_BMS_Customer_Name__c;
                            newInvoice.ccrz__SoldTo__c = objInvoice.Third_Party_BMS_Customer_Name__c;
                        }
                        // code for MAR-1786 end
                        
                        
                        mapIdToNewInvoice.put(objInvoice.Id, newInvoice);
                    }
                }
                if(mapIdToNewInvoice.size() > 0)
                {
                    insert mapIdToNewInvoice.values();
                }
            }
            System.debug('result');
            System.debug(mapIdToNewInvoice);
            
        }
        
        
        // creation of invoice item
        {
            try{
                List<String> fieldsToClone = new List<String>();
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get('ccrz__E_InvoiceItem__c').getDescribe().fields.getMap();
                for(Schema.SObjectField sfield : fieldMap.Values()) {
                    schema.describefieldresult dfield = sfield.getDescribe();
                    fieldsToClone.add(dfield.getName());
                }
                
                String query;
                for(String key :fieldsToClone ) {
                    if(query != null) {
                        query = query+','+key;
                    }
                    else {
                        query = key;
                    }
                }
                
                Map<Id, ccrz__E_InvoiceItem__c> map_InvIdTaxItem = new Map<Id, ccrz__E_InvoiceItem__c>();
                String shippingType = 'Shipping';
                String taxType = 'Tax';
                String invQuery = 'Select '+query+' from ccrz__E_InvoiceItem__c WHERE ccrz__Type__c =:taxType AND ccrz__Invoice__c =: invoiceIds';
                ccrz__E_InvoiceItem__c newTaxInvoiceItem = new ccrz__E_InvoiceItem__c();
                for(ccrz__E_InvoiceItem__c objInvoiceItem : Database.query(invQuery)) {
                    newTaxInvoiceItem = objInvoiceItem.clone(false, false, false, false);
                    System.debug('objInvoiceItem.ccrz__Invoice__c  '+objInvoiceItem.ccrz__Invoice__c);
                    if(mapIdToNewInvoice.containsKey(objInvoiceItem.ccrz__Invoice__c))
                        newTaxInvoiceItem.ccrz__Invoice__c = mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Id;
                    System.debug('newTaxInvoiceItem .ccrz__Invoice__c  '+newTaxInvoiceItem.ccrz__Invoice__c);
          map_InvIdTaxItem.put(objInvoiceItem.ccrz__Invoice__c, newTaxInvoiceItem);
                }
        
                query = 'Select '+query+' from ccrz__E_InvoiceItem__c where ccrz__Invoice__c IN: invoiceIds AND IsCredited__c = false AND ccrz__Type__c !=:taxType AND ccrz__Type__c !=:shippingType FOR UPDATE';
                
                System.debug(query);
                
                List<ccrz__E_InvoiceItem__c> lstInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
                
                lstInvoiceItem = Database.query(query);
                
                Map<Id, Decimal> map_InvIdTax = new Map<Id, Decimal>();
        
                if(lstInvoiceItem.size() > 0) {
                    System.debug('lstInvoiceItem: '+lstInvoiceItem);
                    for(ccrz__E_InvoiceItem__c objInvoiceItem : lstInvoiceItem) {
                        Decimal taxAmount = 0.0;  
                        if(!map_InvIdTax.containsKey(objInvoiceItem.ccrz__Invoice__c)){  
                            map_InvIdTax.put(objInvoiceItem.ccrz__Invoice__c, taxAmount);  
                        }else{  
                            taxAmount = map_InvIdTax.get(objInvoiceItem.ccrz__Invoice__c);  
                        }
            ccrz__E_InvoiceItem__c newInvoiceItem = new ccrz__E_InvoiceItem__c();
                        newInvoiceItem = objInvoiceItem.clone(false, false, false, false);
                        if(mapIdToNewInvoice.containsKey(objInvoiceItem.ccrz__Invoice__c))
                            newInvoiceItem.ccrz__Invoice__c = mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Id;
                        newInvoiceItem.IsCredited__c = true;
            objInvoiceItem.IsCredited__c = true;
                        /*if(newInvoiceItem.Vertex_Tax__c != null){
                            taxAmount = taxAmount + newInvoiceItem.Vertex_Tax__c;
                        }*/
                        if(mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Payment_Method__c == 'po' && mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).OSM_SW_Is_Bolt_PO__c == false && mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).OSM_SW_IsIntercompanyInvoice__c == false)
                        {
                            if(newInvoiceItem.OSM_SW_OrderItem_Vertex_for_BMS_po__c != null  ){
                                taxAmount = taxAmount + newInvoiceItem.OSM_SW_OrderItem_Vertex_for_BMS_po__c;
                            }
                        }
                        else
                        {
                            if(newInvoiceItem.Vertex_Tax__c != null  ){
                                taxAmount = taxAmount + newInvoiceItem.Vertex_Tax__c;
                            }
                        }
            
            map_InvIdTax.put(objInvoiceItem.ccrz__Invoice__c, taxAmount);
                        mapIdToNewInvoiceItem.put(objInvoiceItem.Id, newInvoiceItem);
            list_IIUPdate.add(objInvoiceItem);
                    }
                    System.debug('testing.. '+mapIdToNewInvoiceItem);
          
          for(Id invId : map_InvIdTax.keySet()){  
                        if(map_InvIdTaxItem.containsKey(invId)){  
                            map_InvIdTaxItem.get(invId).ccrz__OriginalAmount__c = map_InvIdTax.get(invId);  
                            map_InvIdTaxItem.get(invId).Vertex_Tax__c = map_InvIdTax.get(invId);  
                        }  
                    }
          
                    if(mapIdToNewInvoiceItem.size() > 0)
                    {
                        insert mapIdToNewInvoiceItem.values();
                        insert map_InvIdTaxItem.values();
            //update list_IIUPdate;
                    }
                    
                }
                System.debug('result');
                System.debug(mapIdToNewInvoiceItem);
            }catch(exception ex){
                
            }
            
        }
        //creating TP record
        {
               List<String> fieldsToClone = new List<String>();
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get('ccrz__E_TransactionPayment__c').getDescribe().fields.getMap();
                for(Schema.SObjectField sfield : fieldMap.Values()) {
                    schema.describefieldresult dfield = sfield.getDescribe();
                    fieldsToClone.add(dfield.getName());
                }
                
                String query;
                for(String key :fieldsToClone ) {
                    if(query != null) {
                        query = query+','+key;
                    }
                    else {
                        query = key;
                    }
                }
                String invQuery31='Select '+query+' from ccrz__E_TransactionPayment__c  WHERE ccrz__InvoiceAppliedTo__c IN: invoiceIds and (ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c=true or ccrz__InvoiceAppliedTo__r.OSM_SW_Is_Bolt_PO__c=true)';
                
                List<ccrz__E_TransactionPayment__c> list_TransUpdate = new List<ccrz__E_TransactionPayment__c>();
                for(ccrz__E_TransactionPayment__c objTransRec : Database.query(invQuery31 )) {
                    ccrz__E_TransactionPayment__c objTransRecItem = new ccrz__E_TransactionPayment__c();
                    objTransRecItem = objTransRec.clone(false, false, false, false);
                    if(mapIdToNewInvoice.containsKey(objTransRec.ccrz__InvoiceAppliedTo__c))
                    {
                        objTransRecItem.ccrz__InvoiceAppliedTo__c = mapIdToNewInvoice.get(objTransRec.ccrz__InvoiceAppliedTo__c).Id;
                        objTransRecItem.Transaction_Status__c='Order Cancel Success';
                        objTransRecItem.Bolt_JE_Reversal_Call_Status__c='Pending';
                        objTransRecItem.Bolt_Credit_Memo_Call_Status__c='Pending';
                        list_TransUpdate.add(objTransRecItem);
                    }
                }   
                if((list_TransUpdate.size() > 0)|| Test.isRunningTest()) {
                   insert list_TransUpdate;
                }
        }
        // creating Orders In Invoice junction
        {
            List<String> fieldsToClone = new List<String>();
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get('OSM_Orders_In_Invoice__c').getDescribe().fields.getMap();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //if(dfield.isUpdateable())
                //{
                fieldsToClone.add(dfield.getName());
                //}
            }
            
            String query;
            for(String key :fieldsToClone )
            {
                if(query != null)
                {
                    query = query+','+key;
                }
                else
                {
                    query = key;
                }
            }
            
            
            
            query = 'Select '+query+' from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: invoiceIds';
            
            System.debug(query);
            
            List<OSM_Orders_In_Invoice__c> lstOrderInvoiceJunction = new List<OSM_Orders_In_Invoice__c>();
            
            lstOrderInvoiceJunction = Database.query(query);
            
            System.debug(lstOrderInvoiceJunction);
            
            if(lstOrderInvoiceJunction.size() > 0)
            {
                for(OSM_Orders_In_Invoice__c objOrderInvoiceJun : lstOrderInvoiceJunction)
                {
                    OSM_Orders_In_Invoice__c newOrdrInvoiceJun = new OSM_Orders_In_Invoice__c();
                    newOrdrInvoiceJun = objOrderInvoiceJun.clone(false, false, false, false);
                    newOrdrInvoiceJun.OSM_SW_Is_Refund_Request__c = true;
                    newOrdrInvoiceJun.Vertex_Refund_Call_Status__c = 'Pending';
                    if(mapIdToNewInvoice.containsKey(newOrdrInvoiceJun.CC_Invoice__c)){
                        newOrdrInvoiceJun.CC_Invoice__c = mapIdToNewInvoice.get(newOrdrInvoiceJun.CC_Invoice__c).Id;
                        mapIdToNewOrderInvoiceJunction.put(objOrderInvoiceJun.Id, newOrdrInvoiceJun);
                    }
                }
                
                if(mapIdToNewOrderInvoiceJunction.size() > 0)
                {
                    insert mapIdToNewOrderInvoiceJunction.values();
                }
                
            }
            System.debug('result');
            System.debug(mapIdToNewOrderInvoiceJunction);
            
        }
        
        // creating Orders In Invoice junction Item
        {
            try{
                
            
            
            List<String> fieldsToClone = new List<String>();
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get('OSM_InvoiceLine_And_OrderLine__c').getDescribe().fields.getMap();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //if(dfield.isUpdateable())
                //{
                fieldsToClone.add(dfield.getName());
                //}
            }
            
            String query;
            for(String key :fieldsToClone )
            {
                if(query != null)
                {
                    query = query+','+key;
                }
                else
                {
                    query = key;
                }
            }
            
            List<Id> lstTemp = new List<Id>();
            
            for(Id key : mapIdToNewOrderInvoiceJunction.keySet())
            {
                lstTemp.add(key);
            }
            //lstTemp = mapIdToNewOrderInvoiceJunction.keySet();
            
            query = 'Select '+query+' from OSM_InvoiceLine_And_OrderLine__c where OSM_Orders_In_Invoice__c IN: lstTemp AND CC_Invoice_Item__r.IsCredited__c = false';
            
            System.debug(query);
            
            List<OSM_InvoiceLine_And_OrderLine__c> lstOrderInvoiceJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
            
            lstOrderInvoiceJunctionItem = Database.query(query);
            
            System.debug(lstOrderInvoiceJunctionItem);
            
            if(lstOrderInvoiceJunctionItem.size() > 0)
            {
                for(OSM_InvoiceLine_And_OrderLine__c objOrderInvoiceJunItem : lstOrderInvoiceJunctionItem)
                {
                    OSM_InvoiceLine_And_OrderLine__c newOrdrInvoiceJunItem = new OSM_InvoiceLine_And_OrderLine__c();
                    newOrdrInvoiceJunItem = objOrderInvoiceJunItem.clone(false, false, false, false);
                    newOrdrInvoiceJunItem.OSM_Orders_In_Invoice__c = mapIdToNewOrderInvoiceJunction.get(newOrdrInvoiceJunItem.OSM_Orders_In_Invoice__c).Id;
                    newOrdrInvoiceJunItem.CC_Invoice_Item__c = mapIdToNewInvoiceItem.get(newOrdrInvoiceJunItem.CC_Invoice_Item__c).Id;
                    
                    mapIdToNewOrderInvoiceJunctionItem.put(objOrderInvoiceJunItem.Id, newOrdrInvoiceJunItem);
                }
                
                if(mapIdToNewOrderInvoiceJunctionItem.size() > 0)
                {
                    insert mapIdToNewOrderInvoiceJunctionItem.values();
                }                
            }
                
                
            }catch(exception ex){
                
            }
            System.debug('result');
            System.debug(mapIdToNewOrderInvoiceJunctionItem);   
            
            Set<Id> set_InvId = new Set<Id>();
            for(ccrz__E_Invoice__c inv : mapIdToNewInvoice.values()){
                set_InvId.add(inv.Id);
            }
            List<ccrz__E_Invoice__c> list_InvUpdate = new List<ccrz__E_Invoice__c>();
            List<ccrz__E_Invoice__c> list_InvDelete = new List<ccrz__E_Invoice__c>();
            for(ccrz__E_Invoice__c invObj : [SELECT Id, ccrz__OriginalAmount__c, Total_Sales_Amount__c, Total_Vertex_Tax__c FROM ccrz__E_Invoice__c WHERE Id IN: set_InvId]){
                invObj.ccrz__OriginalAmount__c = invObj.Total_Sales_Amount__c + invObj.Total_Vertex_Tax__c;
                if(invObj.ccrz__OriginalAmount__c > 0){
                    list_InvUpdate.add(invObj);
                }//else{
                    //list_InvDelete.add(invObj);
                //}
            }
            if(list_IIUPdate.size()>0) update list_IIUPdate;
            if(list_InvUpdate.size() > 0)
                update list_InvUpdate; 
            //if(list_InvDelete.size() > 0)
                //delete list_InvDelete;             
        }
    }
}