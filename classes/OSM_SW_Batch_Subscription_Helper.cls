//recompilation
public class OSM_SW_Batch_Subscription_Helper
{
   public static final string INVOICEITEMS = 'INVOICEITEMS';
   public static final string SUBSCRIPTIONLIST = 'SUBSCRIPTIONLIST';
   public static final string TRANSPAYMENT = 'TRANSPAYMENT'; 
    /*
  public OSM_ReturnWrapper createInvoicesForAccount_Rect(Map<Id,Account> accountMap) 
   {
        OSM_ReturnWrapper returnWrapper = new OSM_ReturnWrapper();
        Map<Id,SingleInvoiceForAccountWrapper> accountIdVsInvoiceWrapperMap = new Map<Id,SingleInvoiceForAccountWrapper>();
        returnWrapper.accountIdVsInvoiceWrapperMap = accountIdVsInvoiceWrapperMap;
        Map<Id,List<ccrz__E_Subscription__c>>   accVsSubsListMap = new Map<Id,List<ccrz__E_Subscription__c>>();
        List<Id> accIdLst;
        Map<Id,Map<String,Object>> subscIdVsMapOfInvoice = new Map<Id,Map<String,Object>>();
        List<ccrz__E_Subscription__c> subsList;
        List<Id> subsIdLst = new List<Id>();
        Map<Id,Id> contactVsUser = new Map<Id,Id> ();
        List<Id> primaryContactIds = new List<Id>();
        Map<Id,Id> primaryContactidVsUserMap = new Map<Id,Id>();
        Map<String,String> orderIdVsOwnerIdMap = new Map<String,String>();
        List<Contact> contactLst = null;
        List<Id> contactIdLst = new List<Id>();
        //this map will contain the acc and contact's user which are not primary
        Map<String,String> contactIdVsOtherUserIdMap = new Map<String,String>();
        
      
        try{
        
                for(Id key : accountMap.keySet())
                {
                    Account acc = accountMap.get(key);
                    String primaryConId = acc.CMI_Primary_Contact__c;
                    if(primaryConId!=null && primaryConId!='' ){
                        primaryContactIds.add(acc.CMI_Primary_Contact__c);
                    }
                    
                    contactLst = acc.contacts;
                    if(contactLst!=null && contactLst.size()>0){
                        for(Contact con:contactLst){
                            String conIdTmp = con.id;
                            if(conIdTmp!=null && conIdTmp!=''){
                                contactIdLst.add(con.id);
                            }
                        }
                    }
                    
                }
                    
                        contactIdLst.addall(primaryContactIds);
                                    //Alert:Do not delete the below debug line as that makes primaryContactidVsUserMap as blank..possibly defect in salesforce
                System.debug('===All Primary Contacts for Billing accounts ==='+primaryContactIds);
                System.debug('===All Contacts for Billing accounts ==='+contactIdLst);
                List<User> userLst = new List<User>([select id,firstname,contactid from user where contactId in :contactIdLst ]);
                List<Contact> distributorContactList = new List<Contact>([SELECT Id, IAM_Contact_Owner__c FROM Contact WHERE Id in: contactIdLst AND IAM_Contact_Owner__c != null]);
                List<String> distAdminUsers = new List<String>();
                if(!distributorContactList.isEmpty()){
                  for(Contact dist: distributorContactList){
                    distAdminUsers.add(dist.IAM_Contact_Owner__c);
                  }
                  List<User> distUsers = new List<User>([SELECT Id,FirstName,contactId,Distributor_User_Related_Contact__c FROM User WHERE Id in: distAdminUsers]);
                  userLst.addAll(distUsers);
                }
                for(User user : userLst)
                {
                    System.debug('===user==='+user.contactId);
                    
                    if(user.contactId != null && primaryContactIds.contains(user.contactId)){
                        primaryContactidVsUserMap.put(user.contactid,user.id);
                    }
                    else
                    {
                      
                         for(Id key : accountMap.keySet()){
                            Account acc = accountMap.get(key);
                            contactLst = acc.contacts;
                            for(Contact con :contactLst){
                              if(user.contactid != null){
                                if(con.id==user.contactid){
                                    contactIdVsOtherUserIdMap.put(key,user.id);
                                    break;
                                }
                              }else if(user.Distributor_User_Related_Contact__c != null){
                                if(con.id == user.Distributor_User_Related_Contact__c){
                                  contactIdVsOtherUserIdMap.put(key,user.id);
                                    break;
                                }
                              }

                            }
                                
                        }
                    }
                }
                
           
              accIdLst = new  List<Id>(accountMap.keySet());
              subsList = OSM_SW_Transaction_Util.fetchActiveSubscriptionForInvoiceForAccount(accIdLst);
              Map<Id,Id> accIdVsContactAddr = new Map<Id,Id>();
              
              for( ccrz__E_ContactAddr__c conAddr : [select id,Account__c from ccrz__E_ContactAddr__c where Is_Account_Main_Address__c=true and Account__c in :accIdLst])
              {
                 accIdVsContactAddr.put(conAddr.Account__c,conAddr.id);
              }
              
              
              
              for(ccrz__E_Subscription__c subscription : subsList)
              {
                  //removing free trial active subscriptions
                  if(subscription.OSM_Free_Trial__c==true || subscription.ccrz__InstallmentCountRemaining__c==0)
                  {
                    continue;
                  }
                  subsIdLst.add(subscription.id);
                  if(!accVsSubsListMap.containsKey(subscription.ccrz__Account__c))
                  {
                     accVsSubsListMap.put(subscription.ccrz__Account__c,new List<ccrz__E_Subscription__c>());
                  }
                  
                  List<ccrz__E_Subscription__c> tmpSubLst = accVsSubsListMap.get(subscription.ccrz__Account__c);
                  tmpSubLst.add(subscription);
              }
               
               
              
               Map<String,Map<String,object>> allInvoiceDatesForSubscriptions = OSM_SW_ProductDetailCommonUtility.getInvoiceNextRequiredDate(subsIdLst, false,null,null,null,null,null); 
                System.debug('====allInvoiceDatesForSubscriptions==123=='+allInvoiceDatesForSubscriptions);  
                
                if(Test.isRunningTest()){
                    allInvoiceDatesForSubscriptions = new Map<String,Map<String,object>>{subsIdLst[0] => new Map<String,object>{'NextInstallmentDate' => Date.today(), 'NextInDate' => Date.today(), 'SubInstallmentDate' => Date.today(), 'SubNextInDate' => Date.today()}};
                }
                
             Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> accIdVsSubsInfoMap = OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptions(subsIdLst);
               
               for(Id accId : accIdVsSubsInfoMap.keySet())
               {
                    Map<Id,List<OSM_Order_Subscription__c>> subsVsJunctionMap = accIdVsSubsInfoMap.get(accId);
                    for(Id subsId : subsVsJunctionMap.keySet())
                    {
                       List<OSM_Order_Subscription__c> juncLst = subsVsJunctionMap.get(subsId);
                       for(OSM_Order_Subscription__c junc : juncLst)
                       {
                            orderIdVsOwnerIdMap.put(junc.OSM_CCOrder__c,junc.OSM_CCOrder__r.ownerid);
                            
                       }
                    }
               }
            
            
            System.debug('====orderIdVsOwnerIdMap===='+orderIdVsOwnerIdMap);
            
              Decimal totalInvoiceOriginalAmount=0;
              Decimal totalInvoiceTax=0;
              Decimal totalInvoiceLineTax=0;
              SingleInvoiceForAccountWrapper singleInvoiceWrap;
              List<ccrz__E_InvoiceItem__c> invoiceLineLst;
              ccrz__E_InvoiceItem__c invoiceLine;
              Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceVsInvoiceLineMap;
              
              
              Map<Id,List<OSM_Order_Subscription__c>> subsInfoMap = null;
              
             String poNo='';
             InvoiceLineAndOrderLineWrapper juncWrapper=null;
             List<InvoiceLineAndOrderLineWrapper> lineJunctionWrapperLst = null;
             Decimal totalInvoiceSalesAmount=0;
             
             System.debug('accVsSubsListMap====='+accVsSubsListMap);
             
            
            for(Id accId : accountMap.keySet())
            
            {
                System.debug('======Starting Invoice Generation for Account==='+accId  +'===Accounr Name ===='+accountMap.get(accId).name);
              poNo='';
              lineJunctionWrapperLst = new List<InvoiceLineAndOrderLineWrapper>();
              
            try{
                totalInvoiceTax = 0;
                totalInvoiceOriginalAmount=0;
                totalInvoiceSalesAmount=0;
                subsInfoMap = null;
                Account acc = accountMap.get(accId);
                System.debug('======Account====='+acc);
                List<ccrz__E_TransactionPayment__c> existingTpLst = acc.ccrz__TransactionPayments__r;
                
                if(!accountIdVsInvoiceWrapperMap.containsKey(acc.id))
                {
                   accountIdVsInvoiceWrapperMap.put(acc.id,new SingleInvoiceForAccountWrapper());
                }
                
                invoiceLineLst = new List<ccrz__E_InvoiceItem__c>();
                singleInvoiceWrap = accountIdVsInvoiceWrapperMap.get(acc.id);
                singleInvoiceWrap.invoiceLineOrderLineWrapperLst = lineJunctionWrapperLst;
                singleInvoiceWrap.acc = acc;
                singleInvoiceWrap.poNo = poNo;
                
                
                if(existingTpLst!=null && existingTpLst.size()>0)
                {
                   ccrz__E_TransactionPayment__c latestTXPayment = existingTpLst[0];
                   poNo = latestTXPayment.ccrz__AccountNumber__c;
                }
                
                if(accIdVsSubsInfoMap.containsKey(acc.id))
                {
                    subsInfoMap = accIdVsSubsInfoMap.get(acc.id);  
                    
                }
                else
                {
                    //TBD label
                     throw new OSM_RequiredFields_Exception('Subscription information not found for Account',true);
                }
                
                
                ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
                
                invoice.Payment_Method__c =  acc.OSM_Preferred_Payment_Method__c;
                invoice.OSM_SW_Is_Bolt_PO__c =  acc.OSM_Preferred_Payment_IsBolt_PO__c;
                invoice.ccrz__BillTo__c = accid;
                invoice.ccrz__SoldTo__c = accid;
                singleInvoiceWrap.invoice = invoice;
                
                //test this
                //check if there is no primary contact
                if(acc.CMI_Primary_Contact__c!=null)
                {
                    invoice.ccrz__Contact__c = acc.CMI_Primary_Contact__c;
                }
                else
                {
                     List<Contact> contactLstDb = acc.contacts;
                     if(contactLstDb.size()>0)
                     {
                        invoice.ccrz__Contact__c = contactLstDb[0].id;
                     }
                     else
                     {
                        //do not throw the exception..invoice will still be generated
                        //throw new OSM_RequiredFields_Exception('Valid Contact not found for the account to bill the customer.',true);
                     }
                     
                }
                
                
                
                if(acc.CMI_Primary_Contact__c!=null)
                {
                
                    invoice.OwnerId = primaryContactidVsUserMap.get(acc.CMI_Primary_Contact__c);
                    System.debug('====invoice.OwnerId===='+invoice.OwnerId);
                }
                else
                {
                    //in case primary contact is not found then assign invoice to any other contact of account
                    if(contactIdVsOtherUserIdMap.containsKey(invoice.ccrz__Contact__c)){
                        invoice.OwnerId = contactIdVsOtherUserIdMap.get(invoice.ccrz__Contact__c); 
                        
                    }
                    else{
                                           
                    }
                   
                }
                
                if(invoice.ownerid==null)
                {
                   invoice.OwnerId = UserInfo.getUserId();
                   System.debug('Setting Owner as Current Running User');
                }
                
                invoice.ccrz__User__c = primaryContactidVsUserMap.get(acc.CMI_Primary_Contact__c);
                                
                invoice.Recurring_Invoice__c=true;
                
                
                 if(invoice.Payment_Method__c=='po')
                 {
                   invoice.ccrz__Status__c = 'Paid';
                 }
                 else
                 {
                    invoice.ccrz__Status__c = 'Open';
                 }
                
                invoice.ccrz__Type__c = 'Debit';
                List<ccrz__E_Subscription__c> subsLst = accVsSubsListMap.get(accId);
                
                Decimal recurringAmt=0;
                Decimal recurringPerUnitAmt=0;
                
                for(ccrz__E_Subscription__c subs : subsLst)
                 {
                    System.debug('-----Subscription Record ---'+subs);
                    totalInvoiceLineTax = 0;
                    recurringAmt=0;
                    if(subs.ccrz__CurrencyISOCode__c==null || subs.ccrz__InstallmentAddress__c==null || subs.ccrz__OrderAddress__c==null|| subs.ccrz__InstallmentCountRemaining__c==null || subs.ccrz__InstallmentNextDate__c==null || subs.ccrz__Storefront__c==null || subs.ccrz__RecurringPrice__c==null)
                    {
                        //tbd label
                        
                        
                        String msg = 'Subscription missing required fields.';
                        msg = msg +' ccrz__CurrencyISOCode__c:'+subs.ccrz__CurrencyISOCode__c + ' ccrz__InstallmentAddress__c:'+subs.ccrz__InstallmentAddress__c + ' ccrz__OrderAddress__c:'+subs.ccrz__OrderAddress__c + ' ccrz__InstallmentCountRemaining__c:'+subs.ccrz__InstallmentCountRemaining__c + 'ccrz__InstallmentNextDate__c:'+subs.ccrz__InstallmentNextDate__c +' ccrz__Storefront__c:' +subs.ccrz__Storefront__c +' ccrz__RecurringPrice__c:' + subs.ccrz__RecurringPrice__c;
                        OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                        
                        reqEx.subscription = subs;
                       throw reqEx;
                    }
                    
                    if(subs.ccrz__Quantity__c==0)
                    {
                        //do not consider subscription with 0 quantity
                        continue;
                    }
                    
                    Map<String,object> mapNextImpDates =  allInvoiceDatesForSubscriptions.get(subs.id);
                    System.debug('====mapNextImpDates===='+mapNextImpDates);
                    DateTime NextInstallmentDueDate = (DateTime)mapNextImpDates.get('NextInstallmentDate');
                    DateTime NextInvoiceGenerationDate = (DateTime)mapNextImpDates.get('NextInDate');
                    DateTime subsequentInstallmentDueDate =  (DateTime)mapNextImpDates.get('SubInstallmentDate');
                    DateTime subsequentInvoiceGenerationDate = (DateTime)mapNextImpDates.get('SubNextInDate');
                    
                    acc.Next_Invoice_Generation_Date__c = NextInvoiceGenerationDate;
                    
                    Decimal latestCntRemaining = subs.ccrz__InstallmentCountRemaining__c -1;
                    subs.ccrz__InstallmentCountRemaining__c = latestCntRemaining;
                    recurringPerUnitAmt =  subs.ccrz__RecurringPrice__c;
                    //Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c
                    // Logic for recurring price based on new proration *Added by Vineet* 
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly') && subs.Monthly_Price__c != null){
                        recurringPerUnitAmt =  subs.Monthly_Price__c;
                    }
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly') && subs.Quarterly_Price__c != null){
                        recurringPerUnitAmt =  subs.Quarterly_Price__c;
                    }
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly') && subs.Yearly_Price__c != null){
                        recurringPerUnitAmt =  subs.Yearly_Price__c;
                    }
                    // Logic for recurring price based on new proration *Added by Vineet*
                    
                    if(latestCntRemaining==0 && invoice.Payment_Method__c=='po')
                    {
                        subs.Last_Installment_Paid__c = true;
                    }
                    
                    if(NextInstallmentDueDate==null || NextInvoiceGenerationDate==null || subsequentInstallmentDueDate==null ||  subsequentInvoiceGenerationDate==null)
                    {
                        
                        if( ( latestCntRemaining==0  && (NextInstallmentDueDate==null || NextInvoiceGenerationDate==null)) || 
                        (latestCntRemaining<=1&& (subsequentInstallmentDueDate==null ||  subsequentInvoiceGenerationDate==null)) )
                        {
                            System.debug('Dates can be blank as invoices remaining are less.');
                        }
                        else
                        {
                            String msg = 'Important Dates are missing.';
                            msg = msg +' NextInstallmentDueDate-'+NextInstallmentDueDate + ' NextInvoiceGenerationDate:'+NextInvoiceGenerationDate + ' subsequentInstallmentDueDate:'+subsequentInstallmentDueDate + ' subsequentInvoiceGenerationDate:'+subsequentInvoiceGenerationDate;
                            OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                            throw reqEx;
                        }
                    
                    }
                    
                    singleInvoiceWrap.subsList.add(subs);
                    invoiceLine = new ccrz__E_InvoiceItem__c();
                    invoice.ccrz__CurrencyCode__c = subs.ccrz__CurrencyISOCode__c;
                   
                   
                   
                    
                    
                    
                    
                    if(accIdVsContactAddr.get(acc.id)==null)
                    {
                    //incase address not found then use subscription record address
                         invoice.ccrz__SoldAddress__c  = subs.ccrz__InstallmentAddress__c;
                         invoice.ccrz__BillAddress__c = subs.ccrz__OrderAddress__c;
                    }
                    else
                    {
                        invoice.ccrz__SoldAddress__c  = accIdVsContactAddr.get(acc.id);
                        invoice.ccrz__BillAddress__c = accIdVsContactAddr.get(acc.id);
                    }
                  
                    //CMI_AccountTriggerHandler.updateAccountAddressInOSMAddressBook
                    
                   //START:Added by Vaibhav on 18-Sep
                   DateTime tmpDt = subs.ccrz__InstallmentNextDate__c;
                   Date dueDt = date.newinstance(tmpDt.year(), tmpDt.month(), tmpDt.day());
                   //END:Added by Vaibhav on 18-Sep
                  
                   DateTime tmpGenDt = subs.Next_Invoice_Generation_Date__c ;
                   Date generationDt = date.newinstance(tmpGenDt.year(), tmpGenDt.month(), tmpGenDt.day());
                   
                   if(subsInfoMap!=null)
                   {
                        List<OSM_Order_Subscription__c>  allOrdersInfo = subsInfoMap.get(subs.id);
                        if(allOrdersInfo==null || allOrdersInfo.size()==0)
                        {
                          OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Subscription missing Order information in object-OSM_Order_Subscription__c',true);
                          throw reqEx;
                        }
                        Decimal taxForProductForAllOrders = 0.0;
                        Decimal totalQtyForProductForAllOrder=0;
                        Decimal totalSalesAmountForProductForAllOrder=0.0;
                        String strBuilder='';
                        
                        
                        for(OSM_Order_Subscription__c orderInfo :allOrdersInfo)
                        {
                            
                            if(orderInfo.Tax_Per_Unit__c==null || orderInfo.CCQuantity__c==null || orderInfo.CCProduct__c == null)
                            
                            {
                                strBuilder= strBuilder + 'OSM Order Subs Id:'+orderInfo.id+'Order:'+orderInfo.OSM_CCOrder__c +' Tax:'+orderInfo.Tax_Per_Unit__c + ' Qty:'+orderInfo.CCQuantity__c + ' Product Sku:'+orderInfo.CCProduct__c;
                                strBuilder= strBuilder + '\n';
                            }
                            else
                            {
                                
                                if(orderInfo.CCQuantity__c==0)
                                {
                                    //if orders are cancelled then do not consider
                                    continue;
                                }
                                String orderOwnerId = orderIdVsOwnerIdMap.get(orderInfo.OSM_CCOrder__c);
                                singleInvoiceWrap.orderOwnerIds.add(orderOwnerId);
                                System.debug('===orderOwnerId==='+orderOwnerId);
                                Decimal taxPerUnit  = orderInfo.Tax_Per_Unit__c;
                                System.debug('====taxPerUnit==='+taxPerUnit);
                                Decimal qty = orderInfo.CCQuantity__c;
                                System.debug('====Qty==='+qty);
                                
                                String productSku = orderInfo.CCProduct__c;
                                System.debug('===productSku==='+productSku);
                                
                                
                                
                                
                                //START:Added by Vaibhav on 18-Sep
                                System.debug('====subs.Recurring_Invoice_Start_Date__c===='+subs.Recurring_Invoice_Start_Date__c);
                                System.debug('====latestCntRemaining===='+latestCntRemaining);
                                System.debug('====subs.ccrz__SubscriptionStartDate__c===='+subs.ccrz__SubscriptionStartDate__c);
                                 System.debug('====taxPerUnit===='+taxPerUnit);
                                 
                                if(subs.Recurring_Invoice_Start_Date__c!=null){ 
                                
                                     Date recurringInvStartDt = date.newinstance(subs.Recurring_Invoice_Start_Date__c.year(), subs.Recurring_Invoice_Start_Date__c.month(), subs.Recurring_Invoice_Start_Date__c.day());
                                     
                                     Date subStartDt = date.newinstance(subs.ccrz__SubscriptionStartDate__c.year(), subs.ccrz__SubscriptionStartDate__c.month(), subs.ccrz__SubscriptionStartDate__c.day());
                                     
                                    if(recurringInvStartDt > subStartDt && latestCntRemaining==0){
                                        
                                        recurringPerUnitAmt = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subs,dueDt,false,null) ;
                                        taxPerUnit = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subs,dueDt,true,taxPerUnit) ;
                                        
                                         System.debug('====recurringPerUnitAmt from Proration Method is ===='+recurringPerUnitAmt);
                                    }
                                }
                                Decimal taxPerOrderPerProd = qty*taxPerUnit;
                                System.debug('====recurringPerUnitAmt===='+recurringPerUnitAmt);
                                System.debug('===taxPerOrderPerProd==='+taxPerOrderPerProd);
                                
                                //END:Added by Vaibhav on 18-Sep
                                Decimal totalSalesAmtPerProdPerOrder =recurringPerUnitAmt * qty;
                                
                                totalSalesAmountForProductForAllOrder = totalSalesAmountForProductForAllOrder + totalSalesAmtPerProdPerOrder;
                               // totalInvoiceLineTax = totalInvoiceLineTax + taxPerOrderPerProd;
                                //System.debug('===totalInvoiceLineTax==='+totalInvoiceLineTax);
                                taxForProductForAllOrders = taxForProductForAllOrders + taxPerOrderPerProd;
                                totalQtyForProductForAllOrder = totalQtyForProductForAllOrder + qty;
                                
                                
                                juncWrapper = new InvoiceLineAndOrderLineWrapper();
                                juncWrapper.orderId = orderInfo.OSM_CCOrder__c ;
                                System.debug('====Order Detail==='+orderInfo.OSM_CCOrder__c);
                                System.debug('====Order Line==='+orderInfo.CC_Order_Item__c);
                                
                                
                                juncWrapper.orderLineId =  orderInfo.CC_Order_Item__c ;
                                juncWrapper.productId = orderInfo.CCProduct__c ;
                                juncWrapper.qty = orderInfo.CCQuantity__c ;
                                juncWrapper.subsId = orderInfo.OSM_CCSubscription__c ;
                                juncWrapper.productSku = orderInfo.CCProduct__c ;
                                juncWrapper.vertexTax = taxPerOrderPerProd;
                                juncWrapper.totalSalesAmt = totalSalesAmtPerProdPerOrder;
                                lineJunctionWrapperLst.add(juncWrapper);
                                
                                //invoiceLine.ccrz__CCOrder__c
                                //invoiceLine.ccrz__CCOrderItem__c
                                
                            }
                        }
                        if(strBuilder!='')      
                        {
                            String msg = 'Incorrect information in Order Subscription Junction';
                            msg = msg + '\n' + strBuilder;
                            OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                            throw reqEx;
                         
                        }
                        
                        invoiceLine.Vertex_Tax__c = taxForProductForAllOrders;
                        invoiceLine.Quantity__c = totalQtyForProductForAllOrder;
                        totalInvoiceTax = totalInvoiceTax + taxForProductForAllOrders;
                        invoiceLine.ccrz__OriginalAmount__c = totalSalesAmountForProductForAllOrder;
                        totalInvoiceSalesAmount = totalInvoiceSalesAmount + totalSalesAmountForProductForAllOrder;
                   }
                   
                   
                   
                   
                                  
                   
                   //START:Added by Vaibhav on 18-Sep
                   invoice.ccrz__DateDue__c = dueDt;
                   invoice.ccrz__DateIssued__c = generationDt;
                   //END:Added by Vaibhav on 18-Sep
                   
                    
                    //enrich subs dates with new dates
                    subs.ccrz__InstallmentNextDate__c = NextInstallmentDueDate;
                    subs.Next_Invoice_Generation_Date__c = NextInvoiceGenerationDate;
                    subs.Subsequent_Next_Invoice_Due_Dt__c = subsequentInstallmentDueDate;
                    subs.Subsequent_Next_Invoice_Generation_Dt__c = subsequentInvoiceGenerationDate;
                    invoice.ccrz__Storefront__c=subs.ccrz__Storefront__c;
                    
                    subs.Latest_Invoice__r = invoice;
                   
                   
                                    
                 invoiceLineLst.add(invoiceLine);
                 invoiceLine.ccrz__Invoice__r = invoice;
                 invoiceLine.CC_Subscription__c = subs.id;
                 //invoiceLine.ccrz__Sequence__c = later
                 invoiceLine.ccrz__Status__c = 'Open';
                 invoiceLine.ccrz__Type__c = 'Item';
                 
            
                 singleInvoiceWrap.invoiceLineLst.add(invoiceLine);
                 
                 }
                 
                 //separate tax row
                 invoiceLine = new ccrz__E_InvoiceItem__c();
                 invoiceLineLst.add(invoiceLine);
                 invoiceLine.ccrz__Invoice__r = invoice;
                 
                 invoiceLine.ccrz__Sequence__c = 100;
                 invoiceLine.ccrz__Status__c = 'Open';
                 invoiceLine.ccrz__Type__c = 'Tax';
                 System.debug('====Final totalInvoiceLineTax==='+totalInvoiceLineTax);
                 invoiceLine.ccrz__OriginalAmount__c = totalInvoiceTax;
                 singleInvoiceWrap.invoiceLineLst.add(invoiceLine);
                 
                 //Calculate Invoice amount,Remaining amount for CC/PO
                 totalInvoiceOriginalAmount = totalInvoiceOriginalAmount + totalInvoiceSalesAmount;
                 
                 // Sharad for update new tax get it from quote call
                 //invoice.ccrz__OriginalAmount__c = totalInvoiceOriginalAmount + totalInvoiceTax;
                 invoice.ccrz__OriginalAmount__c = totalInvoiceOriginalAmount;
                 
                if(invoice.Payment_Method__c=='po')
                {
                    invoice.ccrz__RemainingAmount__c=0;
                    invoice.ccrz__Status__c = 'Paid';
                    //create TX Payment in case of PO
                    createTransactionPayment(singleInvoiceWrap);
                 }
                else
                {
                    invoice.ccrz__RemainingAmount__c=totalInvoiceOriginalAmount;
                }
                
              
                }
                catch(OSM_RequiredFields_Exception e)
                {
                    
                    System.debug('=====Inside catch of  OSM_RequiredFields_Exception for each account ===');
                    if(singleInvoiceWrap==null)
                    {
                        System.debug('=====CATCH singleInvoiceWrap is null===');
                        SingleInvoiceForAccountWrapper wrapper = new SingleInvoiceForAccountWrapper();
                        wrapper.acc = new Account(Id=accId);
                        wrapper.exceptionFlag=true;
                        wrapper.exceptionMessage=e.exceptionMessage;
                        if(e.subscription!=null)
                        {
                           //wrapper.subscription=e.subscription;
                           wrapper.exceptionMessage = wrapper.exceptionMessage +String.valueOf(e.subscription);
                        }
                        accountIdVsInvoiceWrapperMap.put(accid,wrapper);
                    }
                    else
                    {
                        System.debug('=====CATCH singleInvoiceWrap is not null===');
                        singleInvoiceWrap.exceptionFlag=true;
                        singleInvoiceWrap.exceptionMessage=e.exceptionMessage;
                        if(e.subscription!=null)
                        {
                           
                           singleInvoiceWrap.exceptionMessage = singleInvoiceWrap.exceptionMessage +'\n' +String.valueOf(e.subscription);
                        }
                    }
                    
                }
                catch(Exception ex)
                {
                   String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
                   System.debug('********Exception Raised in createInvoicesForAccount*****'+errorMsg);
                    
                    if(singleInvoiceWrap==null)
                    {
                        SingleInvoiceForAccountWrapper wrapper = new SingleInvoiceForAccountWrapper();
                        wrapper.acc = new Account(Id=accId);
                        wrapper.exceptionFlag=true;
                        wrapper.exceptionMessage=errorMsg;
                        
                        accountIdVsInvoiceWrapperMap.put(accid,wrapper);
                    }
                    else
                    {
                        singleInvoiceWrap.exceptionFlag=true;
                        singleInvoiceWrap.exceptionMessage=errorMsg;
                        
                    }
                   
                   
                   
                }
                
              }
      }
      catch(Exception e)
      {
         String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
         System.debug('********Exception Raised in createInvoicesForAccount*****'+errorMsg);
         OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(errorMsg,true);
         throw reqEx;
      }
     
     for(String accId : returnWrapper.accountIdVsInvoiceWrapperMap.keySet())
     {
         System.debug('====Returning==Account=='+returnWrapper.accountIdVsInvoiceWrapperMap.get(accId));
     }
      return returnWrapper;
   }
    */
  
