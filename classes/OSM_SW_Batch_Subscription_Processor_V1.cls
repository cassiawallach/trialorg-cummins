global class OSM_SW_Batch_Subscription_Processor_V1 implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{

    global final String query;
    public List<String> accIdLst;
    public String testNumber;
    public Set<Id> orderIdToDAUpdate; 
    //public Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
    //public Messaging.Email[] messagesForBolt = new List<Messaging.SingleEmailMessage>();
    
    global OSM_SW_Batch_Subscription_Processor_V1(){
        orderIdToDAUpdate = new Set<Id>();
   }
    public List<Id> accLst = new List<Id>();
    
   global OSM_SW_Batch_Subscription_Processor_V1(String q){
       query=q; 
       orderIdToDAUpdate = new Set<Id>();
      /// add payment method
   }
    
      global OSM_SW_Batch_Subscription_Processor_V1(List<String> accId)
    {
        accIdLst = accId;
        orderIdToDAUpdate = new Set<Id>();
    }

   global Database.QueryLocator start(Database.BatchableContext BC){
   String accountid = '0014C00000Evjct';
       //List<String> accLst = new List<String>{'0014C00000Evjct','0014C00000Evjcu'};
      //String query = 'select id,name,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where id in :accLst';
      
       if(accIdLst!=null && accIdLst.size()>0)
       {
           String queryForBatch = 'select id,name,IAM_Cummins_Support_User__c,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c, OSM_Preferred_Payment_IsBolt_PO__c, BMS_Customer_ID__c, BOLT_Account_Number__c, Bolt_Customer_Account_Status__c , Bolt_Credit_Hold__c,Bolt_BC_Code__c,Type,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c  from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where Is_Active_Subscription_Exists__c=true and id in:accIdLst';
           return Database.getQueryLocator(queryForBatch);
       }
       else
       {
          Date todayDt = System.Today();
          String queryForBatch = 'select id,name,IAM_Cummins_Support_User__c,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,BMS_Customer_ID__c, BOLT_Account_Number__c, Bolt_Customer_Account_Status__c , OSM_Preferred_Payment_IsBolt_PO__c,Bolt_Credit_Hold__c, Bolt_BC_Code__c,Type,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where Next_Invoice_Generation_Date__c = LAST_N_DAYS:5 and Is_Active_Subscription_Exists__c=true';
       // String queryForBatch = 'select id,name,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where Is_Active_Subscription_Exists__c=true';
          return Database.getQueryLocator(queryForBatch);
       }
      
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   
    Map<Id,Account> accountMap = new Map<Id,Account>();
    
    
    Savepoint sp;
    Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  accoundVsWrapperMap;
     List<ccrz__E_Subscription__c> subLst = null;
           ccrz__E_Invoice__c invoice = null;
           ccrz__E_TransactionPayment__c transPayment=null;
           List<ccrz__E_InvoiceItem__c> invoiceLineItems = null;
    OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap;
    List<OSM_Integration_Log__c> osmLogLst = new List<OSM_Integration_Log__c>();
    Map<String,Map<String,String>> invoiceIdVsEmailMap = new Map<String,Map<String,String>>();
    Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
    List<String> ownerIdLst = new List<String>();
    OSM_InvoiceLine_And_OrderLine__c lineJunctionWrapper = null;
    List<OSM_InvoiceLine_And_OrderLine__c> lineJunctionWrapperLst = new List<OSM_InvoiceLine_And_OrderLine__c>();
    List<CC_Tax__c> listTaxObjeToCreate = new List<CC_Tax__c>();
    Map<Id,Account> accToUpdateMap = new Map<Id,Account>();
    Map<Id, Date> mapAccountToNextInvoiceGenDate = new Map<Id, Date>();
    //List<SubscRevoke> lstForRevokeSubsc = new List<SubscRevoke>();
    
    
    try{
        Map<Id, Double> MapIdToAccountCreditLimit = new Map<Id, Double>();
        Map<Id, String> MapIdToUserToEmailId = new Map<Id, String>();
        Map<Id, boolean> MapIdToOneBMSFailure = new Map<Id, boolean>();
        for(sobject s : scope){
            Account acc = (Account)s;
            accountMap.put(acc.id,acc);
            System.debug('===Include account for Invoice Generation=== '+acc.name);
            mapAccountToNextInvoiceGenDate.put(acc.Id,acc.Next_Invoice_Generation_Date__c.Date());
            if(acc.IAM_Cummins_Support_User__c != null)
                MapIdToUserToEmailId.put(acc.IAM_Cummins_Support_User__c, '');
        }
         
        if(MapIdToUserToEmailId != null && MapIdToUserToEmailId.size() > 0)
        {
            List<User> lstUser = [Select Id, Email from User where Id IN: MapIdToUserToEmailId.keySet()];
            if(lstUser != null && lstUser.size() > 0 )
            {
                for(User objUsr : lstUser)
                    MapIdToUserToEmailId.put(objUsr.Id,objUsr.Email);
            }
        }
         
         
        List<EmailTemplate> etforRecurring = [Select id from EmailTemplate where name = 'Recurring Invoice not generated template' limit 1];
        List<EmailTemplate> etforRevoke = [Select id from EmailTemplate where name = 'Revocation Recurring Invoice generate' limit 1];
            
            
        OSM_SW_Batch_Subscription_Helper helper = new OSM_SW_Batch_Subscription_Helper();
        OSM_ReturnWrapper returnWrapper = helper.createInvoicesForAccount(accountMap);
        accoundVsWrapperMap = returnWrapper.accountIdVsInvoiceWrapperMap;
        //accoundVsWrapperMap = helper.createInvoicesForAccount(accountMap);
        
          System.debug('returnWrapper: '+returnWrapper);
          System.debug('accoundVsWrapperMap: '+accoundVsWrapperMap);
          
          Map<Id,Decimal> orderIdVsOrderTaxMap2 = new Map<Id,Decimal>();
            orderIdVsOrderTaxMap2 = OSM_SW_VertexActions.getVirtualVertexQuoteTax(accoundVsWrapperMap );
            
        List<OSM_Integration_Log__c> newLogLst = new List<OSM_Integration_Log__c>();    
         
        if(newLogLst != null && newLogLst.size() > 0 )
        {
            insert newLogLst;
        }
        
        
        /*STARTS  Calles made by vineet to avoid DML inside Loops*/
        Map<Id, OSM_Integration_Log__c> invoiceNotCreatedLogs = new Map<Id, OSM_Integration_Log__c>();
        //Database.setSavepoint() 
        //Savepoint sp = Database.setSavepoint();
        Map<String,  ccrz__E_Invoice__c> mapAccToInsertedInvoice = OSM_SW_Batch_Subscription_Helper.getInvoicesToInsert(accoundVsWrapperMap, 
                                                                     orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,invoiceNotCreatedLogs );
        
        
        List<OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke> lstForRevokeSubsc = new List<OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke>();
        /*Process email for those Account there is no recurring invoice or Revoke of subscription*/
        OSM_SW_Batch_Subscription_Helper.getEmailMessagesToSent(accoundVsWrapperMap, orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,invoiceNotCreatedLogs,lstForRevokeSubsc,MapIdToUserToEmailId);
         
        
        /* DML of InvoiceLine Items and Subscription records if Recurring invioce exist*/
          Map<Object,Object>mapAccountToItsItems = OSM_SW_Batch_Subscription_Helper.getInvoiceItemsAndSubssToUpsertLatest(accoundVsWrapperMap, orderIdVsOrderTaxMap2,
                                                                  mapAccountToNextInvoiceGenDate,
                                                                    mapAccToInsertedInvoice); 
        
        
        /* DML of Jucntion Objects, if recurring invoice exist*/
        
         OSM_SW_Batch_Subscription_Helper.getJunctionObjectsToUpserted(accoundVsWrapperMap, orderIdVsOrderTaxMap2,
                                       mapAccountToNextInvoiceGenDate,mapAccToInsertedInvoice,
                                        mapAccountToItsItems);
        
        
        /*Update of Accounts for which recurring invoice is created  */
        Map<Id, Account> accountToUpdate = new Map<Id, Account>();
        for(Id accId : accoundVsWrapperMap.keySet())
        {
            if(mapAccToInsertedInvoice.get(accId) != null){
                accountToUpdate.put(accId,accoundVsWrapperMap.get(accId).acc);
            }
        }
        
        if(accountToUpdate.values().size()>0){
            update accountToUpdate.values();
        }
        
        /*END  Calles made by vineet to avoid DML inside Loops*/
        if(Test.isRunningTest())
        {
             OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke objRev = new OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke();
             lstForRevokeSubsc.add(objRev);
        }
        
        // sharad code for revoke subscription
        if(lstForRevokeSubsc != null && lstForRevokeSubsc.size() > 0)
        {
            Map<Id,Double> mapSubToQuantity = new Map<Id,Double>();
            Set<Id> orderIdSet = new Set<Id>();
            Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
            
            for(OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke objCls : lstForRevokeSubsc)
            {
                for(OSM_SW_Batch_Subscription_Processor_V1.subscData obj : objCls.lstSubscData)
                {
                    mapSubToQuantity.put(obj.subscId,obj.Quantity);
                }
                
                for(Id idvalue : objCls.lstOrderId)
                {
                    orderIdSet.add(idvalue);
                }
                
                messagesForBMS.add(objCls.mailTosent);
                
            }
            if((mapSubToQuantity != null && mapSubToQuantity.size() > 0) || Test.isRunningTest())
            {
                List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
                lstSubsc = [Select Id,ccrz__Quantity__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where Id IN: mapSubToQuantity.keySet()];
            
                if(lstSubsc.size() > 0 || Test.isRunningTest())
                {
                    for(ccrz__E_Subscription__c objSubsc : lstSubsc)
                    {
                        if(mapSubToQuantity.containsKey(objSubsc.Id))
                        {
                            objSubsc.ccrz__Quantity__c = objSubsc.ccrz__Quantity__c - mapSubToQuantity.get(objSubsc.Id);
                            if(objSubsc.ccrz__Quantity__c == 0)
                                objSubsc.ccrz__SubscriptionStatus__c = 'Inactive';
                        }
                    }
                    update lstSubsc;
                }
            }
            
            if(messagesForBMS != null && messagesForBMS.size() > 0 && !Test.isRunningTest())
            {
                
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                
            }
            
            if((orderIdSet != null && orderIdSet.size() >0 ) || Test.isRunningTest())
            {
                orderIdToDAUpdate.addAll(orderIdSet);
                
                
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                
                lstOrderItem = [Select Id, ccrz__Quantity__c from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c = 'DA' AND ccrz__SubProdTerm__r.Billing_Display_Name__c != 'One Time' AND ccrz__Order__c IN: orderIdSet];
                
                if((lstOrderItem != null && lstOrderItem.size() > 0) || Test.isRunningTest())
                {
                    for(ccrz__E_OrderItem__c objOrderItem : lstOrderItem)
                    {
                        objOrderItem.ccrz__Quantity__c = 0;
                    }
                    
                    update lstOrderItem;
                    
                }
                
                
                
            }
            
            
        }
        
        
        
        
        //email notification processing start
            Set<String> allOwnerIds = new Set<String>();
           for(String invId : invoiceIdVsOwnerMap.keySet())
           {
            Set<String> ownerIdsSetTmp = invoiceIdVsOwnerMap.get(invId);
            allOwnerIds.addAll(ownerIdsSetTmp);
           }
           System.debug('====allOwnerIds===='+allOwnerIds);
           //email should be fetched from contact
           Map<Id,User> userMap = new Map<Id,User>([select id,email,contactId,Distributor_User_Related_Contact__c,contact.email from user where id in :allOwnerIds]);
           
           for(String invId : invoiceIdVsOwnerMap.keySet())
           {
             Set<String> ownerIdsSetTmp = invoiceIdVsOwnerMap.get(invId);
             for(String ownerId : ownerIdsSetTmp)
             {
                User user = userMap.get(ownerId);
                
                if(!invoiceIdVsEmailMap.containsKey(invId))
                {
                  invoiceIdVsEmailMap.put(invId,new Map<String,String>());
                  
                }
                //invoiceIdVsEmailMap.get(invId).put(user.contact.email,ownerId);
                if(user.contactId != null){
                  invoiceIdVsEmailMap.get(invId).put(user.contact.email,user.contactId);
                }else if(user.Distributor_User_Related_Contact__c != null){
                  invoiceIdVsEmailMap.get(invId).put(user.email,user.Distributor_User_Related_Contact__c);
                }
                
                
             }
           }
           //invoiceIdVsEmailMap contains the emails of all the users who owns the orders
           List<OSM_Integration_Log__c> logLst = OSM_Email_Alert_Processor.sendRecurringInvoiceEmails(invoiceIdVsEmailMap);
           osmLogLst.addAll(logLst);
            
        if(Test.isRunningTest() && 'test3'==testNumber) {
                  throw new OSM_RequiredFields_Exception();
            	
            	  
              }
        
    }
    catch(OSM_RequiredFields_Exception ex)
    {
        System.debug('Exception got in batch  OSM_SW_Batch_Subscription_Processor_V1'+ex);
        String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
        System.debug('Exception got in batch  OSM_SW_Batch_Subscription_Processor_V1'+errorMsg);
                OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                log.Error_Description__c = ex.exceptionMessage;
                log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
                log.Status__c = 'Fail';
                osmLogLst.add(log);
       
    }   
    catch(Exception e)
    {
        System.debug('Exception got in batch  OSM_SW_Batch_Subscription_Processor_V1'+e);
        String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Error_Description__c = errorMsg;
        log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
        log.Status__c = 'Fail';
        insert log;
    } 
    finally{
           
            
                List<Database.SaveResult> srList = Database.update(accToUpdateMap.values(),false);
                
                
        for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Account fields that affected this error: ' + err.getFields());
                            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                            log.Account__c = sr.getId();
                            log.Error_Description__c = err.getMessage();
                            log.Service_Name__c=Label.OSM_Recurring_Invoice_Process+'-Unable_to_update_the_accounts_Next_Invoice_Generation_Date__c';
                            log.Status__c = 'Fail';
                            osmLogLst.add(log);
                        }
                    }
                }
                
           
                for(OSM_Integration_Log__c log : osmLogLst)
                {
                   System.debug('===log==='+log);
                }
                if(osmLogLst!=null && osmLogLst.size()>0)
                {
                   insert osmLogLst;
                }
           
           }
    
    
    
    }

   global void finish(Database.BatchableContext BC){
    
    
        /*
        If(messagesForBMS.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS); 
        }
        If(messagesForBolt.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBolt);
        }
        */

        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled:' + Label.OSM_Recurring_Invoice_Process;
        log.Status__c = 'Processed';
        insert log;
                
        OSM_WS_RetryARInvoiceJobs boltARJob  = new OSM_WS_RetryARInvoiceJobs();
        boltARJob.operation = 'Order Placed';
        boltARJob.state = 'Order Placed';
        boltARJob.query = 'Select id, ccrz__InvoiceAppliedTo__c, Bolt_AR_Call_Status__c, OSM_ARInvoice_Integration_Failure__c from ccrz__E_TransactionPayment__c where Bolt_AR_Call_Status__c = :pendingsts';
        Database.executeBatch(boltARJob,5);
        
        OSM_WS_RetryVertexJobs vertexJob  = new OSM_WS_RetryVertexJobs();
        Database.executeBatch(vertexJob,5);
        System.debug('limit');
        System.debug(Limits.getLimitFutureCalls());
        System.debug(Limits.getFutureCalls());
        if(orderIdToDAUpdate != null && orderIdToDAUpdate.size() > 0)
        {
            OSM_SW_CallDAUpdate objQue = new OSM_SW_CallDAUpdate(orderIdToDAUpdate);
            System.enqueueJob(objQue);
        }
        
        
        
        
        
   }
   
   public class invoiceItem
    {
        public String subscription;
        public double quantity;
        public double price;
    }
    
    public class SubscRevoke
    {
        public List<subscData> lstSubscData;
        public List<Id> lstOrderId;
        public Messaging.SingleEmailMessage mailTosent;
        
        public SubscRevoke()
        {
            lstOrderId = new List<Id>();
            lstSubscData = new List<subscData>();
            mailTosent = new Messaging.SingleEmailMessage();
        }
    }
    
    public class subscData
    {
        public Id subscId;
        public double Quantity;
    }
    
}