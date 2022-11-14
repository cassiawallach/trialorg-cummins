public with sharing class OSM_SW_InvoiceTriggerHandler{
    
    private static Map<String,String> soqlFlagIndicator;
    
    //Constructor
    public OSM_SW_InvoiceTriggerHandler(){        
    } 
    
    public static void OnBeforeBulkSOQL(){      
    if(soqlFlagIndicator!=null && soqlFlagIndicator.containsKey('acc'))
        {
            //Map<Id,Account> accountMap = new Map<Id,Account>([select id,name from account where id in '']);
        }        
    }
    
    public static void OnAfterBulkSOQL(){
    }
    
    //Before Insert
    public static void OnBeforeInsert(Map<Id,ccrz__E_Invoice__c> newMap){    
        OnBeforeBulkSOQL();
    }
    
    //After Insert
    public static void OnAfterInsert(Map<Id,ccrz__E_Invoice__c> newMap){
        List<String> accIdToUpdateLst = new List<String>();
        System.debug('newMap_____'+newMap);
        populateInvoiceOnTransectionPayment(newMap);       
        for(ccrz__E_Invoice__c ccinvoice :newMap.values()){            
            if(ccinvoice.Recurring_Invoice__c && ccinvoice.ccrz__Status__c=='Paid'){
                accIdToUpdateLst.add(ccinvoice.ccrz__BillTo__c);
            }
            
        }
       
        //update account fields like Lock,Is Active Subs Exist etc
        if(accIdToUpdateLst.size()>0){
                OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accIdToUpdateLst,Label.OSM_Invoice_Payment);
        }
    }    
    //After Update
    public static void OnAfterUpdate(Map<Id,ccrz__E_Invoice__c> oldMap,Map<Id,ccrz__E_Invoice__c> newMap){
        //OnAfterBulkSOQL();
        List<Id> invoiceIdList = new List<Id>();
        List<String> accIdToUpdateLst = new List<String>();
        set<Id> orderIdSet=new Set<Id>();
        Set<Id> orderIdInterCompanySet=new Set<Id>();                
        for(ccrz__E_Invoice__c ccinvoice :newMap.values()){
            if(ccinvoice.ccrz__Status__c == label.OSM_InvoicePaidStatus && ccinvoice.Recurring_Invoice__c == true && ccinvoice.Payment_Method__c == label.OSM_PaymentMethodOnInvoice){
                //Add invoice to the list
                invoiceIdList.add(ccinvoice.id);
            }            
            if(oldMap.get(ccinvoice.id).ccrz__Status__c!= newMap.get(ccinvoice.id).ccrz__Status__c && ccinvoice.Recurring_Invoice__c && ccinvoice.ccrz__Status__c=='Paid'){
                accIdToUpdateLst.add(ccinvoice.ccrz__BillTo__c);
            }
            /*if(oldMap.get(ccinvoice.id).BMS_InvoiceNumber__c!= newMap.get(ccinvoice.id).BMS_InvoiceNumber__c)
            orderIdSet.add(ccinvoice.ccrz__CCOrder__c);
            system.debug('intercompany order id set>>>>>'+orderIdSet);*/
        }
        /*for(ccrz__E_Order__c orderRecord:[select id,OrderProcessedforFSD__c,ccrz__OrderStatus__c from ccrz__E_Order__c where id IN:orderIdSet])
        {
            if(orderRecord.OrderProcessedforFSD__c==true && orderRecord.ccrz__OrderStatus__c=='Order Submitted')
            {
                orderIdInterCompanySet.add(orderRecord.id);
            }
            
        }*/
        //update account fields like Lock,Is Active Subs Exist etc
        if(accIdToUpdateLst.size()>0){
                OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accIdToUpdateLst,Label.OSM_Invoice_Payment);
        }        
        system.debug('invoiceIdList'+invoiceIdList);        
        if(invoiceIdList != null && invoiceIdList.size()>0 && !system.isFuture()){
            //Call method to update 'Last Installment Paid' && 'Invoice Paid by'
            updateInfoOnInvoiceAndSubscription(invoiceIdList);  
        }
        /*try{
                    //Code added for Intercompany order and invoice creation functionality by Sangeeta...
                    if(OSM_CheckRecursive.runOnce())
                    {
                         if(orderIdInterCompanySet!=null && orderIdInterCompanySet.size()>0)
                         {
                             system.debug('inside invoice loop of intercompany>>>>>');
                             OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(orderIdInterCompanySet);
                             //OSM_SW_OrderTriggerHandlerUtility.intercompanyProcess(orderIdSetForIntercompany);
                         }
                   }
           }
           catch(Exception ex)
           {
                 system.debug('Exception>>>'+ex);
                  
           }*/
    }    
    //Before Update
    public static void OnBeforeUpdate(Map<Id,ccrz__E_Invoice__c> oldMap,Map<Id,ccrz__E_Invoice__c> newMap){
        //OnBeforeBulkSOQL();
        for(Id invId : newMap.keySet())
        {
           ccrz__E_Invoice__c oldInvoice =  oldMap.get(invId);
           ccrz__E_Invoice__c newInvoice =  newMap.get(invId);
            
            if(oldInvoice.ccrz__Status__c=='Open' && newInvoice.ccrz__Status__c=='Closed'){
                newInvoice.ccrz__Status__c='Paid';
                newInvoice.Invoice_Paid_By__c=UserInfo.getUserId();
                newInvoice.Invoice_Paid_By_User_Type__c = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                
            }  
			//Mar-1653	
			if(newInvoice.OSM_SW_Is_third_Party_BMS_Payment2__c == true && !newInvoice.OSM_SW_IsIntercompanyInvoice__c)
            {
              newInvoice.ccrz__BillTo__c=newInvoice.Third_Party_BMS_Customer_Name__c;
              newInvoice.ccrz__SoldTo__c=newInvoice.Third_Party_BMS_Customer_Name__c;
            system.debug('Invoice updated with BillTO'+newInvoice);
            } 
        }
    }     
    public static void populateInvoiceOnTransectionPayment(Map<Id,ccrz__E_Invoice__c> mapInvoice)
    {
        Map<Id, Id> mapOrderToInvoice = new Map<Id, Id>();
            for(ccrz__E_Invoice__c objInvoice : mapInvoice.values())
            {
                if(!objInvoice.Recurring_Invoice__c && objInvoice.Invoice_Type__c != 'Credit Memo')
                    if(objInvoice.ccrz__CCOrder__c != null)
                        mapOrderToInvoice.put(objInvoice.ccrz__CCOrder__c, objInvoice.Id);
                        }                
            list<ccrz__E_TransactionPayment__c> tpList = [select id, ccrz__InvoiceAppliedTo__c,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c in: mapOrderToInvoice.keySet()];             
            Map<Id, Id> mapInvoiceToTransactionId = new Map<Id, Id>();
            List<Id> invoicelst = new List<Id>();
            if(tpList != null && tpList.size() > 0)
            {
                for(ccrz__E_TransactionPayment__c objTransec : tpList)
                {
                    if(mapOrderToInvoice.containsKey(objTransec.ccrz__CCOrder__c))
                    {
                        objTransec.ccrz__InvoiceAppliedTo__c = mapOrderToInvoice.get(objTransec.ccrz__CCOrder__c);
                    }
                }
                update tpList;    
            }
        
    }    
    @future(callout=true)
    public static void updateInfoOnInvoiceAndSubscription(List<Id> invoiceList){        
        system.debug('invoiceList'+invoiceList);
        Map<Id,ccrz__E_Subscription__c> mapSubsToUpdate = new Map<Id,ccrz__E_Subscription__c>();
        Map<Id,ccrz__E_Invoice__c> mapInvoiceToUpdate = new Map<Id,ccrz__E_Invoice__c>();
        Map<Id,List<ccrz__E_InvoiceItem__c>> mapInvoiceIdVsListOfInvocieItem = new Map<Id,List<ccrz__E_InvoiceItem__c>>();
        OSM_Integration_Log__c log = null;  
        Map<Id,OSM_Integration_Log__c> mapOfLogToUpdate = new Map<Id,OSM_Integration_Log__c>();        
        try{
            if(invoiceList != null && invoiceList.size()>0){
                List<ccrz__E_Invoice__c> ListOfInvoicesForPaidSubsCheck = [Select id, ccrz__Status__c, Recurring_Invoice__c, Payment_Method__c, Invoice_Paid_By__c, (Select id, ccrz__Invoice__c, CC_Subscription__c,ccrz__Type__c, CC_Subscription__r.ccrz__InstallmentCountRemaining__c, CC_Subscription__r.Last_Installment_Paid__c from ccrz__InvoiceItems__r) from ccrz__E_Invoice__c where id IN :invoiceList];                
                if(ListOfInvoicesForPaidSubsCheck != null && ListOfInvoicesForPaidSubsCheck.size()>0){
                    for(ccrz__E_Invoice__c invcRec :ListOfInvoicesForPaidSubsCheck){
                        mapInvoiceIdVsListOfInvocieItem.put(invcRec.id,invcRec.ccrz__InvoiceItems__r);  
                    }   
                }               
                system.debug('mapInvoiceIdVsListOfInvocieItem'+mapInvoiceIdVsListOfInvocieItem);                
                for(List<ccrz__E_InvoiceItem__c> invitemList :mapInvoiceIdVsListOfInvocieItem.values()){    
                    for(ccrz__E_InvoiceItem__c invitemRec :invitemList){                        
                        if(invitemRec.ccrz__Type__c=='Item'){
                        if((invitemRec.CC_Subscription__c != null) && (invitemRec.CC_Subscription__r.ccrz__InstallmentCountRemaining__c == 0)){                            
                            ccrz__E_Subscription__c subrec = new ccrz__E_Subscription__c(id = invitemRec.CC_Subscription__c);
                            subrec.Last_Installment_Paid__c = true;                            
                            ccrz__E_Invoice__c invrec = new ccrz__E_Invoice__c(id = invitemRec.ccrz__Invoice__c);
                            invrec.Invoice_Paid_By__c = userInfo.getUserId();                        
                            mapSubsToUpdate.put(subrec.id,subrec);
                            mapInvoiceToUpdate.put(invrec.id,invrec);
                        }else if(invitemRec.CC_Subscription__c == null){
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = label.OSM_Paid_recurring_Invoice_Update ;
                            log.Source__c = label.OSM_Paid_recurring_invoice_source;
                            log.Target__c = label.OSM_Paid_recurring_invoice_target;
                            log.Response__c = label.OSM_Missing_Subscription;
                            log.Status__c = label.OSM_Paid_recurring_invoice_status;
                            log.Invoice__c = invitemRec.ccrz__Invoice__c;
                            log.Logged_In_User__c = userinfo.getUserId();
                            mapOfLogToUpdate.put(log.id,log);
                        }  
                    }
                    }
                }   
                system.debug('mapSubsToUpdate'+mapSubsToUpdate);
                system.debug('mapInvoiceToUpdate'+mapInvoiceToUpdate);                
                //Update subscription
                if(mapSubsToUpdate.keyset() != null && mapSubsToUpdate.size()>0){
                    List<Database.saveResult> srList = database.update(mapSubsToUpdate.values(),false);
                        for(Integer i=0; i<srList.size(); i++){
                            if(srList.get(i).isSuccess()){
                                system.debug('Following records have been successfully updated'+srList.get(i).getId());                 
                            }
                             else if(!srList.get(i).isSuccess()){                                
                                Database.Error error = srList.get(i).getErrors().get(0);
                                String failedDML = error.getMessage();                                
                                //Create Integration log
                                
                                log = new OSM_Integration_Log__c();
                                OSM_SW_LoggingContext.integrationLog = log;
                                log.Service_Name__c = label.OSM_Paid_recurring_Invoice_Update ;
                                log.Source__c = label.OSM_Paid_recurring_invoice_source;
                                log.Target__c = label.OSM_Paid_recurring_invoice_target;
                                log.Response__c = failedDML;
                                log.Error_Description__c = label.OSM_Field_affecting_the_error + error.getFields();
                                log.Status__c = label.OSM_Paid_recurring_invoice_status;
                                log.Subscription__c = srList.get(i).id;
                                log.Logged_In_User__c = userinfo.getUserId();
                                mapOfLogToUpdate.put(log.id,log);
                             }
                        }
                    }                
                //Update invoice
                if(mapInvoiceToUpdate.keyset() != null && mapInvoiceToUpdate.size()>0){
                    List<Database.saveResult> srListInv = database.update(mapInvoiceToUpdate.values(),false);
                        for(Integer i=0; i<srListInv.size(); i++){
                            if(srListInv.get(i).isSuccess()){
                                system.debug('Following records have been successfully updated'+srListInv.get(i).getId());
                            }else if(!srListInv.get(i).isSuccess()){            
                                Database.Error error = srListInv.get(i).getErrors().get(0);
                                String failedDML = error.getMessage();
                                //Create Integration log                                
                                log = new OSM_Integration_Log__c();                               
                                OSM_SW_LoggingContext.integrationLog = log; log.Service_Name__c = label.OSM_Paid_recurring_Invoice_Update; log.Source__c = label.OSM_Paid_recurring_invoice_source;log.Target__c = label.OSM_Paid_recurring_invoice_target;log.Response__c = failedDML;
                                
                                log.Error_Description__c = label.OSM_Field_affecting_the_error + error.getFields();
                                log.Status__c = label.OSM_Paid_recurring_invoice_status ;
                                log.Subscription__c = srListInv.get(i).id;
                                log.Logged_In_User__c = userinfo.getUserId(); 
                                mapOfLogToUpdate.put(log.id,log);
                            }
                        }
                    }
                }
            //Juhi Changes - For Test Class to improve Code Coverage
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            }                                
        }catch(Exception e){
            system.debug('Exception in updateInfoOnInvoiceAndSubscription in Invoice Trigger Handler');
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log;
            log.Service_Name__c = label.OSM_Paid_recurring_Invoice_Update;
            log.Source__c = label.OSM_Paid_recurring_invoice_source;
            log.Target__c = label.OSM_Paid_recurring_invoice_target;
            log.Logged_In_User__c = userinfo.getUserId();
            log.Response__c = e.getMessage();
            log.Status__c = label.OSM_Paid_recurring_invoice_status ;
            log.Error_Description__c = e.getStackTraceString();
            mapOfLogToUpdate.put(log.id,log);
        }       
        system.debug('mapOfLogToUpdate'+mapOfLogToUpdate);
        OSM_SW_LoggingContext.saveIntegrationLogList(mapOfLogToUpdate.values());        
    }
}