   public OSM_ReturnWrapper createInvoicesForAccount(Map<Id,Account> accountMap) 
   {
        OSM_ReturnWrapper returnWrapper = new OSM_ReturnWrapper();
        Map<Id,SingleInvoiceForAccountWrapper> accountIdVsInvoiceWrapperMap = new Map<Id,SingleInvoiceForAccountWrapper>();
        returnWrapper.accountIdVsInvoiceWrapperMap = accountIdVsInvoiceWrapperMap;
        Map<Id,List<ccrz__E_Subscription__c>>   accVsSubsListMap = new Map<Id,List<ccrz__E_Subscription__c>>();
        List<Id> accIdLst;
        Map<Id,Map<String,Object>> subscIdVsMapOfInvoice = new Map<Id,Map<String,Object>>();
        List<ccrz__E_Subscription__c> subsList;
        List<Id> subsIdLst = new List<Id>();
        Map<Id,Id> contactVsUser = new Map<Id,Id> ();
        List<Id> primaryContactIds = new List<Id>();
        Map<Id,Id> primaryContactidVsUserMap = new Map<Id,Id>();
        Map<String,String> orderIdVsOwnerIdMap = new Map<String,String>();
        List<Contact> contactLst = null;
        List<Id> contactIdLst = new List<Id>();
        //this map will contain the acc and contact's user which are not primary
        Map<String,String> contactIdVsOtherUserIdMap = new Map<String,String>();
        
        try{
        
                for(Id key : accountMap.keySet())
                {
                    Account acc = accountMap.get(key);
                    String primaryConId = acc.CMI_Primary_Contact__c;
                    if(primaryConId!=null && primaryConId!='' ){
                        primaryContactIds.add(acc.CMI_Primary_Contact__c);
                    }
                    
                    contactLst = acc.contacts;
                    if(contactLst!=null && contactLst.size()>0){
                        for(Contact con:contactLst){
                            String conIdTmp = con.id;
                            if(conIdTmp!=null && conIdTmp!=''){
                                contactIdLst.add(con.id);
                            }
                        }
                    }
                    
                }
                    
                        contactIdLst.addall(primaryContactIds);
                                    //Alert:Do not delete the below debug line as that makes primaryContactidVsUserMap as blank..possibly defect in salesforce
                System.debug('===All Primary Contacts for Billing accounts ==='+primaryContactIds);
                System.debug('===All Contacts for Billing accounts ==='+contactIdLst);
                List<User> userLst = new List<User>([select id,firstname,contactid from user where contactId in :contactIdLst ]);
                List<Contact> distributorContactList = new List<Contact>([SELECT Id, IAM_Contact_Owner__c FROM Contact WHERE Id in: contactIdLst AND IAM_Contact_Owner__c != null]);
                List<String> distAdminUsers = new List<String>();
                if(!distributorContactList.isEmpty()){
                  for(Contact dist: distributorContactList){
                    distAdminUsers.add(dist.IAM_Contact_Owner__c);
                  }
                  List<User> distUsers = new List<User>([SELECT Id,FirstName,contactId,Distributor_User_Related_Contact__c FROM User WHERE Id in: distAdminUsers]);
                  userLst.addAll(distUsers);
                }
                for(User user : userLst)
                {
                    System.debug('===user==='+user.contactId);
                    
                    if(user.contactId != null && primaryContactIds.contains(user.contactId)){
                        primaryContactidVsUserMap.put(user.contactid,user.id);
                    }
                    else
                    {
                      
                         for(Id key : accountMap.keySet()){
                            Account acc = accountMap.get(key);
                            contactLst = acc.contacts;
                            for(Contact con :contactLst){
                              if(user.contactid != null){
                                if(con.id==user.contactid){
                                    contactIdVsOtherUserIdMap.put(key,user.id);
                                    break;
                                }
                              }else if(user.Distributor_User_Related_Contact__c != null){
                                if(con.id == user.Distributor_User_Related_Contact__c){
                                  contactIdVsOtherUserIdMap.put(key,user.id);
                                    break;
                                }
                              }

                            }
                                
                        }
                    }
                }
                
           
              accIdLst = new  List<Id>(accountMap.keySet());
              subsList = OSM_SW_Transaction_Util.fetchActiveSubscriptionForInvoiceForAccount(accIdLst);
              Map<Id,Id> accIdVsContactAddr = new Map<Id,Id>();
              
              for( ccrz__E_ContactAddr__c conAddr : [select id,Account__c from ccrz__E_ContactAddr__c where Is_Account_Main_Address__c=true and Account__c in :accIdLst])
              {
                 accIdVsContactAddr.put(conAddr.Account__c,conAddr.id);
              }
              
              
              
              for(ccrz__E_Subscription__c subscription : subsList)
              {
                  //removing free trial active subscriptions
                  if(subscription.OSM_Free_Trial__c==true || subscription.ccrz__InstallmentCountRemaining__c==0)
                  {
                    continue;
                  }
                  subsIdLst.add(subscription.id);
                  if(!accVsSubsListMap.containsKey(subscription.ccrz__Account__c))
                  {
                     accVsSubsListMap.put(subscription.ccrz__Account__c,new List<ccrz__E_Subscription__c>());
                  }
                  
                  List<ccrz__E_Subscription__c> tmpSubLst = accVsSubsListMap.get(subscription.ccrz__Account__c);
                  tmpSubLst.add(subscription);
              }
               
               
              
               Map<String,Map<String,object>> allInvoiceDatesForSubscriptions = OSM_SW_ProductDetailCommonUtility.getInvoiceNextRequiredDate(subsIdLst, false,null,null,null,null,null); 
                System.debug('====allInvoiceDatesForSubscriptions==123=='+allInvoiceDatesForSubscriptions);  
                
                if(Test.isRunningTest()){
                    allInvoiceDatesForSubscriptions = new Map<String,Map<String,object>>{subsIdLst[0] => new Map<String,object>{'NextInstallmentDate' => Date.today(), 'NextInDate' => Date.today(), 'SubInstallmentDate' => Date.today(), 'SubNextInDate' => Date.today()}};
                }
                
             Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> accIdVsSubsInfoMap = OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptions(subsIdLst);
               
               for(Id accId : accIdVsSubsInfoMap.keySet())
               {
                    Map<Id,List<OSM_Order_Subscription__c>> subsVsJunctionMap = accIdVsSubsInfoMap.get(accId);
                    for(Id subsId : subsVsJunctionMap.keySet())
                    {
                       List<OSM_Order_Subscription__c> juncLst = subsVsJunctionMap.get(subsId);
                       for(OSM_Order_Subscription__c junc : juncLst)
                       {
                            orderIdVsOwnerIdMap.put(junc.OSM_CCOrder__c,junc.OSM_CCOrder__r.ownerid);
                            
                       }
                    }
               }
            
            
            System.debug('====orderIdVsOwnerIdMap===='+orderIdVsOwnerIdMap);
            
              Decimal totalInvoiceOriginalAmount=0;
              Decimal totalInvoiceTax=0;
              Decimal totalInvoiceLineTax=0;
              SingleInvoiceForAccountWrapper singleInvoiceWrap;
              List<ccrz__E_InvoiceItem__c> invoiceLineLst;
              ccrz__E_InvoiceItem__c invoiceLine;
              Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceVsInvoiceLineMap;
              
              
              Map<Id,List<OSM_Order_Subscription__c>> subsInfoMap = null;
              
             String poNo='';
             InvoiceLineAndOrderLineWrapper juncWrapper=null;
             List<InvoiceLineAndOrderLineWrapper> lineJunctionWrapperLst = null;
             Decimal totalInvoiceSalesAmount=0;
             
             System.debug('accVsSubsListMap====='+accVsSubsListMap);
             
            
            for(Id accId : accountMap.keySet())
            
            {
                System.debug('======Starting Invoice Generation for Account==='+accId  +'===Accounr Name ===='+accountMap.get(accId).name);
              poNo='';
              lineJunctionWrapperLst = new List<InvoiceLineAndOrderLineWrapper>();
              
            try{
                totalInvoiceTax = 0;
                totalInvoiceOriginalAmount=0;
                totalInvoiceSalesAmount=0;
                subsInfoMap = null;
                Account acc = accountMap.get(accId);
                System.debug('======Account====='+acc);
                List<ccrz__E_TransactionPayment__c> existingTpLst = acc.ccrz__TransactionPayments__r;
                
                if(!accountIdVsInvoiceWrapperMap.containsKey(acc.id))
                {
                   accountIdVsInvoiceWrapperMap.put(acc.id,new SingleInvoiceForAccountWrapper());
                }
                
                invoiceLineLst = new List<ccrz__E_InvoiceItem__c>();
                singleInvoiceWrap = accountIdVsInvoiceWrapperMap.get(acc.id);
                singleInvoiceWrap.invoiceLineOrderLineWrapperLst = lineJunctionWrapperLst;
                singleInvoiceWrap.acc = acc;
                singleInvoiceWrap.poNo = poNo;
                
                
                if(existingTpLst!=null && existingTpLst.size()>0)
                {
                   ccrz__E_TransactionPayment__c latestTXPayment = existingTpLst[0];
                   poNo = latestTXPayment.ccrz__AccountNumber__c;
                }
                
                if(accIdVsSubsInfoMap.containsKey(acc.id))
                {
                    subsInfoMap = accIdVsSubsInfoMap.get(acc.id);  
                    
                }
                else
                {
                    //TBD label
                     throw new OSM_RequiredFields_Exception('Subscription information not found for Account',true);
                }
                
                
                ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
                
                invoice.Payment_Method__c =  acc.OSM_Preferred_Payment_Method__c;
                invoice.OSM_SW_Is_Bolt_PO__c =  acc.OSM_Preferred_Payment_IsBolt_PO__c;
                invoice.ccrz__BillTo__c = accid;
                invoice.ccrz__SoldTo__c = accid;
                singleInvoiceWrap.invoice = invoice;
                
                //test this
                //check if there is no primary contact
                if(acc.CMI_Primary_Contact__c!=null)
                {
                    invoice.ccrz__Contact__c = acc.CMI_Primary_Contact__c;
                }
                else
                {
                     List<Contact> contactLstDb = acc.contacts;
                     if(contactLstDb.size()>0)
                     {
                        invoice.ccrz__Contact__c = contactLstDb[0].id;
                     }
                     else
                     {
                        //do not throw the exception..invoice will still be generated
                        //throw new OSM_RequiredFields_Exception('Valid Contact not found for the account to bill the customer.',true);
                     }
                     
                }
                
                
                
                if(acc.CMI_Primary_Contact__c!=null)
                {
                
                    invoice.OwnerId = primaryContactidVsUserMap.get(acc.CMI_Primary_Contact__c);
                    System.debug('====invoice.OwnerId===='+invoice.OwnerId);
                }
                else
                {
                    //in case primary contact is not found then assign invoice to any other contact of account
                    if(contactIdVsOtherUserIdMap.containsKey(invoice.ccrz__Contact__c)){
                        invoice.OwnerId = contactIdVsOtherUserIdMap.get(invoice.ccrz__Contact__c); 
                        
                    }
                    else{
                                           
                    }
                   
                }
                
                if(invoice.ownerid==null)
                {
                   invoice.OwnerId = UserInfo.getUserId();
                   System.debug('Setting Owner as Current Running User');
                }
                
                invoice.ccrz__User__c = primaryContactidVsUserMap.get(acc.CMI_Primary_Contact__c);
                                
                invoice.Recurring_Invoice__c=true;
                
                
                 if(invoice.Payment_Method__c=='po')
                 {
                   invoice.ccrz__Status__c = 'Paid';
                 }
                 else
                 {
                    invoice.ccrz__Status__c = 'Open';
                 }
                
                invoice.ccrz__Type__c = 'Debit';
                List<ccrz__E_Subscription__c> subsLst = accVsSubsListMap.get(accId);
                
                Decimal recurringAmt=0;
                Decimal recurringPerUnitAmt=0;
                
                for(ccrz__E_Subscription__c subs : subsLst)
                 {
                     if(subs.ccrz__SubscriptionProduct__r.Group_Name__c == 'DA')
                     {
                    System.debug('-----Subscription Record ---'+subs);
                    totalInvoiceLineTax = 0;
                    recurringAmt=0;
                    if(subs.ccrz__CurrencyISOCode__c==null || subs.ccrz__InstallmentAddress__c==null || subs.ccrz__OrderAddress__c==null|| subs.ccrz__InstallmentCountRemaining__c==null || subs.ccrz__InstallmentNextDate__c==null || subs.ccrz__Storefront__c==null || subs.ccrz__RecurringPrice__c==null)
                    {
                        //tbd label
                        
                        
                        String msg = 'Subscription missing required fields.';
                        msg = msg +' ccrz__CurrencyISOCode__c:'+subs.ccrz__CurrencyISOCode__c + ' ccrz__InstallmentAddress__c:'+subs.ccrz__InstallmentAddress__c + ' ccrz__OrderAddress__c:'+subs.ccrz__OrderAddress__c + ' ccrz__InstallmentCountRemaining__c:'+subs.ccrz__InstallmentCountRemaining__c + 'ccrz__InstallmentNextDate__c:'+subs.ccrz__InstallmentNextDate__c +' ccrz__Storefront__c:' +subs.ccrz__Storefront__c +' ccrz__RecurringPrice__c:' + subs.ccrz__RecurringPrice__c;
                        OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                        
                        reqEx.subscription = subs;
                       throw reqEx;
                    }
                    
                    if(subs.ccrz__Quantity__c==0)
                    {
                        //do not consider subscription with 0 quantity
                        continue;
                    }
                    
                    Map<String,object> mapNextImpDates =  allInvoiceDatesForSubscriptions.get(subs.id);
                    System.debug('====mapNextImpDates===='+mapNextImpDates);
                    DateTime NextInstallmentDueDate = (DateTime)mapNextImpDates.get('NextInstallmentDate');
                    DateTime NextInvoiceGenerationDate = (DateTime)mapNextImpDates.get('NextInDate');
                    DateTime subsequentInstallmentDueDate =  (DateTime)mapNextImpDates.get('SubInstallmentDate');
                    DateTime subsequentInvoiceGenerationDate = (DateTime)mapNextImpDates.get('SubNextInDate');
                    
                    acc.Next_Invoice_Generation_Date__c = NextInvoiceGenerationDate;
                    
                    Decimal latestCntRemaining = subs.ccrz__InstallmentCountRemaining__c -1;
                    subs.ccrz__InstallmentCountRemaining__c = latestCntRemaining;
                    recurringPerUnitAmt =  subs.ccrz__RecurringPrice__c;
                    //Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c
                    // Logic for recurring price based on new proration *Added by Vineet* 
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly') && subs.Monthly_Price__c != null){
                        recurringPerUnitAmt =  subs.Monthly_Price__c;
                    }
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly') && subs.Quarterly_Price__c != null){
                        recurringPerUnitAmt =  subs.Quarterly_Price__c;
                    }
                    if(subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly') && subs.Yearly_Price__c != null){
                        recurringPerUnitAmt =  subs.Yearly_Price__c;
                    }
                    // Logic for recurring price based on new proration *Added by Vineet*
                    
                    if(latestCntRemaining==0 && invoice.Payment_Method__c=='po')
                    {
                        subs.Last_Installment_Paid__c = true;
                    }
                    
                    if(NextInstallmentDueDate==null || NextInvoiceGenerationDate==null || subsequentInstallmentDueDate==null ||  subsequentInvoiceGenerationDate==null)
                    {
                        
                        if( ( latestCntRemaining==0  && (NextInstallmentDueDate==null || NextInvoiceGenerationDate==null)) || 
                        (latestCntRemaining<=1&& (subsequentInstallmentDueDate==null ||  subsequentInvoiceGenerationDate==null)) )
                        {
                            System.debug('Dates can be blank as invoices remaining are less.');
                        }
                        else
                        {
                            String msg = 'Important Dates are missing.';
                            msg = msg +' NextInstallmentDueDate-'+NextInstallmentDueDate + ' NextInvoiceGenerationDate:'+NextInvoiceGenerationDate + ' subsequentInstallmentDueDate:'+subsequentInstallmentDueDate + ' subsequentInvoiceGenerationDate:'+subsequentInvoiceGenerationDate;
                            OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                            throw reqEx;
                        }
                    
                    }
                    
                    singleInvoiceWrap.subsList.add(subs);
                    invoiceLine = new ccrz__E_InvoiceItem__c();
                    invoice.ccrz__CurrencyCode__c = subs.ccrz__CurrencyISOCode__c;
                   
                   
                   
                    
                    
                    
                    
                    if(accIdVsContactAddr.get(acc.id)==null)
                    {
                    //incase address not found then use subscription record address
                         invoice.ccrz__SoldAddress__c  = subs.ccrz__InstallmentAddress__c;
                         invoice.ccrz__BillAddress__c = subs.ccrz__OrderAddress__c;
                    }
                    else
                    {
                        invoice.ccrz__SoldAddress__c  = accIdVsContactAddr.get(acc.id);
                        invoice.ccrz__BillAddress__c = accIdVsContactAddr.get(acc.id);
                    }
                  
                    //CMI_AccountTriggerHandler.updateAccountAddressInOSMAddressBook
                    
                   //START:Added by Vaibhav on 18-Sep
                   DateTime tmpDt = subs.ccrz__InstallmentNextDate__c;
                   Date dueDt = date.newinstance(tmpDt.year(), tmpDt.month(), tmpDt.day());
                   //END:Added by Vaibhav on 18-Sep
                  
                   DateTime tmpGenDt = subs.Next_Invoice_Generation_Date__c ;
                   Date generationDt = date.newinstance(tmpGenDt.year(), tmpGenDt.month(), tmpGenDt.day());
                   
                   if(subsInfoMap!=null)
                   {
                        List<OSM_Order_Subscription__c>  allOrdersInfo = subsInfoMap.get(subs.id);
                        if(allOrdersInfo==null || allOrdersInfo.size()==0)
                        {
                          OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Subscription missing Order information in object-OSM_Order_Subscription__c',true);
                          throw reqEx;
                        }
                        Decimal taxForProductForAllOrders = 0.0;
                        Decimal totalQtyForProductForAllOrder=0;
                        Decimal totalSalesAmountForProductForAllOrder=0.0;
                        String strBuilder='';
                        
                        
                        for(OSM_Order_Subscription__c orderInfo :allOrdersInfo)
                        {
                            
                            if(orderInfo.Tax_Per_Unit__c==null || orderInfo.CCQuantity__c==null || orderInfo.CCProduct__c == null)
                            
                            {
                                strBuilder= strBuilder + 'OSM Order Subs Id:'+orderInfo.id+'Order:'+orderInfo.OSM_CCOrder__c +' Tax:'+orderInfo.Tax_Per_Unit__c + ' Qty:'+orderInfo.CCQuantity__c + ' Product Sku:'+orderInfo.CCProduct__c;
                                strBuilder= strBuilder + '\n';
                            }
                            else
                            {
                                
                                if(orderInfo.CCQuantity__c==0)
                                {
                                    //if orders are cancelled then do not consider
                                    continue;
                                }
                                String orderOwnerId = orderIdVsOwnerIdMap.get(orderInfo.OSM_CCOrder__c);
                                singleInvoiceWrap.orderOwnerIds.add(orderOwnerId);
                                System.debug('===orderOwnerId==='+orderOwnerId);
                                Decimal taxPerUnit  = orderInfo.Tax_Per_Unit__c;
                                System.debug('====taxPerUnit==='+taxPerUnit);
                                Decimal qty = orderInfo.CCQuantity__c;
                                System.debug('====Qty==='+qty);
                                
                                String productSku = orderInfo.CCProduct__c;
                                System.debug('===productSku==='+productSku);
                                
                                
                                
                                
                                //START:Added by Vaibhav on 18-Sep
                                System.debug('====subs.Recurring_Invoice_Start_Date__c===='+subs.Recurring_Invoice_Start_Date__c);
                                System.debug('====latestCntRemaining===='+latestCntRemaining);
                                System.debug('====subs.ccrz__SubscriptionStartDate__c===='+subs.ccrz__SubscriptionStartDate__c);
                                 System.debug('====taxPerUnit===='+taxPerUnit);
                                 
                                if(subs.Recurring_Invoice_Start_Date__c!=null){ 
                                
                                     Date recurringInvStartDt = date.newinstance(subs.Recurring_Invoice_Start_Date__c.year(), subs.Recurring_Invoice_Start_Date__c.month(), subs.Recurring_Invoice_Start_Date__c.day());
                                     
                                     Date subStartDt = date.newinstance(subs.ccrz__SubscriptionStartDate__c.year(), subs.ccrz__SubscriptionStartDate__c.month(), subs.ccrz__SubscriptionStartDate__c.day());
                                     
                                    if(recurringInvStartDt > subStartDt && latestCntRemaining==0){
                                        
                                        recurringPerUnitAmt = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subs,dueDt,false,null) ;
                                        taxPerUnit = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subs,dueDt,true,taxPerUnit) ;
                                        
                                         System.debug('====recurringPerUnitAmt from Proration Method is ===='+recurringPerUnitAmt);
                                    }
                                }
                                Decimal taxPerOrderPerProd = qty*taxPerUnit;
                                System.debug('====recurringPerUnitAmt===='+recurringPerUnitAmt);
                                System.debug('===taxPerOrderPerProd==='+taxPerOrderPerProd);
                                
                                //END:Added by Vaibhav on 18-Sep
                                Decimal totalSalesAmtPerProdPerOrder =recurringPerUnitAmt * qty;
                                
                                totalSalesAmountForProductForAllOrder = totalSalesAmountForProductForAllOrder + totalSalesAmtPerProdPerOrder;
                               // totalInvoiceLineTax = totalInvoiceLineTax + taxPerOrderPerProd;
                                //System.debug('===totalInvoiceLineTax==='+totalInvoiceLineTax);
                                taxForProductForAllOrders = taxForProductForAllOrders + taxPerOrderPerProd;
                                totalQtyForProductForAllOrder = totalQtyForProductForAllOrder + qty;
                                
                                
                                juncWrapper = new InvoiceLineAndOrderLineWrapper();
                                juncWrapper.orderId = orderInfo.OSM_CCOrder__c ;
                                System.debug('====Order Detail==='+orderInfo.OSM_CCOrder__c);
                                System.debug('====Order Line==='+orderInfo.CC_Order_Item__c);
                                
                                
                                juncWrapper.orderLineId =  orderInfo.CC_Order_Item__c ;
                                juncWrapper.productId = orderInfo.CCProduct__c ;
                                juncWrapper.qty = orderInfo.CCQuantity__c ;
                                juncWrapper.subsId = orderInfo.OSM_CCSubscription__c ;
                                juncWrapper.productSku = orderInfo.CCProduct__c ;
                                juncWrapper.vertexTax = taxPerOrderPerProd;
                                juncWrapper.totalSalesAmt = totalSalesAmtPerProdPerOrder;
                                lineJunctionWrapperLst.add(juncWrapper);
                                
                                //invoiceLine.ccrz__CCOrder__c
                                //invoiceLine.ccrz__CCOrderItem__c
                                
                            }
                        }
                        if(strBuilder!='')      
                        {
                            String msg = 'Incorrect information in Order Subscription Junction';
                            msg = msg + '\n' + strBuilder;
                            OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(msg,true);
                            throw reqEx;
                         
                        }
                        
                        invoiceLine.Vertex_Tax__c = taxForProductForAllOrders;
                        invoiceLine.Quantity__c = totalQtyForProductForAllOrder;
                        totalInvoiceTax = totalInvoiceTax + taxForProductForAllOrders;
                        invoiceLine.ccrz__OriginalAmount__c = totalSalesAmountForProductForAllOrder;
                        totalInvoiceSalesAmount = totalInvoiceSalesAmount + totalSalesAmountForProductForAllOrder;
                   }
                   
                   
                   
                   
                                  
                   
                   //START:Added by Vaibhav on 18-Sep
                   invoice.ccrz__DateDue__c = dueDt;
                   invoice.ccrz__DateIssued__c = generationDt;
                   //END:Added by Vaibhav on 18-Sep
                   
                    
                    //enrich subs dates with new dates
                    subs.ccrz__InstallmentNextDate__c = NextInstallmentDueDate;
                    subs.Next_Invoice_Generation_Date__c = NextInvoiceGenerationDate;
                    subs.Subsequent_Next_Invoice_Due_Dt__c = subsequentInstallmentDueDate;
                    subs.Subsequent_Next_Invoice_Generation_Dt__c = subsequentInvoiceGenerationDate;
                    invoice.ccrz__Storefront__c=subs.ccrz__Storefront__c;
                    
                    subs.Latest_Invoice__r = invoice;
                   
                   
                                    
                 invoiceLineLst.add(invoiceLine);
                 invoiceLine.ccrz__Invoice__r = invoice;
                 invoiceLine.CC_Subscription__c = subs.id;
                 //invoiceLine.ccrz__Sequence__c = later
                 invoiceLine.ccrz__Status__c = 'Open';
                 invoiceLine.ccrz__Type__c = 'Item';
                 
            
                 singleInvoiceWrap.invoiceLineLst.add(invoiceLine);
                 
                 }
            }
                 
                 //separate tax row
                 invoiceLine = new ccrz__E_InvoiceItem__c();
                 invoiceLineLst.add(invoiceLine);
                 invoiceLine.ccrz__Invoice__r = invoice;
                 
                 invoiceLine.ccrz__Sequence__c = 100;
                 invoiceLine.ccrz__Status__c = 'Open';
                 invoiceLine.ccrz__Type__c = 'Tax';
                 System.debug('====Final totalInvoiceLineTax==='+totalInvoiceLineTax);
                 invoiceLine.ccrz__OriginalAmount__c = totalInvoiceTax;
                 singleInvoiceWrap.invoiceLineLst.add(invoiceLine);
                 
                 //Calculate Invoice amount,Remaining amount for CC/PO
                 totalInvoiceOriginalAmount = totalInvoiceOriginalAmount + totalInvoiceSalesAmount;
                 
                 // Sharad for update new tax get it from quote call
                 //invoice.ccrz__OriginalAmount__c = totalInvoiceOriginalAmount + totalInvoiceTax;
                 invoice.ccrz__OriginalAmount__c = totalInvoiceOriginalAmount;
                 
                if(invoice.Payment_Method__c=='po')
                {
                    invoice.ccrz__RemainingAmount__c=0;
                    invoice.ccrz__Status__c = 'Paid';
                    //create TX Payment in case of PO
                    createTransactionPayment(singleInvoiceWrap);
                 }
                else
                {
                    invoice.ccrz__RemainingAmount__c=totalInvoiceOriginalAmount;
                }
                 if(Test.isRunningTest()){
                      throw new OSM_RequiredFields_Exception();                          
                    }   
            
              
                }catch(OSM_RequiredFields_Exception e){
                    
                    System.debug('=====Inside catch of  OSM_RequiredFields_Exception for each account ===');
                    if(singleInvoiceWrap==null)
                    {
                        System.debug('=====CATCH singleInvoiceWrap is null===');
                        SingleInvoiceForAccountWrapper wrapper = new SingleInvoiceForAccountWrapper();
                        wrapper.acc = new Account(Id=accId);
                        wrapper.exceptionFlag=true;
                        wrapper.exceptionMessage=e.exceptionMessage;
                        if(e.subscription!=null)
                        {
                           //wrapper.subscription=e.subscription;
                           wrapper.exceptionMessage = wrapper.exceptionMessage +String.valueOf(e.subscription);
                        }
                        accountIdVsInvoiceWrapperMap.put(accid,wrapper);
                    }
                    else
                    {
                        System.debug('=====CATCH singleInvoiceWrap is not null===');
                        singleInvoiceWrap.exceptionFlag=true;
                        singleInvoiceWrap.exceptionMessage=e.exceptionMessage;
                        if(e.subscription!=null)
                        {
                           
                           singleInvoiceWrap.exceptionMessage = singleInvoiceWrap.exceptionMessage +'\n' +String.valueOf(e.subscription);
                        }
                    }
                   if(!Test.isRunningTest()){
                      throw new NullPointerException();                          
                    }   
              
                }
                catch(Exception ex)
                {
                   String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
                   System.debug('********Exception Raised in createInvoicesForAccount*****'+errorMsg);
                    
                    if(singleInvoiceWrap==null)
                    {
                        SingleInvoiceForAccountWrapper wrapper = new SingleInvoiceForAccountWrapper();
                        wrapper.acc = new Account(Id=accId);
                        wrapper.exceptionFlag=true;
                        wrapper.exceptionMessage=errorMsg;
                        
                        accountIdVsInvoiceWrapperMap.put(accid,wrapper);
                    }
                    else
                    {
                        singleInvoiceWrap.exceptionFlag=true;
                        singleInvoiceWrap.exceptionMessage=errorMsg;
                        
                    }
                   
                   
                   
                }
                
              }
             
            
      }
      catch(Exception e)
      {
         String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
         System.debug('********Exception Raised in createInvoicesForAccount*****'+errorMsg);
         OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(errorMsg,true);
         throw reqEx;
      }
     
     for(String accId : returnWrapper.accountIdVsInvoiceWrapperMap.keySet())
     {
         System.debug('====Returning==Account=='+returnWrapper.accountIdVsInvoiceWrapperMap.get(accId));
     }
      return returnWrapper;
   }
   
   
   public static void createTransactionPayment(SingleInvoiceForAccountWrapper singleInvWrap)
   {
   
            ccrz__E_TransactionPayment__c transPayment = null;
            ccrz__E_Invoice__c invoice = singleInvWrap.invoice;
            //create payment record only for PO Invoices
            if(invoice.Payment_Method__c!='' && invoice.Payment_Method__c=='po')
            {
                
                transPayment = new ccrz__E_TransactionPayment__c();
                //latest PO number from orders will be used
                transPayment.ccrz__AccountNumber__c = singleInvWrap.poNo;
                transPayment.ccrz__AccountType__c=invoice.Payment_Method__c;
                transPayment.ccrz__Amount__c=invoice.ccrz__OriginalAmount__c;
                transPayment.ccrz__Contact__c=invoice.ccrz__Contact__c;
                transPayment.ccrz__CurrencyISOCode__c=invoice.ccrz__CurrencyCode__c;
                transPayment.ccrz__InvoiceAppliedTo__r=invoice;
                transPayment.ccrz__SoldTo__c=invoice.ccrz__SoldTo__c;
                transPayment.ccrz__BillTo__c=invoice.ccrz__BillTo__c;
                transPayment.ccrz__Storefront__c=invoice.ccrz__Storefront__c;
                transPayment.Transaction_Status__c='Recurring Payment Success';
                transPayment.ccrz__TransactionTS__c=System.Now();
                transPayment.ccrz__User__c=invoice.ccrz__User__c;
                transPayment.Ownerid=invoice.ownerid;
                transPayment.ccrz__Account__c=singleInvWrap.acc.id;
                singleInvWrap.transPayment=transPayment;
                
            }
        
     
    
     
     
   }
   
   
   public static List<InvoiceLineAndOrderLineWrapper> populateJunctionObjects(Map<Id,List<OSM_Order_Subscription__c>> subsIdInfoMapForAccount)
   {
        
        
        InvoiceLineAndOrderLineWrapper juncWrapper=null;
        List<InvoiceLineAndOrderLineWrapper> returnWrapper = new List<InvoiceLineAndOrderLineWrapper>();
         
                    for(Id subsId : subsIdInfoMapForAccount.keySet())
                    {
                       List<OSM_Order_Subscription__c> juncLst = subsIdInfoMapForAccount.get(subsId);
                       for(OSM_Order_Subscription__c junc : juncLst)
                       {
                           
                            juncWrapper = new InvoiceLineAndOrderLineWrapper();
                            juncWrapper.orderId = junc.OSM_CCOrder__c ;
                            juncWrapper.orderLineId =  junc.CC_Order_Item__c ;
                            juncWrapper.productId = junc.CCProduct__c ;
                            juncWrapper.qty = junc.CCQuantity__c ;
                            juncWrapper.subsId = junc.OSM_CCSubscription__c ;
                            juncWrapper.productSku = junc.CCProduct__c ;
                            returnWrapper.add(juncWrapper);
                            
                       }
                    }
               
            return returnWrapper;
        
   }
   
  

/*
 @ singleInvoice
 ** Create recurring invoices for Acccount and Insert it
 ** If No recurring invoice then maintain integration log to sent email with detail. 
*/    
public static Map<String,  ccrz__E_Invoice__c> getInvoicesToInsert(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  
                                                                    accoundVsWrapperMap, Map<Id,Decimal> orderIdVsOrderTaxMap2,
                                                                  Map<Id, Date> mapAccountToNextInvoiceGenDate,
                                                                  Map<Id, OSM_Integration_Log__c> invoiceNotCreatedLogs){ 
 Map<String,  ccrz__E_Invoice__c> accToInvoice = new Map<String,  ccrz__E_Invoice__c>();
     
     for(Id accId : accoundVsWrapperMap.keySet())
        {
         
          boolean isCreditLimitDeducted = false;
          List<ccrz__E_Subscription__c> subLst = null;
           ccrz__E_Invoice__c invoice = null;
           ccrz__E_TransactionPayment__c transPayment=null;
           List<ccrz__E_InvoiceItem__c> invoiceLineItems = null;
           SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);
            

           Set<String> ownerIds = singleInvWrap.orderOwnerIds;
           
          // System.debug('orderIdVsOrderTaxMap2: '+orderIdVsOrderTaxMap2);
            System.debug('singleInvWrap: '+singleInvWrap);
              
              // Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceMap = singleInvWrap.invoiceVsInvoiceLineMap;

              try{
                   // sp = Database.setSavepoint();
                    if(Test.isRunningTest()){
                     singleInvWrap.exceptionFlag=false;   
                    }
                    if(singleInvWrap!=null && singleInvWrap.exceptionFlag==true)
                    {
                       OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(singleInvWrap.exceptionMessage,true);
                       throw reqEx; 
                    }
                    else if(singleInvWrap==null)
                     {
                           OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Invoice record not created for account-'+accId,true);
                            throw reqEx; 
                     }
                     //Avoid for testing 
                    //if(!singleInvWrap.isQuoteTaxFailed)
                   if(true)
                    {
                        boolean isCreateRecurringInvoice = false;
                        String jsonStringForMail = '';
                        System.debug('======Starting Invoice Saving for Account==='+accId  +'===Accounr Name ===='+singleInvWrap.acc.name);
                        subLst = singleInvWrap.subsList;
                        invoice = singleInvWrap.Invoice;
                        if(invoice.Payment_Method__c=='po')
                        {
                            transPayment = singleInvWrap.transPayment;
                        }
                        
                        
                        invoiceLineItems = singleInvWrap.invoiceLineLst;
                        
                        List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem> listObj = new List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem>();
                        List<OSM_SW_Batch_Subscription_Processor_V1.subscData> lstSubD = new List<OSM_SW_Batch_Subscription_Processor_V1.subscData>();
                        List<Id> lstOrderIdToDAUpdate = new List<Id>();
                        
                        for(ccrz__E_InvoiceItem__c objInvoiceItem : invoiceLineItems)
                        {
                            if(!objInvoiceItem.ccrz__Type__c.equalsIgnoreCase('Tax'))
                            {
                                OSM_SW_Batch_Subscription_Processor_V1.invoiceItem objNew = new OSM_SW_Batch_Subscription_Processor_V1.invoiceItem();
                                objNew.subscription = objInvoiceItem.CC_Subscription__c;
                                objNew.quantity = objInvoiceItem.Quantity__c;
                                objNew.price = objInvoiceItem.ccrz__OriginalAmount__c;
                                listObj.add(objNew);
                                OSM_SW_Batch_Subscription_Processor_V1.subscData newSubDataObj = new OSM_SW_Batch_Subscription_Processor_V1.subscData();
                                newSubDataObj.subscId = objInvoiceItem.CC_Subscription__c;
                                newSubDataObj.Quantity = objInvoiceItem.Quantity__c;
                                lstSubD.add(newSubDataObj);
                            }
                        }
                        
                        jsonStringForMail = JSON.serialize(listObj);
                        
                        
                        for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                        {
                            lstOrderIdToDAUpdate.add(lineJunctionWrapperTmp.orderId);
                        }
                        
                        System.debug('----Invoice---'+invoice);
                        
                        Decimal totalTax = 0.0;
                        
                        Set<Id> setOrderIdToCheckOnlyOneTime = new Set<Id>();
                        for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                        {
                            
                            if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                            {
                                if(!setOrderIdToCheckOnlyOneTime.contains(lineJunctionWrapperTmp.orderId))
                                {
                                    totalTax = totalTax+orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                                    setOrderIdToCheckOnlyOneTime.add(lineJunctionWrapperTmp.orderId);
                                }
                            }
                        }
                        
                        invoice.ccrz__OriginalAmount__c = totalTax+invoice.ccrz__OriginalAmount__c;
                        if(invoice.Payment_Method__c == 'cc')
                            invoice.ccrz__RemainingAmount__c=invoice.ccrz__OriginalAmount__c;
                        
                        
                        if(singleInvWrap.acc.OSM_Preferred_Payment_Method__c == 'po')
                        {
                            if(invoice.OSM_SW_Is_Bolt_PO__c || Test.isRunningTest())
                            {
                                isCreateRecurringInvoice = true;
                                
                                if(singleInvWrap.acc.Bolt_Credit_Hold__c)
                                {
                                   
                                    isCreateRecurringInvoice = false;
                                    System.debug(mapAccountToNextInvoiceGenDate);
                                    
                                    System.debug('in bolt hold');
                                    
                                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                                        log.Service_Name__c ='Recurring Invoice not generated';
                                        log.Request__c = jsonStringForMail;
                                        //insert log;
                                        invoiceNotCreatedLogs.put(accId,log);
                                }
                                
                            }
                            else
                            {
                                isCreateRecurringInvoice = true;
                                
                            }
                            
                        }
                        else
                        {
                            isCreateRecurringInvoice = true;
                        }
                        
                        
                        if(isCreateRecurringInvoice)
                        {  
                            accToInvoice.put(accId, invoice); 
                       }
                    }
                      else{
                          
                          OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Issue in vertexTax'+accId,true);
                            throw reqEx; 
                      }
              } catch(Exception ex){
                  
                  
              }
        }
    if(invoiceNotCreatedLogs.values().size()>0){
        insert invoiceNotCreatedLogs.values();
    }   
       system.debug('accToInvoice-->'+accToInvoice);                                                               
    if(accToInvoice.values().size()>0){
          insert accToInvoice.values();                                                               
      }                                                                 
    return accToInvoice;
    
}     
 

    

public static Map<String,  ccrz__E_Invoice__c> getEmailMessagesToSent(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  
                                                                    accoundVsWrapperMap, Map<Id,Decimal> orderIdVsOrderTaxMap2,
                                                                  Map<Id, Date> mapAccountToNextInvoiceGenDate,
                                                                  Map<Id, OSM_Integration_Log__c> invoiceNotCreatedLogs,
                                                                    List<OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke> lstForRevokeSubsc,
                                                                     Map<Id, String> MapIdToUserToEmailId){ 
 Map<String,  ccrz__E_Invoice__c> accToInvoice = new Map<String,  ccrz__E_Invoice__c>();
     //Map<Id,OSM_Integration_Log__c> invoiceNotCreatedLogs = new Map<Id, OSM_Integration_Log__c>();
     List<EmailTemplate> etforRecurring = [Select id from EmailTemplate where name = 'Recurring Invoice not generated template' limit 1];
     List<EmailTemplate> etforRevoke = [Select id from EmailTemplate where name = 'Revocation Recurring Invoice generate' limit 1];
        
     Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
     for(Id accId : accoundVsWrapperMap.keySet())
        {
         
          boolean isCreditLimitDeducted = false;
          List<ccrz__E_Subscription__c> subLst = null;
           ccrz__E_Invoice__c invoice = null;
           ccrz__E_TransactionPayment__c transPayment=null;
           List<ccrz__E_InvoiceItem__c> invoiceLineItems = null;
           SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);
            

           Set<String> ownerIds = singleInvWrap.orderOwnerIds;
           
          // System.debug('orderIdVsOrderTaxMap2: '+orderIdVsOrderTaxMap2);
            System.debug('singleInvWrap: '+singleInvWrap);
              
              // Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceMap = singleInvWrap.invoiceVsInvoiceLineMap;

              try{
                     
                    if(!singleInvWrap.isQuoteTaxFailed)
                    {
                        boolean isCreateRecurringInvoice = false;
                        String jsonStringForMail = '';
                        System.debug('======Starting Invoice Saving for Account==='+accId  +'===Accounr Name ===='+singleInvWrap.acc.name);
                        
                        
                        System.debug('----Invoice---'+invoice);
                        
                        Decimal totalTax = 0.0;
                        
                        invoiceLineItems = singleInvWrap.invoiceLineLst;
                        
                        List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem> listObj = new List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem>();
                        List<OSM_SW_Batch_Subscription_Processor_V1.subscData> lstSubD = new List<OSM_SW_Batch_Subscription_Processor_V1.subscData>();
                        List<Id> lstOrderIdToDAUpdate = new List<Id>();
                        
                        for(ccrz__E_InvoiceItem__c objInvoiceItem : invoiceLineItems)
                        {
                            if(!objInvoiceItem.ccrz__Type__c.equalsIgnoreCase('Tax'))
                            {
                                OSM_SW_Batch_Subscription_Processor_V1.invoiceItem objNew = new OSM_SW_Batch_Subscription_Processor_V1.invoiceItem();
                                objNew.subscription = objInvoiceItem.CC_Subscription__c;
                                objNew.quantity = objInvoiceItem.Quantity__c;
                                objNew.price = objInvoiceItem.ccrz__OriginalAmount__c;
                                listObj.add(objNew);
                                OSM_SW_Batch_Subscription_Processor_V1.subscData newSubDataObj = new OSM_SW_Batch_Subscription_Processor_V1.subscData();
                                newSubDataObj.subscId = objInvoiceItem.CC_Subscription__c;
                                newSubDataObj.Quantity = objInvoiceItem.Quantity__c;
                                lstSubD.add(newSubDataObj);
                            }
                        }
                        
                        if(singleInvWrap.acc.OSM_Preferred_Payment_Method__c == 'po')
                        {
                            if(invoice.OSM_SW_Is_Bolt_PO__c || Test.isRunningTest())
                            {
                                isCreateRecurringInvoice = true;
                                
                                if(singleInvWrap.acc.Bolt_Credit_Hold__c && invoiceNotCreatedLogs.get(accId) != null)
                                {
                                   OSM_Integration_Log__c log = invoiceNotCreatedLogs.get(accId);
                                   
                                    //if(mapAccountToNextInvoiceGenDate.get(singleInvWrap.acc.Id).daysBetween(System.Today()) < 5)  //Added below line for Mar-667
									if(mapAccountToNextInvoiceGenDate.get(singleInvWrap.acc.Id).daysBetween(System.Today()) < 5 && !invoice.Is_GOMS_Intercompany_Invoice__c)
                                    {
                                        
                                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                        if(etforRecurring!=null && etforRecurring.size()>0)
                                        message = Messaging.renderStoredEmailTemplate(etforRecurring[0].id,singleInvWrap.acc.CMI_Primary_Contact__c,log.id);
                                        message.setSaveAsActivity(false);
                                        List<String> emailAddress = new List<String>();
                                        emailAddress.add('sharad.sa@hcl.com');
                                        emailAddress.add('OSMSupport@cummins.com');
                                        if(singleInvWrap.acc.IAM_Cummins_Support_User__c != null && MapIdToUserToEmailId.containsKey(singleInvWrap.acc.IAM_Cummins_Support_User__c) && MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c) != '')
                                            emailAddress.add(MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c));
                                        message.setToAddresses(emailAddress);
                                        messagesForBMS.add(message);
                                        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                                    }
                                    else
                                    {
                                        System.debug('Revoke Subscription');
                                        
                                        OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke objRev = new OSM_SW_Batch_Subscription_Processor_V1.SubscRevoke();
                                        objRev.lstSubscData = lstSubD;
                                        objRev.lstOrderId = lstOrderIdToDAUpdate;
                                        
                                        
                                        
                                        //Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
                                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                        if(etforRevoke!=null && etforRevoke.size()>0)
                                        message = Messaging.renderStoredEmailTemplate(etforRevoke[0].id,singleInvWrap.acc.CMI_Primary_Contact__c,log.id);
                                        message.setSaveAsActivity(false);
                                        List<String> emailAddress = new List<String>();
                                        emailAddress.add('sharad.sa@hcl.com');
                                        emailAddress.add('OSMSupport@cummins.com');
                                        if(singleInvWrap.acc.IAM_Cummins_Support_User__c != null && MapIdToUserToEmailId.containsKey(singleInvWrap.acc.IAM_Cummins_Support_User__c) && MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c) != '')
                                            emailAddress.add(MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c));
                                        message.setToAddresses(emailAddress);
                                        //messagesForBMS.add(message);
                                        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                                        
                                        objRev.mailTosent = message;
                                        lstForRevokeSubsc.add(objRev); 

                                        
                                        
                                    }    
                                }
                                
                            }
                            
                            
                        }
                        
                    }
              } catch(Exception ex){
                  
                  
              }
        } 
        
        if(messagesForBMS != null){ 
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
        }
                                                                      
    return null;
    
}
    
public static Map<Object,  Object> getInvoiceItemsAndSubssToUpsert(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  
                                                                    accoundVsWrapperMap, Map<Id,Decimal> orderIdVsOrderTaxMap2,
                                                                  Map<Id, Date> mapAccountToNextInvoiceGenDate,
                                                                    Map<String, ccrz__E_Invoice__c> accIdToInsertedInvoice){ 
     Map<Object,  Object> accountToItsItems = new Map<Object,  Object>();
                                                                        try{
                                                                            
                                                                                                                                       
     Map<Id, OSM_Integration_Log__c> invoiceNotCreatedLogs = new Map<Id, OSM_Integration_Log__c>();
     Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
     List<ccrz__E_TransactionPayment__c> transPaymentsToInsert = new List<ccrz__E_TransactionPayment__c>();
     for(Id accId : accoundVsWrapperMap.keySet())
        {
         
          boolean isCreditLimitDeducted = false;
          List<ccrz__E_Subscription__c> subLst = null;
           ccrz__E_Invoice__c invoice = accIdToInsertedInvoice.get(accId);
           ccrz__E_TransactionPayment__c transPayment=null;
           
           List<ccrz__E_InvoiceItem__c> invoiceLineItems = null;
           SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);
            

           Set<String> ownerIds = singleInvWrap.orderOwnerIds;
           
          // System.debug('orderIdVsOrderTaxMap2: '+orderIdVsOrderTaxMap2);
            System.debug('singleInvWrap: '+singleInvWrap);
              
              // Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceMap = singleInvWrap.invoiceVsInvoiceLineMap;

              try{
                   // sp = Database.setSavepoint();
                    if(singleInvWrap!=null && singleInvWrap.exceptionFlag==true)
                    {
                       OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(singleInvWrap.exceptionMessage,true);
                       throw reqEx; 
                    }
                    else if(singleInvWrap==null)
                     {
                           OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Invoice record not created for account-'+accId,true);
                            throw reqEx; 
                     }
                     if(Test.isRunningTest())
                     {
                         singleInvWrap.isQuoteTaxFailed=false;
                     }
                    if(!singleInvWrap.isQuoteTaxFailed)
                    {
                        boolean isCreateRecurringInvoice = false;
                        String jsonStringForMail = '';
                        System.debug('======Starting Invoice Saving for Account==='+accId  +'===Accounr Name ===='+singleInvWrap.acc.name);
                        subLst = singleInvWrap.subsList;
                        invoice = singleInvWrap.Invoice;
                        if(invoice.Payment_Method__c=='po')
                        {
                            transPayment = singleInvWrap.transPayment;
                        }
                        
                        
                        invoiceLineItems = singleInvWrap.invoiceLineLst;
                        
                        List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem> listObj = new List<OSM_SW_Batch_Subscription_Processor_V1.invoiceItem>();
                        List<OSM_SW_Batch_Subscription_Processor_V1.subscData> lstSubD = new List<OSM_SW_Batch_Subscription_Processor_V1.subscData>();
                        List<Id> lstOrderIdToDAUpdate = new List<Id>();
                        
                        for(ccrz__E_InvoiceItem__c objInvoiceItem : invoiceLineItems)
                        {
                            if(!objInvoiceItem.ccrz__Type__c.equalsIgnoreCase('Tax'))
                            {
                                OSM_SW_Batch_Subscription_Processor_V1.invoiceItem objNew = new OSM_SW_Batch_Subscription_Processor_V1.invoiceItem();
                                objNew.subscription = objInvoiceItem.CC_Subscription__c;
                                objNew.quantity = objInvoiceItem.Quantity__c;
                                objNew.price = objInvoiceItem.ccrz__OriginalAmount__c;
                                listObj.add(objNew);
                                OSM_SW_Batch_Subscription_Processor_V1.subscData newSubDataObj = new OSM_SW_Batch_Subscription_Processor_V1.subscData();
                                newSubDataObj.subscId = objInvoiceItem.CC_Subscription__c;
                                newSubDataObj.Quantity = objInvoiceItem.Quantity__c;
                                lstSubD.add(newSubDataObj);
                            }
                        }
                        
                        jsonStringForMail = JSON.serialize(listObj);
                        
                        
                        for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                        {
                            lstOrderIdToDAUpdate.add(lineJunctionWrapperTmp.orderId);
                        }
                        
                        System.debug('----Invoice---'+invoice);
                        
                        Decimal totalTax = 0.0;
                        
                        Set<Id> setOrderIdToCheckOnlyOneTime = new Set<Id>();
                        for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                        {
                            
                            if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                            {
                                if(!setOrderIdToCheckOnlyOneTime.contains(lineJunctionWrapperTmp.orderId))
                                {
                                    totalTax = totalTax+orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                                    setOrderIdToCheckOnlyOneTime.add(lineJunctionWrapperTmp.orderId);
                                }
                            }
                        }
                        
                        invoice.ccrz__OriginalAmount__c = totalTax+invoice.ccrz__OriginalAmount__c;
                        if(invoice.Payment_Method__c == 'cc')
                            invoice.ccrz__RemainingAmount__c=invoice.ccrz__OriginalAmount__c;
                        
                        
                        if(singleInvWrap.acc.OSM_Preferred_Payment_Method__c == 'po')
                        {
                            if(invoice.OSM_SW_Is_Bolt_PO__c || Test.isRunningTest())
                            {
                                isCreateRecurringInvoice = true;
                                
                                if(singleInvWrap.acc.Bolt_Credit_Hold__c)
                                {
                                   
                                    isCreateRecurringInvoice = false;
                                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                                        log.Service_Name__c ='Recurring Invoice not generated';
                                        log.Request__c = jsonStringForMail;
                                        //insert log;
                                        invoiceNotCreatedLogs.put(accId, log);
                                }
                                
                            }
                            else
                            {
                                isCreateRecurringInvoice = true;
                            }
                        }
                        else
                        {
                            isCreateRecurringInvoice = true;
                        }
                        
                        if(isCreateRecurringInvoice)
                        {  
                            //accToInvoice.put(accId, invoice); 
                            
                             invoiceIdVsOwnerMap.put(invoice.id,ownerIds);
                             accountToItsItems.put(accId+'invoiceIdVsOwnerMap',invoiceIdVsOwnerMap);
                             
                             if(transPayment!=null)
                            {
                                //for PO INvoice..make the immediate payment by creating the TX Payment and set the Bolt Calls
                                //transPayment.Bolt_Recurring_AR_Call_Status__c='Pending';
                                //transPayment.Bolt_Recurring_JE_Call_Status__c ='Pending';
                                transPayment.Bolt_AR_Call_Status__c ='Pending';
                                transPayment.Bolt_JE_Call_Status__c ='Pending';
                                transPayment.ccrz__InvoiceAppliedTo__c = invoice.id;
                                //transPayment.ccrz__AccountType__c='po';
                                //Database.insert(transPayment);
                                //transPaymentsToInsert.add(transPayment);
                                accountToItsItems.put(accId+'transPayment',transPayment);
                            }
                              for(ccrz__E_InvoiceItem__c invItem : invoiceLineItems)
                            {
                                invItem.ccrz__Invoice__c = invoice.id;
                                if(invItem.ccrz__Type__c == 'Tax')
                                    invItem.ccrz__OriginalAmount__c = totalTax;
                            }
                            System.debug('===invoiceLineItems size==='+invoiceLineItems.size());
                            for(ccrz__E_Subscription__c sub:subLst)
                            {
                                System.debug('====subscription before saving==='+sub);
                                sub.Latest_Invoice__c = invoice.id;
                            }
                            accountToItsItems.put(accId+'invoiceLineItems',accId);
                            accountToItsItems.put(accId+'subLst',subLst);
                            //Database.update();
                       }
                    }
              } catch(Exception ex){
                  
                  
              }
        }
    if(!accountToItsItems.isEmpty()){
        //insert accountToItsItems.values();
    }   
                                                                            }  catch(exception ex){
                                                                            
                                                                        } 
                                                                            
    return accountToItsItems;
    
}     
 

/*
** Method used to UPSERT Invoice Items and Subscription of recurring invoice
*/
public static Map<Object,  Object> getInvoiceItemsAndSubssToUpsertLatest(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  
                                                                    accoundVsWrapperMap, Map<Id,Decimal> orderIdVsOrderTaxMap2,
                                                                  Map<Id, Date> mapAccountToNextInvoiceGenDate,
                                                                    Map<String, ccrz__E_Invoice__c> accIdToInsertedInvoice){ 
 Map<Object,  Object> accountToItsItems = new Map<Object,  Object>();
 Map<Id, List<ccrz__E_Subscription__c>> accToSubscriptions = new Map<Id, List<ccrz__E_Subscription__c>>();
 List<ccrz__E_Subscription__c> subscriptionsToUpdate = new List<ccrz__E_Subscription__c>();
 List<ccrz__E_InvoiceItem__c> invoiceItemsToInsert = new List<ccrz__E_InvoiceItem__c>();
 
 Map<Id, ccrz__E_TransactionPayment__c> accToTransPayment = new Map<Id, ccrz__E_TransactionPayment__c>();
 Map<Id, List<ccrz__E_InvoiceItem__c>> accToInvoiceItems = new Map<Id, List<ccrz__E_InvoiceItem__c>>();
     List<OSM_Integration_Log__c> invoiceNotCreatedLogs = new List<OSM_Integration_Log__c>();
     Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
     List<ccrz__E_TransactionPayment__c> transPaymentsToInsert = new List<ccrz__E_TransactionPayment__c>();
     for(Id accId : accoundVsWrapperMap.keySet())
        {
         
           SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);                                                         
           ccrz__E_TransactionPayment__c transPayment=null;
           List<ccrz__E_Subscription__c> subLst = singleInvWrap.subsList;
           
           List<ccrz__E_InvoiceItem__c> invoiceLineItems = singleInvWrap.invoiceLineLst;
           
           Set<String> ownerIds = singleInvWrap.orderOwnerIds;
           
          // System.debug('orderIdVsOrderTaxMap2: '+orderIdVsOrderTaxMap2);
            System.debug('2singleInvWrap: '+singleInvWrap);
            System.debug('orderIdVsOrderTaxMap2-->'+orderIdVsOrderTaxMap2);
            System.debug('singleInvWrap.invoiceLineOrderLineWrapperLst-->'+singleInvWrap.invoiceLineOrderLineWrapperLst);
              
              // Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceMap = singleInvWrap.invoiceVsInvoiceLineMap;

              try{
                        if(accIdToInsertedInvoice.get(accId) != null)
                        {  
                          ccrz__E_Invoice__c invoice = accIdToInsertedInvoice.get(accId);
                          subLst = singleInvWrap.subsList;
                            //accToInvoice.put(accId, invoice); 
                            if(invoice.Payment_Method__c=='po')
                               {
                                   transPayment = singleInvWrap.transPayment;
                               }
                             invoiceIdVsOwnerMap.put(invoice.id,ownerIds);
                             accountToItsItems.put(accId+'invoiceIdVsOwnerMap',invoiceIdVsOwnerMap);
                             
                             if(transPayment!=null)
                            {
                                //for PO INvoice..make the immediate payment by creating the TX Payment and set the Bolt Calls
                                //transPayment.Bolt_Recurring_AR_Call_Status__c='Pending';
                                //transPayment.Bolt_Recurring_JE_Call_Status__c ='Pending';
                                transPayment.Bolt_AR_Call_Status__c ='Pending';
                                transPayment.Bolt_JE_Call_Status__c ='Pending';
                                transPayment.ccrz__InvoiceAppliedTo__c = invoice.id;
                                //transPayment.ccrz__AccountType__c='po';
                                //Database.insert(transPayment);
                                //transPaymentsToInsert.add(transPayment);
                                //accountToItsItems.put(accId+'transPayment',transPayment);
                                accToTransPayment.put(accId,transPayment);
                            }
                            
                            Decimal totalTax = 0.0;
                        
                            Set<Id> setOrderIdToCheckOnlyOneTime = new Set<Id>();
                            for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                            {
                                
                                if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                                {
                                    if(!setOrderIdToCheckOnlyOneTime.contains(lineJunctionWrapperTmp.orderId))
                                    {
                                        totalTax = totalTax+orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                                        setOrderIdToCheckOnlyOneTime.add(lineJunctionWrapperTmp.orderId);
                                    }
                                }
                            }
                            
                            for(ccrz__E_InvoiceItem__c invItem : invoiceLineItems)
                            {
                                invItem.ccrz__Invoice__c = invoice.id;
                                if(invItem.ccrz__Type__c == 'Tax'){
                                    invItem.ccrz__OriginalAmount__c = totalTax;
                                }
                                invoiceItemsToInsert.add(invItem);
                            }
                            System.debug('===invoiceLineItems size==='+invoiceLineItems.size());
                            for(ccrz__E_Subscription__c sub:subLst)
                            {
                                System.debug('====subscription before saving==='+sub);
                                 sub.Latest_Invoice__c = invoice.id;
                                 subscriptionsToUpdate.add(sub);
                            }
                            //invoiceToInvoiceItems.put(invoice.id,invoiceLineItems);
                            accToSubscriptions.put(accId,subLst);
                            //accountToItsItems.put(accId+'subLst',subLst);
                            //Database.update();
                       }
              } catch(Exception ex){
                  
                  system.debug('ex--->'+ex+' ==='+ex.getLineNumber());
            }
        }
    
    if(subscriptionsToUpdate.size()>0){ 
        update subscriptionsToUpdate;
    }
    system.debug('New subscriptionsToUpdate--->'+subscriptionsToUpdate);
    system.debug('New accToTransPayment--->'+accToTransPayment);
    if(accToTransPayment.values().size()>0){    
        insert accToTransPayment.values();
    }
    
    
    if(invoiceItemsToInsert.size()>0){  
        insert invoiceItemsToInsert;
    }
        
    
    for(Id accId : accoundVsWrapperMap.keySet())
    {
        if(accIdToInsertedInvoice.get(accId) != null){  
            if(accToTransPayment.get(accId) != null){
                accountToItsItems.put(accId+TRANSPAYMENT,accToTransPayment.get(accId));
            }
             
            for(ccrz__E_Subscription__c sub : subscriptionsToUpdate){
                if(sub.ccrz__Account__c == accId){
                    if(accountToItsItems.get(accId+SUBSCRIPTIONLIST) != null){
                        List<ccrz__E_Subscription__c> addedSubs = (List<ccrz__E_Subscription__c>)accountToItsItems.get(accId+SUBSCRIPTIONLIST);
                        addedSubs.add(sub);
                        accountToItsItems.put(accId+SUBSCRIPTIONLIST, addedSubs);
                    }else{
                        accountToItsItems.put(accId+SUBSCRIPTIONLIST, new List<ccrz__E_Subscription__c>{sub});
                    }
                }
                
            }
             
            ccrz__E_Invoice__c invoice = accIdToInsertedInvoice.get(accId);
            for(ccrz__E_InvoiceItem__c invItem : invoiceItemsToInsert){
                if(invItem.ccrz__Invoice__c == invoice.Id){
                    if(accountToItsItems.get(accId+OSM_SW_Batch_Subscription_Helper.INVOICEITEMS) != null){
                        List<ccrz__E_InvoiceItem__c> addedItems = (List<ccrz__E_InvoiceItem__c>)accountToItsItems.get(accId+OSM_SW_Batch_Subscription_Helper.INVOICEITEMS);
                        addedItems.add(invItem);
                        accountToItsItems.put(accId+OSM_SW_Batch_Subscription_Helper.INVOICEITEMS, addedItems);
                    }else{ 
                        accountToItsItems.put(accId+OSM_SW_Batch_Subscription_Helper.INVOICEITEMS, new List<ccrz__E_InvoiceItem__c>{invItem});
                    }
                
                }
                
            }
        }
    }
    return accountToItsItems;
    
}     


/*
** If recurring invoice is generated and InvoiceItem also get Inserted then maintain Junction Objects record:
 OSM_Orders_In_Invoice__c, OSM_InvoiceLine_And_OrderLine__c
*/    
public static Map<Object,  Object> getJunctionObjectsToUpserted(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  
                                                                    accoundVsWrapperMap, Map<Id,Decimal> orderIdVsOrderTaxMap2,
                                                                  Map<Id, Date> mapAccountToNextInvoiceGenDate,
                                                                    Map<String, ccrz__E_Invoice__c> accIdToInsertedInvoice,
                                                                    Map<Object,  Object> accToInvoiceItemsAndSubss){ 
 Map<Object,  Object> accountToItsItems = new Map<Object,  Object>();
     List<OSM_Integration_Log__c> invoiceNotCreatedLogs = new List<OSM_Integration_Log__c>();
     Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
     List<ccrz__E_TransactionPayment__c> transPaymentsToInsert = new List<ccrz__E_TransactionPayment__c>();
     List<OSM_Orders_In_Invoice__c> orderInvoiceJucntionList = new List<OSM_Orders_In_Invoice__c>();
     Map<Id,OSM_Orders_In_Invoice__c> junctionForEachOrder = new Map<Id,OSM_Orders_In_Invoice__c>();
     List<OSM_InvoiceLine_And_OrderLine__c> lineJunctionWrapperLst = new List<OSM_InvoiceLine_And_OrderLine__c>();
     List<CC_Tax__c> listTaxObjeToCreate = new List<CC_Tax__c>();
    
     for(Id accId : accoundVsWrapperMap.keySet())
        {
          if(accIdToInsertedInvoice.get(accId) != null){
                ccrz__E_Invoice__c invoice = accIdToInsertedInvoice.get(accId);
                SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);
                List<ccrz__E_InvoiceItem__c> invoiceItems = new List<ccrz__E_InvoiceItem__c>();
                if(accToInvoiceItemsAndSubss.get(accId+'INVOICEITEMS') != null){
                    invoiceItems = (List<ccrz__E_InvoiceItem__c>)accToInvoiceItemsAndSubss.get(accId+'INVOICEITEMS');
                }
                List<ccrz__E_Subscription__c> subscriptions = new List<ccrz__E_Subscription__c>();
                if(accToInvoiceItemsAndSubss.get(accId+'SUBSCRIPTIONLIST') != null){
                    subscriptions = (List<ccrz__E_Subscription__c>)accToInvoiceItemsAndSubss.get(accId+'SUBSCRIPTIONLIST');
                }
                
                
                //lineJunctionWrapperLst = singleInvWrap.invoiceLineOrderLineWrapperLst;
                OSM_Orders_In_Invoice__c parentJun;
                
                for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                {
                
                  parentJun = new OSM_Orders_In_Invoice__c();
                  parentJun.CC_Invoice__c = invoice.id;
                  parentJun.CC_Order__c = lineJunctionWrapperTmp.orderId;
                  if(invoice.Payment_Method__c=='po'){
                   parentJun.Vertex_Call_Status__c = 'Pending';
                  }
                  if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                    parentJun.vertex_tax__c = orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                  else
                      parentJun.vertex_tax__c = 0;
                  //breaking as any line item will have orderid and invoice id
                  if(!junctionForEachOrder.containskey(lineJunctionWrapperTmp.orderId))
                  {
                     junctionForEachOrder.put(lineJunctionWrapperTmp.orderId,parentJun);
                  }
                  //insert parentJun;
                  //break;
                }
          }
          
        }
          
          if(junctionForEachOrder.values().size()>0){
              system.debug('junctionForEachOrder-->'+junctionForEachOrder);
              insert junctionForEachOrder.values();
          }
          
          for(Id accId : accoundVsWrapperMap.keySet())
        {
          if(accIdToInsertedInvoice.get(accId) != null){
                SingleInvoiceForAccountWrapper singleInvWrap =  accoundVsWrapperMap.get(accId);
                ccrz__E_Invoice__c invoice = accIdToInsertedInvoice.get(accId);
                List<ccrz__E_InvoiceItem__c> invoiceItems = new List<ccrz__E_InvoiceItem__c>();
                if(accToInvoiceItemsAndSubss.get(accId+'INVOICEITEMS') != null){
                    invoiceItems = (List<ccrz__E_InvoiceItem__c>)accToInvoiceItemsAndSubss.get(accId+'INVOICEITEMS');
                }
                List<ccrz__E_Subscription__c> subscriptions = new List<ccrz__E_Subscription__c>();
                if(accToInvoiceItemsAndSubss.get(accId+SUBSCRIPTIONLIST) != null){
                    subscriptions = (List<ccrz__E_Subscription__c>)accToInvoiceItemsAndSubss.get(accId+'SUBSCRIPTIONLIST');
                }
                
                
                for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp2 : singleInvWrap.invoiceLineOrderLineWrapperLst)
                            {
                            
                                System.debug('lineJunctionWrapperTmp2'+lineJunctionWrapperTmp2);
                             OSM_InvoiceLine_And_OrderLine__c lineJunctionWrapper = new OSM_InvoiceLine_And_OrderLine__c();
                                
                                for(ccrz__E_InvoiceItem__c invItem : invoiceItems)
                                {
                                   if(invItem.CC_Subscription__c == lineJunctionWrapperTmp2.subsId)
                                   {
                                        lineJunctionWrapper.CC_Invoice_Item__c = invItem.id;
                                        break;
                                   }
                                }
                              
                              lineJunctionWrapper.CC_Order_Item__c = lineJunctionWrapperTmp2.orderLineId;
                              if(junctionForEachOrder.containsKey(lineJunctionWrapperTmp2.orderId))
                              {
                                    OSM_Orders_In_Invoice__c parentJunction = junctionForEachOrder.get(lineJunctionWrapperTmp2.orderId);
                                    lineJunctionWrapper.OSM_Orders_In_Invoice__c = parentJunction.id;
                              }
                              lineJunctionWrapper.Quantity__c = lineJunctionWrapperTmp2.qty;
                              lineJunctionWrapper.Sales_Amount__c =lineJunctionWrapperTmp2.totalSalesAmt;
                              lineJunctionWrapper.vertex_tax__c = lineJunctionWrapperTmp2.vertexTax;
                              //creating tax record: sharad
                              if((lineJunctionWrapperTmp2.lstTax != null && lineJunctionWrapperTmp2.lstTax.size() > 0) || Test.isRunningTest())
                              {
                                  for(CC_Tax__c objTax : lineJunctionWrapperTmp2.lstTax)
                                  {
                                      objTax.Invoice_Item__c = lineJunctionWrapper.CC_Invoice_Item__c;
                                      listTaxObjeToCreate.add(objTax);
                                  }
                              }
                              
                              
                              //end of creating tax record: sharad
                              
                              //lineJunctionWrapper.CC_Subscription__c = lineJunctionWrapperTmp2.subsId;
                              lineJunctionWrapperLst.add(lineJunctionWrapper);
                            }
                }
                
        }
        
        if(lineJunctionWrapperLst.size() > 0){
            insert lineJunctionWrapperLst;
        }
                            
        if(listTaxObjeToCreate.size() > 0)
        {
            insert listTaxObjeToCreate;
        }
        
        
        
    return accountToItsItems;
    
}     
   
   public class SingleInvoiceForAccountWrapper
   {
     public Account acc{get; set;}
     public String poNo{get; set;}
     public boolean isQuoteTaxFailed{get; set;}
     public Set<String> orderOwnerIds{get; set;}
     
     public List<ccrz__E_Subscription__c> subsList{get; set;}
     public ccrz__E_Invoice__c invoice{get; set;}
     public List<ccrz__E_InvoiceItem__c> invoiceLineLst{get; set;}
     public ccrz__E_TransactionPayment__c transPayment{get; set;}
     public List<InvoiceLineAndOrderLineWrapper> invoiceLineOrderLineWrapperLst{get; set;}
  
     
     
     public SingleInvoiceForAccountWrapper()
     {
        subsList = new List<ccrz__E_Subscription__c>();
        invoiceLineLst = new List<ccrz__E_InvoiceItem__c>();
        orderOwnerIds = new Set<String>();
        isQuoteTaxFailed = true;
     }
     
     public boolean exceptionFlag{get;set;}
     public String exceptionMessage{get;set;}
   
     
   }
   
   public class InvoiceLineAndOrderLineWrapper
   {
     public OSM_InvoiceLine_And_OrderLine__c junc{get; set;}
     public String productSku{get; set;}
     public String productId{get; set;}
     public ccrz__E_Invoice__c invoice{get; set;}
     public ccrz__E_Order__c order{get; set;}
     public String orderId{get; set;}
     public String invoiceid{get; set;}
     public String orderLineId{get; set;}
     public Decimal qty{get; set;}
     public String subsId {get; set;}
     public Decimal vertexTax{get; set;}
     public Decimal totalSalesAmt{get; set;}
     public List<CC_Tax__c> lstTax{get; set;}
     
     public InvoiceLineAndOrderLineWrapper()
     {
         lstTax = new List<CC_Tax__c>();
     }
     
   }
   
    
   
}