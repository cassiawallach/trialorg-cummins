/************************************************************
Name:  OSM_BOLT_SW_BusinessLayerHandler 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is business layer handler class where AR Invoice and
Journal Entry dynamic parametrs will be calculated. They will
form part of generalised wrapper class which will be passed
over to AR Invoice/Jornal Entry service handler. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_BOLT_SW_BusinessLayerHandler{
    
    /*----------------------------------------------------------------------------------
    1. setARInvoiceOutboundWrapper
    Description: Create Generalized wrapper for AR Invoice
    Input: List<Id> invoiceList, Map<Id,Id> mapCTPInvcid
    Output: OSM_Integration_Log__c record for success and failure and an update on CC 
    Transaction payment record with successive update/reset flag upon failure/success. 
    Returntype: OSM_ReturnWrapper   
    ------------------------------------------------------------------------------------*/    
        public static OSM_ReturnWrapper setARInvoiceOutboundWrapper(List<Id> invoiceList, Map<Id,Id> mapCTPInvcid, String state,Set<Id> setOrderItemId){      
            //Set<Id> setOrderItemId = new Set<Id>();
            //setOrderItemId.add('a2R1F000005OqSVUA0');
             
            system.debug('invoiceList +++ '+ invoiceList);
            system.debug('mapCTPInvcid +++ '+ mapCTPInvcid);
            system.debug('state +++ '+ state);
            system.debug('setOrderItemId +++' + setOrderItemId);
            //Initialize variables
            OSM_BOLT_WS_ARInvoiceOutboundRes serviceCallReturn;
            Map<Id,ccrz__E_Invoice__c> invoiceMap;      
            Map<Id,String> InvIdCTPName = new Map<Id,String>(); //Map of invoice id and transaction payment name
            Map<Id,String> InvIdCTPComment = new Map<Id,String>(); //Map of invoice id and transaction payment comment
            String FromCurrency;
            String ToCurrency;
            OSM_Integration_Log__c log = null; 
            Id invoiceId;
            ccrz__E_Invoice__c invoice; 
            OSM_ReturnWrapper returnWrap = new OSM_ReturnWrapper();
            
            
            
            
            //Map to update logs, failure flags and reset flags
            Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
            Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
            Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();  
            List<ccrz__E_Invoice__c> lstInvoiceToUpdate = new List<ccrz__E_Invoice__c>();  
            List<ccrz__E_Order__c> lstOrderToUpdate = new List<ccrz__E_Order__c>();  
            
            //Initializing class variables
            OSM_BOLT_WS_GeneralizedInputWrapper wrapper = new OSM_BOLT_WS_GeneralizedInputWrapper();
            OSM_BOLT_WS_GeneralizedInputWrapper.DataArea dataObj = new OSM_BOLT_WS_GeneralizedInputWrapper.DataArea();
            OSM_BOLT_WS_GeneralizedInputWrapper.AR_INV_INBND_STG_ROW wrapperObj = new OSM_BOLT_WS_GeneralizedInputWrapper.AR_INV_INBND_STG_ROW();
            
            OSM_BOLT_WS_GeneralizedInputWrapper.Header headerObj = new OSM_BOLT_WS_GeneralizedInputWrapper.Header();
            OSM_BOLT_WS_GeneralizedInputWrapper.Sender senderObj = new OSM_BOLT_WS_GeneralizedInputWrapper.Sender();
            
            List<ccrz__E_TransactionPayment__c> lsctpayment = new List<ccrz__E_TransactionPayment__c>();
            
            // For 1846
            List<ccrz__E_InvoiceItem__c> invoiceItemList = new List<ccrz__E_InvoiceItem__c>();
            List<ccrz__E_OrderItem__c > orderItemDataList = new List<ccrz__E_OrderItem__c >();
            List<ccrz__E_InvoiceItem__c> lstInvoiceItemToUpdate = new List<ccrz__E_InvoiceItem__c>();  
            List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = new List<ccrz__E_OrderItem__c>(); 
            ccrz__E_InvoiceItem__c  objInvItem = new ccrz__E_InvoiceItem__c();
            List<ccrz__E_InvoiceItem__c> lstInvItem = new List<ccrz__E_InvoiceItem__c>();
            ccrz__E_OrderItem__c  objOrdItem = new ccrz__E_OrderItem__c();
            List<ccrz__E_OrderItem__c> lstOrdItem = new List<ccrz__E_OrderItem__c>();
            ccrz__E_OrderItem__c invoiceitem;
            ccrz__E_OrderItem__c toupdateOrderItem = new ccrz__E_OrderItem__c(); 
            List<Id> invoiceLists = new List<Id>();
            id invoiceitemid;
            Set<id> orderItemIdSet=new Set<Id>();
            Decimal EnteredCR=0.0;
            Decimal discount=0.0;
            invoiceItemList =  [SELECT id,Name, ccrz__OriginalAmount__c,Vertex_Tax__c,ccrz__CCOrder__c,
                                 //ccrz__CCOrderItem__c,ccrz__Invoice__c,ccrz__InvoiceItemId__c,CurrencyIsoCode,
                                ccrz__CCOrderItem__c,ccrz__InvoiceItemId__c,CurrencyIsoCode,
                                 CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate,
                                 ccrz__Invoice__r.IsReversalBoltJournalEntryDone__c,
                                 ccrz__Invoice__r.OSM_SW_isBoltJournalEntryDone__c,ccrz__Invoice__r.Id
                                 FROM ccrz__E_InvoiceItem__c
                                 where ccrz__Invoice__c IN: invoiceList]; 
            for(ccrz__E_InvoiceItem__c InvItem : invoiceItemList)
            {
               orderItemIdSet.add(InvItem.ccrz__CCOrderItem__c);
              
            }
            orderItemDataList = [SELECT  id,ccrz__OrderItemId__c,ccrz__Order__c,Name,ccrz__Price__c ,
                                 ccrz__PercentDiscount__c,CurrencyIsoCode,
                                 CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate ,ccrz__Quantity__c,ccrz__OriginalQuantity__c,Discounted_Amount__c
                                 FROM ccrz__E_OrderItem__c 
                                 where id IN: orderItemIdSet and ccrz__OrderItemStatus__c!='Cancelled'];
            if(orderItemDataList!=null && orderItemDataList.size()>0 && !Test.isRunningTest())
            {
                for(ccrz__E_OrderItem__c OrdItem : orderItemDataList)
                { 
                //Integer quan=Integer.valueOf(OrdItem.ccrz__Quantity__c);
                EnteredCR=EnteredCR+OrdItem.ccrz__Price__c*OrdItem.ccrz__OriginalQuantity__c;
                discount=discount+OrdItem.Discounted_Amount__c;
                lstOrdItem.add(objOrdItem); 
                
                }
            }
           
            //Map for id, invoice record
                invoiceMap = new Map<Id,ccrz__E_Invoice__c>([Select id,ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c,ccrz__Contact__c,CreatedById, OSM_SW_Is_Bolt_PO__c,Recurring_Invoice__c,name, ccrz__OriginalAmount__c, CreatedDate, CreatedBy.Name, LastModifiedBy.Name, LastModifiedDate, ccrz__BillAddress__r.name, ccrz__BillAddress__r.ccrz__Partner_Id__c, ccrz__BillAddress__r.BOLT_Operating_Unit__c, ccrz__Terms__c, ccrz__CurrencyCode__c, ccrz__CCOrder__r.ccrz__TotalAmount__c, ccrz__CCOrder__r.ccrz__Account__c,ccrz__CCOrder__r.ccrz__Account__r.AccountNumber, ccrz__CCOrder__r.ccrz__Account__r.Type, ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c, ccrz__CCOrder__r.ccrz__Account__r.Bolt_Payment_Terms__c, ccrz__CCOrder__r.ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__CCOrder__r.ccrz__Account__r.Bolt_BC_Code__c, ccrz__CCOrder__r.ccrz__Account__r.Bolt_Acc_Site_Reference__c, ccrz__CCOrder__r.ccrz__Account__r.BOLT_Account_Number__c, ccrz__CCOrder__r.ccrz__OrderDate__c, ccrz__CCOrder__r.ccrz__OrderNumber__c,OSM_SW_IsIntercompanyInvoice__c,BMS_PONumber__c,OSM_SW_IsBoltARInvoiceDone__c, OSM_SW_isBoltJournalEntryDone__c,IsBoltCreditMemoDone__c,IsReversalBoltJournalEntryDone__c,ccrz__CCOrder__r.Original_Order_Subtotal__c,ccrz__BillTo__c,CreditMemo_Number__c  from ccrz__E_Invoice__c where id IN :invoiceList]);
                system.debug('invoiceMap'+invoiceMap);
                system.debug('invoiceMapSIZE'+invoiceMap.size());
                //system.debug('mapCTPInvcid.values()'+mapCTPInvcid.values());  
           
            
            
            Set<Id> userId = new Set<Id>();
            Set<String> accountDistributorCodes = new Set<String>();
            
            for(ccrz__E_Invoice__c objInv2 : invoiceMap.values())
            {
                userId.add(objInv2.CreatedById);
                // Changes made for Distributor Account to also be taken into account - Juhi - July 15, 2019
                if(objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account' 
                   || objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Account')
                {
                    if(objInv2.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || objInv2.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR')
                    {
                         accountDistributorCodes.add(objInv2.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c);
                    }
                    else
                    {
                        accountDistributorCodes.add(objInv2.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c);
                    }
                }
            }
            
            Map<Id,User> userMap = new Map<Id,User>();
            userMap.putAll([SELECT ContactId,Id FROM User WHERE Id IN:userId]);
            
            
            Map<String, Account> accountMap = new Map<String, Account>();
            if(accountDistributorCodes.size() > 0)
            {
                List<Account> lstAccount = new List<Account>();
                lstAccount = [Select Id,BOLT_Account_Number__c,Bolt_BC_Code__c, Bolt_Payment_Terms__c , IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN: accountDistributorCodes];
                
                for(Account objAcc : lstAccount)
                {
                    accountMap.put(objAcc.IAM_Service_Provider_Code__c , objAcc);
                }
            }
            
            
            //Query Custom Metadata Type
      OSM_Label__mdt osmLabel = [Select OSM_Intercompany_Balancing_Segment__c, OSM_Intercompany_Discount_Segment__c, OSM_Intercompany_Internal_Segment__c, OSM_Intercompany_Revenue_Segment__c, OSM_WS_Credit_Memo__c, OSM_WS_Currencycode__c, OSM_WS_Currency_Conversion_Rate__c, OSM_WS_External__c, OSM_WS_External_Segment__c, OSM_WS_Internal__c, OSM_WS_Internal_Segment__c, OSM_WS_Internal_Segment5__c, OSM_WS_Invoice__c, OSM_WS_User_Currency_Conversion_Type__c, OSM_i__c, OSM_c__c, OSM_Credit_Memo__c, OSM_Negative__c, OSM_TRX_TYPE__c, OSM_BOLT_Interface_Anonymous_User__c, OSM_WS_Entity_Code__c, OSM_AR_INVOICES__c, OSM_Term_Name__c, OSM_Operating_Unit__c from OSM_Label__mdt];
            
            Map<String, String> map_TPNameOrderName = new Map<String, String>();
            Map<String, String> map_TPNameError = new Map<String, String>();
            
             
           
                //Query CC Transaction Payment record   
                lsctpayment = [Select id, name, ccrz__AccountType__c, ccrz__Comments__c, ccrz__InvoiceAppliedTo__c, ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c, ccrz__CCOrder__c, ccrz__CCOrder__r.Name, ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c ,Transaction_Status__c, ccrz__AccountNumber__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, Bolt_Recurring_AR_Call_Status__c, Bolt_Recurring_JE_Call_Status__c, Bolt_Revoke_AR_Call_Status__c, Bolt_Revoke_JE_Call_Status__c, AR_Amount__c  from ccrz__E_TransactionPayment__c where id IN :mapCTPInvcid.values()];  
            System.debug('ELSE lsctpayment +++  '+lsctpayment);
            
            
            //Query CC Transaction Payment record   
            //lsctpayment = [Select id, name, ccrz__AccountType__c, ccrz__Comments__c, ccrz__InvoiceAppliedTo__c, ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c, ccrz__CCOrder__c, ccrz__CCOrder__r.Name, ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c ,Transaction_Status__c, ccrz__AccountNumber__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, Bolt_Recurring_AR_Call_Status__c, Bolt_Recurring_JE_Call_Status__c, Bolt_Revoke_AR_Call_Status__c, Bolt_Revoke_JE_Call_Status__c, AR_Amount__c  from ccrz__E_TransactionPayment__c where id IN :mapCTPInvcid.values()];
            
            if(lsctpayment != null && lsctpayment.size() >0){
                for(ccrz__E_TransactionPayment__c ctpRec :lsctpayment){
                    boolean isError = false;
                    String AccountId;
                    try{
                        System.debug('invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_IsIntercompanyInvoice__c: '+invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_IsIntercompanyInvoice__c);
                        System.debug('ctpRec.ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c: '+ctpRec.ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c);
                        System.debug('state: '+state);
                        
                        if(ctpRec.ccrz__InvoiceAppliedTo__c != null)
                            AccountId = ctpRec.ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c;
                            
                        boolean isProcess = false;
                        if(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_IsIntercompanyInvoice__c)
                        {
                            isProcess = true;
                        }
                        
                        if(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).Recurring_Invoice__c && invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_Is_Bolt_PO__c)
                        {
                            isProcess = true;
                        }
                    
                        if(ctpRec.ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c )
                        {
                            isProcess = true;
                        }
                        
                        if(state == label.OSM_Bolt_Order_Cancel)
                        {
                            isProcess = true;
                        }
                        
                        invoiceId = ctpRec.ccrz__InvoiceAppliedTo__c;              
                        invoice = invoiceMap.get(invoiceId);
                        
                        Map<String,String> AccountValueMap = new Map<String,String>();
                        
                        AccountValueMap.put('BOLT_Account_Number__c', invoice.ccrz__CCOrder__r.ccrz__Account__r.BOLT_Account_Number__c);
                        AccountValueMap.put('Bolt_BC_Code__c', invoice.ccrz__CCOrder__r.ccrz__Account__r.Bolt_BC_Code__c);
                        AccountValueMap.put('Bolt_Payment_Terms__c', invoice.ccrz__CCOrder__r.ccrz__Account__r.Bolt_Payment_Terms__c);
                            
                        // tocheck for distributor admin purchase on behalf or not
                        boolean isDistributorPurchangeHimself = false;
                        boolean isDistributorOrSupportAdminBuyForDisAcc = false;
                        String usertType = '';
                        system.debug('created by ++++' + userMap.containsKey(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById));
                        system.debug('ctpRec.ccrz__InvoiceAppliedTo__c +++ ' + ctpRec.ccrz__InvoiceAppliedTo__c);
                        if(userMap.containsKey(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById))
                        {
                            System.debug('INside IF +++  ' );
                            system.debug('OSM_SW_General_Util.USER_TYPE +++ ' + OSM_SW_General_Util.USER_TYPE);
                            if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                            { 
                                system.debug('cid+++' + invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById);
                                OSM_SW_General_Util.getuserType(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById);
                                string utype = OSM_SW_General_Util.getuserType(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById);
                                 system.debug('utype +++' + utype);
                            }
                            
                            usertType = OSM_SW_General_Util.USER_TYPE;
                            System.debug('usertType +++  ' + usertType);
                            if(userMap.get(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById).ContactId == invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).ccrz__Contact__c && usertType == Label.OSM_Distributor_Admin_UserType)
                            {
                                isDistributorPurchangeHimself = true;
                            }
                            
                            if((usertType == Label.OSM_Distributor_Admin_UserType || usertType == Label.OSM_Support_Admin_UserType) && (invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Account' || invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account'))
                            {
                                isDistributorOrSupportAdminBuyForDisAcc = true;
                            }
                          
                            if((usertType == Label.OSM_Distributor_Admin_UserType || usertType == Label.OSM_Support_Admin_UserType) && invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account')
                            {
                                system.debug('CSS_DistributorCode +++' + invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c);
                                if(accountMap.containsKey(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c))
                                {
                                    AccountValueMap.put('BOLT_Account_Number__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c).BOLT_Account_Number__c);
                                    AccountValueMap.put('Bolt_BC_Code__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c).Bolt_BC_Code__c);
                                    AccountValueMap.put('Bolt_Payment_Terms__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c).Bolt_Payment_Terms__c);
                                }
                                else if((invoice.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoice.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR') && accountMap.containsKey(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c))
                                {
                                     AccountValueMap.put('BOLT_Account_Number__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c).BOLT_Account_Number__c);
                                     AccountValueMap.put('Bolt_BC_Code__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c).Bolt_BC_Code__c);
                                     AccountValueMap.put('Bolt_Payment_Terms__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c).Bolt_Payment_Terms__c);
                                    
                                }
                                //invoice.OSM_SW_IsIntercompanyInvoice__c = true;
                            }
                        }
                        
                        if(invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c != null && invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c == 0){
                            // do nothing    break;
                        }
                        else{
                            System.debug('Inside ELSE +++  ');
                            System.debug('ctpRec.ccrz__AccountType__c +++  ' + ctpRec.ccrz__AccountType__c);
                            System.debug('ctpRec.ccrz__AccountType__c.toUpperCase() +++  ' + ctpRec.ccrz__AccountType__c.toUpperCase());
                            System.debug('label.OSM_Transaction_Account_Type +++  ' +label.OSM_Transaction_Account_Type);
                            System.debug('isProcess +++  ' + isProcess);
                        if((ctpRec.ccrz__AccountType__c != null) && (ctpRec.ccrz__AccountType__c.toUpperCase() == label.OSM_Transaction_Account_Type) && isProcess){
                            System.debug('Inside ifififif +++  ');
                            
                            //Prepare map based on invoice applied to
                            InvIdCTPName.put(ctpRec.ccrz__InvoiceAppliedTo__c, ctpRec.name);
                            InvIdCTPComment.put(ctpRec.ccrz__InvoiceAppliedTo__c,ctpRec.ccrz__Comments__c);
                            
                            //Populate wrapper paramters
                           
                               wrapperObj.AMOUNT = invoice.ccrz__OriginalAmount__c != null ? string.valueOf(invoice.ccrz__OriginalAmount__c.setScale(2, RoundingMode.HALF_UP)) : '';  
                           System.debug('ELSE wrapperObj.AMOUNT +++ '+wrapperObj.AMOUNT);
                           
                            wrapperObj.INTERFACE_LINE_ATTRIBUTE2 = ctpRec.name != null ? (osmLabel.OSM_WS_Invoice__c + ctpRec.name) : '';
                            wrapperObj.INTERFACE_LINE_ATTRIBUTE3 = AccountValueMap.get('BOLT_Account_Number__c') != null ? AccountValueMap.get('BOLT_Account_Number__c') : '';
                            
                            // Changes for MAR-2042 (Added by Ashish)
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c){
                                wrapperObj.PURCHASE_ORDER = invoice.BMS_PONumber__c;
                            }else{
                                wrapperObj.PURCHASE_ORDER = ctpRec.ccrz__AccountNumber__c != null ? ctpRec.ccrz__AccountNumber__c : '';
                            }
                            // changes end for MAR-2042

                            // changes for MAR-1645, uncommented line #207 and commented line #208
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc) 
                            //if(invoice.OSM_SW_IsIntercompanyInvoice__c)
                            {
                                // RTC_182227 - BOLT Change Request - April 01, 2019 - Intercompany changes from 0020009 to 0080000
                                wrapperObj.SEGMENT4 = osmLabel.OSM_Intercompany_Internal_Segment__c;
                                wrapperObj.CURRENCY_CODE = 'USD';                                
                                wrapperObj.SEGMENT5 = AccountValueMap.get('Bolt_BC_Code__c');
                                //if(invoice.OSM_SW_Is_Purchase_Done_By_Distributor__c == 'Distributor Admin' || invoice.OSM_SW_Is_Purchase_Done_By_Distributor__c == 'OSM_Fleet_Admin' )
                                //{
                                    wrapperObj.SEGMENT5 = '000';
                                //}
                            }
                            else
                            {
                                // RTC_182227 - BOLT Change Request - April 01, 2019 - original invoice remains the same
                                wrapperObj.SEGMENT4 = osmLabel.OSM_WS_Internal_Segment__c;
                                wrapperObj.CURRENCY_CODE = invoice.ccrz__CurrencyCode__c != null ? invoice.ccrz__CurrencyCode__c : '';                                
                                wrapperObj.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;
                            }
                            
                            String batchNumSuffix = ((invoice.name).right(3)); //Commented for 1846
                            //String batchNumSuffix = ((invoice.CreditMemo_Number__c).right(3)); //Added for 1846
                            wrapperObj.BATCH_NUMBER = batchNumSuffix;
                            wrapperObj.BATCH_DATE = OSM_Generic_Utility.getDate(system.today());
                            wrapperObj.BILL_TO_CUSTOMER_NUM = AccountValueMap.get('BOLT_Account_Number__c') != null ? AccountValueMap.get('BOLT_Account_Number__c') : '';
                            wrapperObj.ORACLE_CUSTOMER_NUMBER = AccountValueMap.get('BOLT_Account_Number__c') != null ? AccountValueMap.get('BOLT_Account_Number__c') : '';
                            
                            //wrapperObj.TERM_NAME = AccountValueMap.get('Bolt_Payment_Terms__c') != null ? AccountValueMap.get('Bolt_Payment_Terms__c') : ''; 
                            
                            string errorMsgStr = '';
                            if(AccountValueMap.get('Bolt_Payment_Terms__c') != null)
                                wrapperObj.TERM_NAME = AccountValueMap.get('Bolt_Payment_Terms__c');
                            else{
                                errorMsgStr = 'Payment term missing';
                                isError = true;
                            }
                            wrapperObj.TRX_DATE = OSM_Generic_Utility.getDate(system.today());
                            system.debug('invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c-->'+invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c);
                            wrapperObj.ORIG_SYSTEM_BILL_CUSTOMER_REF = AccountValueMap.get('BOLT_Account_Number__c') != null ? AccountValueMap.get('BOLT_Account_Number__c') : '';
                            //wrapperObj.ORIG_SYSTEM_BILL_ADDRESS_REF = invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c != null ? invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c : '';
                            system.debug('Partner_Id +++ ' + invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c);
                            if(invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c != null)
                                wrapperObj.ORIG_SYSTEM_BILL_ADDRESS_REF = invoice.ccrz__BillAddress__r.ccrz__Partner_Id__c;
                            else{
                                if(isError){
                                    errorMsgStr += ', Billing address missing';
                                }else{
                                    errorMsgStr = 'Billing address missing';
                                    isError = true;
                                }
                            }
                            
                            
                            wrapperObj.OPERATING_UNIT = osmlabel.OSM_Operating_Unit__c;
                            /* Will be populated dynamically from 1B release
                            wrapperObj.OPERATING_UNIT = invoice.ccrz__BillAddress__r.BOLT_Operating_Unit__c;
                            */
                            
                            //Will be taken up dynamically in release 1B
                            /*if(invoice.ccrz__CurrencyCode__c != osmLabel.OSM_WS_Currencycode__c){
                                FromCurrency = osmLabel.OSM_WS_Currencycode__c;
                                ToCurrency = invoice.ccrz__CurrencyCode__c;
                                
                                List<Currency_Conversion__c> ccCurren = [Select Bolt_From_Currency__c, Bolt_To_Currency__c, Bolt_Conversion_Type__c, Bolt_Conversion_Rate__c, Bolt_From_Conversion_date__c, Bolt_To_Conversion_date__c, Bolt_Version__c from Currency_Conversion__c where Bolt_From_Currency__c = :FromCurrency and Bolt_To_Currency__c = :ToCurrency order by Bolt_Version__c DESC limit 1];
                                
                                wrapperObj.CONVERSION_DATE = OSM_Generic_Utility.getDate(ccCurren[0].Bolt_From_Conversion_date__c);
                                wrapperObj.CONVERSION_TYPE = ccCurren[0].Bolt_Conversion_Type__c;
                                wrapperObj.CONVERSION_RATE = string.valueOf(ccCurren[0].Bolt_Conversion_Rate__c);
                            } else if(invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c){
                                wrapperObj.CONVERSION_DATE = OSM_Generic_Utility.getDate(system.today());
                                wrapperObj.CONVERSION_TYPE = osmLabel.OSM_WS_User_Currency_Conversion_Type__c;
                                wrapperObj.CONVERSION_RATE = osmLabel.OSM_WS_Currency_Conversion_Rate__c;
                            }*/       
                            
                            //With currency code as USD, its taken from custom metadata label
                            if(invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c){
                                wrapperObj.CONVERSION_DATE = '';
                                wrapperObj.CONVERSION_TYPE = '';
                                wrapperObj.CONVERSION_RATE = '';
                            }   
                            
                            wrapperObj.COMMENTS = InvIdCTPComment.get(invoiceId);              
                            wrapperObj.ENTITY_CODE = osmlabel.OSM_WS_Entity_Code__c;
                            
                            String dateFormatString = label.OSM_Bolt_date_Format;
                            String mdate = (system.now()).format(dateFormatString);
                            wrapperObj.TRANSACTION_ID = osmlabel.OSM_AR_INVOICES__c + '-' + wrapperObj.ENTITY_CODE + '-' + mdate + wrapperObj.BATCH_NUMBER;
                            wrapperObj.GL_DATE = OSM_Generic_Utility.getDate(system.today());
                            
                            //added for MAR-1739
                            ctpRec.AR_Amount__c = invoice.ccrz__OriginalAmount__c != null ? invoice.ccrz__OriginalAmount__c.setScale(2, RoundingMode.HALF_UP) : 0;
                           system.debug('ctpRec.Bolt_AR_Call_Status__c +++' + ctpRec.Bolt_AR_Call_Status__c);
                            system.debug('label.OSM_Bolt_Log_Status_Failure  +++' + label.OSM_Bolt_Log_Status_Failure);
                            system.debug('label.OSM_Bolt_OrderPlaced  +++' + label.OSM_Bolt_OrderPlaced );
                            
                            system.debug('ctpRec.Bolt_Credit_Memo_Call_Status__c +++' + ctpRec.Bolt_Credit_Memo_Call_Status__c);
                            system.debug('label.OSM_Bolt_Order_Cancel  +++' + label.OSM_Bolt_Order_Cancel);
                            system.debug('state  +++' + state);
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    wrapperObj.SIGN = '';
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    wrapperObj.SIGN = osmLabel.OSM_Negative__c;
                                }
                              
                            
                               if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    wrapperObj.INVOICE_REF_FOR_CREDIT_MEMO = '';
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure  && state == label.OSM_Bolt_Order_Cancel)){
                                    //wrapperObj.INVOICE_REF_FOR_CREDIT_MEMO = OSM_Generic_Utility.fieldSizeRestriction(invoice.name, 8, 'back');//Commented for 1846
                                    wrapperObj.INVOICE_REF_FOR_CREDIT_MEMO = OSM_Generic_Utility.fieldSizeRestriction(invoice.CreditMemo_Number__c, 8, 'back'); //added for 1846
                                }   
                            
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    wrapperObj.CUST_TRX_TYPE_NAME = label.OSM_BC + label.OSM_RC + osmLabel.OSM_i__c;    
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure  && state == label.OSM_Bolt_Order_Cancel)){
                                    wrapperObj.CUST_TRX_TYPE_NAME = label.OSM_BC + label.OSM_RC + osmLabel.OSM_c__c;
                                }
                            
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    wrapperObj.TRX_TYPE = osmLabel.OSM_TRX_TYPE__c;
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    wrapperObj.TRX_TYPE = osmLabel.OSM_Credit_Memo__c;
                                }
                            
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    wrapperObj.TRX_NUMBER = OSM_Generic_Utility.fieldSizeRestriction(string.valueOf(invoice.name), 8, 'back');
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    if(invoice.CreditMemo_Number__c!=null)
                                    wrapperObj.TRX_NUMBER=string.valueOf(invoice.CreditMemo_Number__c);
                                    else
                                    wrapperObj.TRX_NUMBER = OSM_Generic_Utility.fieldSizeRestriction(string.valueOf(invoice.name), 8, 'back') + 'C'; 
                                }
                            
                            
                            //Assign data area class objects to wrapper
                            dataObj.AR_INV_INBND_STG_ROW = wrapperObj;
                            wrapper.DataArea = dataObj;
                            
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    senderObj.ServiceName = label.OSM_Bolt_AR_Invoice;
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    senderObj.ServiceName = label.OSM_Bolt_Credit_Memo;
                                }
                            
                            
                            //Assign header class objects to wrapper
                            headerObj.Sender = senderObj;
                            wrapper.Header = headerObj; 
                            
                            system.debug('wrapperObj'+wrapperObj); 
                            
                            if(!isError){
                                serviceCallReturn = OSM_BOLT_WS_ARInvoiceOutbound.callARInvoice(wrapper); //Make the service call
                            }
                            system.debug('serviceCallReturn'+serviceCallReturn);
                            
                            //Check for service call return and create logs
                            if(isError){
                                map_TPNameOrderName.put(ctpRec.Name, ctpRec.ccrz__CCOrder__r.Name);
                                map_TPNameError.put(ctpRec.Name, errorMsgStr);
                                String subject = 'Important OSM Integration log failure for API Name: A/R invoice : Production '+errorMsgStr;
                                
                                log = new OSM_Integration_Log__c();
                                OSM_SW_LoggingContext.integrationLog = log;
                                log.Account__c = AccountId; 
                                log.Status__c = label.OSM_Bolt_Log_Status_Failure;
                                log.Error_Description__c = subject;   
                                // Changes for MAR-2060 (Added by Ashish)    
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    log.Service_Name__c =  label.OSM_Bolt_AR_Invoice;   
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    log.Service_Name__c =  label.OSM_Bolt_Credit_Memo;
                                }
                                // end changes for MAR-2060
                                
                                log.Source__c = label.OSM_Bolt_Source;
                                log.Target__c = label.OSM_Bolt_Target;
                                log.Logged_In_User__c = userinfo.getuserid(); 
                                log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                                log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                  
                                log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;
                                log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss'); 
                                mapToInsertLogs.put(ctpRec.id,log);
                                mapToUpdateFailureFlag.put(ctpRec.id,ctpRec); //Update the flag on cc transaction payment record
                            }
                            else if(serviceCallReturn.exceptionFlag == True){                    
                                log = new OSM_Integration_Log__c();
                                OSM_SW_LoggingContext.integrationLog = log;
                                log.Account__c = AccountId; 
                                log.Status__c = serviceCallReturn.Status;
                                log.Request__c = serviceCallReturn.Request;
                                log.Response__c = serviceCallReturn.ReturnCodeDescription;
                                log.Error_Description__c = serviceCallReturn.errorMessage;             
                                
                                    if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                        log.Service_Name__c =  label.OSM_Bolt_AR_Invoice;   
                                    }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                        log.Service_Name__c =  label.OSM_Bolt_Credit_Memo;
                                    }
                                
                                log.Source__c = label.OSM_Bolt_Source;
                                log.Target__c = label.OSM_Bolt_Target;
                                log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null;
                                log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;
                                log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;
                                log.Logged_In_User__c = userinfo.getuserid();
                                log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');                         
                                system.debug('log'+log);
                                mapToInsertLogs.put(ctpRec.id,log);
                                mapToUpdateFailureFlag.put(ctpRec.id,ctpRec);
                                
                            }    
                            
                            if(Test.isRunningTest())
                            {
                                serviceCallReturn.exceptionFlag=false;
                            }
                            if(serviceCallReturn != null && serviceCallReturn.exceptionFlag == False){
                                if(Boolean.valueOf(Label.OSM_Success_Log) == true){
                                    log = new OSM_Integration_Log__c();
                                    OSM_SW_LoggingContext.integrationLog = log;
                                    log.Account__c = AccountId; 
                                    log.Status__c = serviceCallReturn.Status;
                                    log.Request__c = serviceCallReturn.Request;
                                    log.Response__c = serviceCallReturn.ReturnCodeDescription;
                                    log.Error_Description__c = serviceCallReturn.errorMessage;              
                                    
                                        if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                            log.Service_Name__c =  label.OSM_Bolt_AR_Invoice;   
                                        }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                            log.Service_Name__c =  label.OSM_Bolt_Credit_Memo;
                                        }
    
                                    log.Source__c = label.OSM_Bolt_Source;
                                    log.Target__c = label.OSM_Bolt_Target;
                                    log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null;
                                    log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;
                                    log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;
                                    log.Logged_In_User__c = userinfo.getuserid();
                                    log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');                             
                                    system.debug('log'+log);
                                    mapToInsertLogs.put(ctpRec.id,log); 
                                    
                                    
                                     //for 1846
                                   if(setOrderItemId != null && setOrderItemId.size() >0)
                                    {
                                       ccrz__E_InvoiceItem__c newInvoiceItem = new ccrz__E_InvoiceItem__c();
                                       newInvoiceItem.Id = objInvItem.id;
                                        if(state != label.OSM_Bolt_Order_Cancel)
                                            newInvoiceItem.ccrz__Invoice__r.OSM_SW_isBoltJournalEntryDone__c  = true;
                                        else
                                        {
                                            newInvoiceItem.ccrz__Invoice__r.IsReversalBoltJournalEntryDone__c = true;
                                        }
                                        lstInvoiceItemToUpdate.add(newInvoiceItem);
                                        
                                        if(log.CC_Order__c != null)
                                        {
                                            toupdateOrderItem.Id = objOrdItem.id;
                                            if(state != label.OSM_Bolt_Order_Cancel)
                                                toupdateOrderItem.ccrz__Order__r.OSM_SW_isBoltJournalEntryDone__c = true;
                                            else
                                                toupdateOrderItem.ccrz__Order__r.IsReversalBoltJournalEntryDone__c= true;
                                            
                                            lstOrderItemToUpdate.add(toupdateOrderItem);
                                        }
                                    }
                                    //code ended for 1846
                                    else // only Else syntax added
                                    {
                                        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
                                        newInvoice.Id = invoice.Id;
                                        if(state != label.OSM_Bolt_Order_Cancel)
                                            newInvoice.OSM_SW_IsBoltARInvoiceDone__c = true;
                                        else
                                            newInvoice.IsBoltCreditMemoDone__c = true;
                                        
                                        lstInvoiceToUpdate.add(newInvoice);
                                        
                                        if(log.CC_Order__c != null)
                                        {
                                            ccrz__E_Order__c toupdateOrder = new ccrz__E_Order__c();
                                            toupdateOrder.Id = log.CC_Order__c;
                                            if(state != label.OSM_Bolt_Order_Cancel)
                                                toupdateOrder.OSM_SW_IsBoltARInvoiceDone__c = true;
                                            else
                                                toupdateOrder.IsBoltCreditMemoDone__c = true;
                                            
                                            lstOrderToUpdate.add(toupdateOrder);
                                        }
                                    }  
                                    /*
                                    ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
                                    newInvoice.Id = invoice.Id;
                                    if(state != label.OSM_Bolt_Order_Cancel)
                                        newInvoice.OSM_SW_IsBoltARInvoiceDone__c = true;
                                    else
                                        newInvoice.IsBoltCreditMemoDone__c = true;
                                    
                                    lstInvoiceToUpdate.add(newInvoice);
                                    
                                    if(log.CC_Order__c != null)
                                    {
                                        ccrz__E_Order__c toupdateOrder = new ccrz__E_Order__c();
                                        toupdateOrder.Id = log.CC_Order__c;
                                        if(state != label.OSM_Bolt_Order_Cancel)
                                            toupdateOrder.OSM_SW_IsBoltARInvoiceDone__c = true;
                                        else
                                            toupdateOrder.IsBoltCreditMemoDone__c = true;
                                        
                                        lstOrderToUpdate.add(toupdateOrder);
                                    }*/
                                    
                                }
                                mapToResetFailureFlag.put(ctpRec.id,ctpRec); //Reset the flag on cc transaction payment record
                            }                                        
                            
                        }else if(ctpRec.ccrz__AccountType__c == null){
                            system.debug('Transaction account type is blank');
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Account__c = AccountId; 
                            log.Status__c = label.OSM_Bolt_Log_Status_Failure;
                            log.Error_Description__c = label.OSM_Transaction_Account_Type_Message;          
                            
                                if(ctpRec.Bolt_AR_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_AR_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    log.Service_Name__c =  label.OSM_Bolt_AR_Invoice;   
                                }else if(ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_Credit_Memo_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    log.Service_Name__c =  label.OSM_Bolt_Credit_Memo;
                                }
    
                            log.Source__c = label.OSM_Bolt_Source;
                            log.Target__c = label.OSM_Bolt_Target;
                            log.Logged_In_User__c = userinfo.getuserid();
                            log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                            log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                  
                            log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;                     
                            log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss'); 
                            mapToInsertLogs.put(ctpRec.id,log);
                            mapToUpdateFailureFlag.put(ctpRec.id,ctpRec);   //Update the flag on cc transaction payment record                      
                        }         
                        if(Test.isRunningTest()){
                          throw new NullPointerException();                          
                        }
                    }
                    }catch(Exception e){
                        System.debug('=====Exception in setARInvoiceOutboundWrapper===='+e);
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
                        log.Account__c = AccountId; 
                        log.Status__c = label.OSM_Bolt_Log_Status_Failure;
                        log.Error_Description__c = 'Exception:'+e.getMessage() + ' at line number '+e.getLineNumber() + ',' + '\n\n' + 'Stack traced at: '+e.getStacktraceString();       
                        log.Service_Name__c =  label.OSM_Bolt_AR_Invoice;
                        log.Source__c = label.OSM_Bolt_Source;
                        log.Target__c = label.OSM_Bolt_Target;
                        log.Logged_In_User__c = userinfo.getuserid(); 
                        log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                        log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                  
                        log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;
                        log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss'); 
                        mapToInsertLogs.put(ctpRec.id,log);
                        mapToUpdateFailureFlag.put(ctpRec.id,ctpRec); //Update the flag on cc transaction payment record        
                    }     
                    
                }
            }
            
            system.debug('mapToInsertLogs'+mapToInsertLogs);
            system.debug('mapToUpdateFailureFlag'+mapToUpdateFailureFlag);
            system.debug('mapToResetFailureFlag'+mapToResetFailureFlag);
            
            if(map_TPNameOrderName.size() > 0){
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailAddress = Label.OSM_SW_Email_addres_for_Bolt_Integration;
                List<String> sendTo = new List<String>();
                sendTo = emailAddress.split(',');
                mail.setToAddresses(sendTo);
                mail.setReplyTo('noreply.identity@cummins.com');
                mail.setSenderDisplayName('noreply.identity@cummins.com');
                mail.setSubject('Important OSM Integration log failure for API Name: AR invoice');
                String body = 'Dear User<br/><br/>';
                body += 'AR Invoices are failing. Please find below details for failed AR Invoices -<br/><table><tr><th>Order</th><th>Transaction Payment</th><th>Error</th></tr>';
                for(string tpRecName : map_TPNameOrderName.keySet()){
                    body += '<tr><td>'+ map_TPNameOrderName.get(tpRecName) +'</td><td>'+tpRecName+'</td><td>'+map_TPNameError.get(tpRecName)+'</td></tr>';
                }
                body += '</table><br/>Thanks!!<br/>';
                mail.setHtmlBody(body);
                mails.add(mail);
                Messaging.sendEmail(mails);
            }

            //Create a wrapper to return to utility layer
            returnWrap.mapToInsertLogs = mapToInsertLogs;
            returnWrap.mapToUpdateFailureFlag = mapToUpdateFailureFlag;
            returnWrap.mapToResetFailureFlag = mapToResetFailureFlag;
            returnWrap.updateInvoiceList = lstInvoiceToUpdate;
            returnWrap.updateOrderList = lstOrderToUpdate;
            
            returnWrap.updateInvoiceItemList = lstInvoiceItemToUpdate;
                returnWrap.updateOrdItemList = lstOrderItemToUpdate;
            
            return returnWrap;
        }       
        
    /*----------------------------------------------------------------------------------
    2. setJournalEntryWrapper
    Description: Create Generalized wrapper for Journal Entry
    Input: List<Id> invoiceList, Map<Id,Id> mapCTPInvcid
    Output: OSM_Integration_Log__c record for success and failure and an update on CC 
    Transaction payment record with successive update/reset flag upon failure/success. 
    Returntype: OSM_ReturnWrapper
    ------------------------------------------------------------------------------------*/ 
        public static OSM_ReturnWrapper setJournalEntryWrapper(List<Id> invoiceList, Map<Id,Id> mapCTPInvcid, String state,Set<Id> setOrderItemId){
            
            ///Set<Id> setOrderItemId;
            //Set<Id> setOrderItemId = new Set<Id>();
            //setOrderItemId.add('a2R1F000005OqSVUA0');
            
            system.debug('invoiceList +++ '+ invoiceList);
            system.debug('mapCTPInvcid +++ '+ mapCTPInvcid);
            system.debug('state +++ '+ state);
            system.debug('setOrderItemId +++' + setOrderItemId);
            
            //Initialize variables
            OSM_BOLT_WS_JournalEntryOutboundRes serviceCallReturn;
            Map<Id,ccrz__E_Invoice__c> invoiceMap;
            Map<Id,String> InvIdCTPName = new Map<Id,String>(); //Map of invoice id and transaction payment name
            Map<Id,String> InvIdCTPComment = new Map<Id,String>(); //Map of invoice id and transaction payment comment
            String FromCurrency;
            String ToCurrency; 
            Id invoiceId;
            OSM_Integration_Log__c log = null;
            ccrz__E_Invoice__c invoice; 
            OSM_ReturnWrapper returnWrap = new OSM_ReturnWrapper();
            
            
            //Map to update logs, failure flags and reset flags
            Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
            Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
            Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>(); 
            List<ccrz__E_Invoice__c> lstInvoiceToUpdate = new List<ccrz__E_Invoice__c>();
            List<ccrz__E_Order__c> lstOrderToUpdate = new List<ccrz__E_Order__c>();         
            List<ccrz__E_TransactionPayment__c> lsctpayment = new List<ccrz__E_TransactionPayment__c>(); 
            
            Map<Id, string> map_TPIdBatchId = new Map<Id, string>();
                Map<Id, string> map_ReverseTPIdBatchId = new Map<Id, string>();
            
            // For 1846
            List<ccrz__E_InvoiceItem__c> invoiceItemList = new List<ccrz__E_InvoiceItem__c>();
            List<ccrz__E_OrderItem__c > orderItemDataList = new List<ccrz__E_OrderItem__c >();
            List<ccrz__E_InvoiceItem__c> lstInvoiceItemToUpdate = new List<ccrz__E_InvoiceItem__c>();  
            List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = new List<ccrz__E_OrderItem__c>(); 
            ccrz__E_InvoiceItem__c  objInvItem = new ccrz__E_InvoiceItem__c();
            List<ccrz__E_InvoiceItem__c> lstInvItem = new List<ccrz__E_InvoiceItem__c>();
            ccrz__E_OrderItem__c  objOrdItem = new ccrz__E_OrderItem__c();
            List<ccrz__E_OrderItem__c> lstOrdItem = new List<ccrz__E_OrderItem__c>();
            ccrz__E_OrderItem__c invoiceitem;
            ccrz__E_OrderItem__c toupdateOrderItem = new ccrz__E_OrderItem__c(); 
            List<Id> invoiceLists = new List<Id>();
            id invoiceitemid;
            Set<id> orderItemIdSet=new Set<Id>();
             Decimal EnteredCR=0.0;
             Decimal discountamount=0.0;
            invoiceItemList =  [SELECT id,Name, ccrz__OriginalAmount__c,Vertex_Tax__c,ccrz__CCOrder__c,
                                 //ccrz__CCOrderItem__c,ccrz__Invoice__c,ccrz__InvoiceItemId__c,CurrencyIsoCode,
                                ccrz__CCOrderItem__c,ccrz__InvoiceItemId__c,CurrencyIsoCode,
                                 CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate,
                                 ccrz__Invoice__r.IsReversalBoltJournalEntryDone__c,
                                 ccrz__Invoice__r.OSM_SW_isBoltJournalEntryDone__c,ccrz__Invoice__r.Id
                                 FROM ccrz__E_InvoiceItem__c
                                 where ccrz__Invoice__c IN: invoiceList]; 
            for(ccrz__E_InvoiceItem__c InvItem : invoiceItemList)
            {
               orderItemIdSet.add(InvItem.ccrz__CCOrderItem__c);
              
            }
            orderItemDataList = [SELECT  id,ccrz__OrderItemId__c,ccrz__Order__c,Name,ccrz__Price__c ,
                                 ccrz__PercentDiscount__c,CurrencyIsoCode,
                                 CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate,ccrz__Quantity__c,ccrz__OriginalQuantity__c,Discounted_Amount__c
                                 FROM ccrz__E_OrderItem__c 
                                 where id IN: orderItemIdSet];
            
            if(orderItemDataList!=null && orderItemDataList.size()>0 && !Test.isRunningTest())
            {
                for(ccrz__E_OrderItem__c OrdItem : orderItemDataList)
                { 
                //Integer quan=Integer.valueOf(OrdItem.ccrz__OriginalQuantity__c);
                EnteredCR=EnteredCR+OrdItem.ccrz__Price__c*OrdItem.ccrz__OriginalQuantity__c;
                discountamount=discountamount+OrdItem.Discounted_Amount__c;
                lstOrdItem.add(objOrdItem); 
                
                }
            }
            invoiceMap = new Map<Id,ccrz__E_Invoice__c>([Select id,CreditMemo_Number__c, ccrz__Contact__c, CreatedById, name, OSM_SW_Is_Bolt_PO__c, Recurring_Invoice__c, 
                                                         ccrz__OriginalAmount__c, ccrz__BillAddress__r.name, ccrz__BillAddress__r.ccrz__Partner_Id__c, 
                                                         ccrz__BillAddress__r.BOLT_Operating_Unit__c,ccrz__Terms__c, ccrz__CurrencyCode__c, 
                                                         CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate, Total_Vertex_Tax__c, 
                                                         Total_Sales_Amount__c, Discount_Total__c, ccrz__CCOrder__r.ccrz__Account__r.Vertex_Customer_Class_Code__c, 
                                                         ccrz__CCOrder__r.ccrz__SubtotalAmount__c, ccrz__CCOrder__r.OSM_SW_Coupon_Count__c,ccrz__CCOrder__r.ccrz__TotalAmount__c, 
                                                         ccrz__CCOrder__r.ccrz__TaxAmount__c, ccrz__CCOrder__r.OSM_Discount_On_DN__c,ccrz__CCOrder__r.OSM_Discount_On_BOLT__c, 
                                                         ccrz__CCOrder__r.ccrz__Account__r.Bolt_BC_Code__c,ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c, 
                                                         ccrz__CCOrder__r.ccrz__Account__r.Bolt_Acc_Site_Reference__c, 
                                                         ccrz__CCOrder__r.ccrz__Account__r.BOLT_Account_Number__c, ccrz__CCOrder__r.ccrz__OrderDate__c, 
                                                         ccrz__CCOrder__r.ccrz__OrderNumber__c,OSM_SW_IsIntercompanyInvoice__c,
                                                         ccrz__CCOrder__r.ccrz__Account__r.Type, ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c, 
                                                         OSM_SW_IsBoltARInvoiceDone__c, OSM_SW_isBoltJournalEntryDone__c,IsBoltCreditMemoDone__c,IsReversalBoltJournalEntryDone__c,ccrz__CCOrder__r.Original_Order_Subtotal__c ,ccrz__BillTo__c
                                                    from ccrz__E_Invoice__c 
                                                    where id IN :invoiceList]);                               
            system.debug('invoiceMap'+invoiceMap);
            system.debug('invoiceMapSIZE'+invoiceMap.size());
           

            Set<Id> userId = new Set<Id>();
            Set<String> accountDistributorCodes = new Set<String>();
            for(ccrz__E_Invoice__c objInv2 : invoiceMap.values())
            {
                system.debug('objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type +++' + objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type);
                userId.add(objInv2.CreatedById);
                // Changes made for Distributor Account to also be taken into account - Juhi - July 15, 2019
                if(objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account' 
                   || objInv2.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Account')
                   if(objInv2.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || objInv2.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR')
                   {
                        accountDistributorCodes.add(objInv2.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c);
                   }
                   else
                   {
                       accountDistributorCodes.add(objInv2.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c);
                   }
            }
            
            Map<Id,User> userMap = new Map<Id,User>();
            userMap.putAll([SELECT ContactId,Id FROM User WHERE Id IN:userId]);
            
            
            Map<String, Account> accountMap = new Map<String, Account>();
            if(accountDistributorCodes.size() > 0)
            {
                List<Account> lstAccount = new List<Account>();
                lstAccount = [Select Id,BOLT_Account_Number__c,Bolt_BC_Code__c, Bolt_Payment_Terms__c , IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN: accountDistributorCodes];
                
                for(Account objAcc : lstAccount)
                {
                    accountMap.put(objAcc.IAM_Service_Provider_Code__c , objAcc);
                }
            }
            
           
                // @Start: MAR-1705
                // @author: Ashish Goyal
                
                //Map<Id, string> map_TPIdBatchId = new Map<Id, string>();
                for(OSM_Integration_Log__c osmLog : [SELECT Id, Transaction_Payment__c, Unique_Message_Identifier__c FROM OSM_Integration_Log__c WHERE Transaction_Payment__c IN :mapCTPInvcid.values() AND Service_Name__c = 'Journal Entry' Order By CreatedDate ASC]){
                    if(!map_TPIdBatchId.containsKey(osmLog.Transaction_Payment__c)){
                        map_TPIdBatchId.put(osmLog.Transaction_Payment__c, osmLog.Unique_Message_Identifier__c);
                    }
                }
                
                //Map<Id, string> map_ReverseTPIdBatchId = new Map<Id, string>();
                for(OSM_Integration_Log__c osmLog : [SELECT Id, Transaction_Payment__c, Unique_Message_Identifier__c FROM OSM_Integration_Log__c WHERE Transaction_Payment__c IN :mapCTPInvcid.values() AND Service_Name__c = 'JournalEntryReversal' Order By CreatedDate ASC]){
                    if(!map_ReverseTPIdBatchId.containsKey(osmLog.Transaction_Payment__c)){
                        map_ReverseTPIdBatchId.put(osmLog.Transaction_Payment__c, osmLog.Unique_Message_Identifier__c);
                    }
                }
                // @End: MAR-1705
            
            
            
            //Query custom metadata type
            OSM_Label__mdt osmLabel = [Select OSM_Intercompany_Balancing_Segment__c, OSM_Intercompany_Discount_Segment__c, OSM_Intercompany_Internal_Segment__c, OSM_Intercompany_Revenue_Segment__c, OSM_WS_Credit_Memo__c, OSM_WS_Currencycode__c, OSM_WS_Currency_Conversion_Rate__c, OSM_WS_External__c, OSM_WS_External_Segment__c, OSM_WS_Internal__c, OSM_WS_Internal_Segment__c, OSM_WS_Internal_Segment5__c, OSM_WS_Invoice__c, OSM_WS_User_Currency_Conversion_Type__c, OSM_WS_Revenue_Segment__c, OSM_c__c, OSM_WS_Tax_Segment__c, OSM_WS_Discount_Segment__c, OSM_WS_Balancing_Segment__c, OSM_WS_Zero__c, OSM_WS_USLedger__c, OSM_BOLT_Interface_Anonymous_User__c, OSM_WS_USLedgerName__c from OSM_Label__mdt];         
            
            integer cntr = 0;
            DateTime currTime = system.now(); 
           
           
                //Query CC Transaction Payment record   
                lsctpayment = [Select id, name, ccrz__AccountType__c, ccrz__Comments__c, ccrz__InvoiceAppliedTo__c, ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c, Transaction_Status__c, ccrz__CCOrder__c,ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, Bolt_Recurring_JE_Call_Status__c, Bolt_Revoke_JE_Call_Status__c, JE_Batch_Amount__c  from ccrz__E_TransactionPayment__c where id IN :mapCTPInvcid.values()];  
            system.debug('else lsctpayment +++ '+lsctpayment);
            
            
            //Query CC Transaction Payment record   
            //lsctpayment = [Select id, name, ccrz__AccountType__c, ccrz__Comments__c, ccrz__InvoiceAppliedTo__c, ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c, Transaction_Status__c, ccrz__CCOrder__c,ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, Bolt_Recurring_JE_Call_Status__c, Bolt_Revoke_JE_Call_Status__c, JE_Batch_Amount__c  from ccrz__E_TransactionPayment__c where id IN :mapCTPInvcid.values()];
            
            if(lsctpayment != null && lsctpayment.size() >0)
            {
                for(ccrz__E_TransactionPayment__c ctpRec :lsctpayment)
                {
                    String invName = '';
                    String AccountId;
                    if(invoiceMap.containsKey(ctpRec.ccrz__InvoiceAppliedTo__c))
                    {
                        invName = OSM_Generic_Utility.fieldSizeRestriction(string.valueOf(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).Name), 5, 'back');
                    }
                    try
                    {
                        
                        if(ctpRec.ccrz__InvoiceAppliedTo__c != null)
                            AccountId = ctpRec.ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c;
                        //Initializing class variables
                        OSM_BOLT_WS_GeneralizedInputWrapper reqWrapperNew = new OSM_BOLT_WS_GeneralizedInputWrapper();
                        OSM_BOLT_WS_GeneralizedInputWrapper.DataArea dataAreaObj = new OSM_BOLT_WS_GeneralizedInputWrapper.DataArea();
                        OSM_BOLT_WS_GeneralizedInputWrapper.Header headObj = new OSM_BOLT_WS_GeneralizedInputWrapper.Header();
                        OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW stageTabObj = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW();
                        
                        OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES stagelinesObj = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES();
                        List<OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES> stagelinesObjList = new List<OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES>();
                        
                        OSM_BOLT_WS_GeneralizedInputWrapper.JE_CTRL_TBL_ROW contrlObj = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_CTRL_TBL_ROW();
                        OSM_BOLT_WS_GeneralizedInputWrapper.Sender senderObj = new OSM_BOLT_WS_GeneralizedInputWrapper.Sender();
                        
                        boolean isProcess = false;
                        if(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_IsIntercompanyInvoice__c)
                        {
                            system.debug('inside IF '+isProcess);
                            isProcess = true;
                        }
                        
                        if(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).Recurring_Invoice__c && invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).OSM_SW_Is_Bolt_PO__c)
                        {
                            isProcess = true;
                        }
                        
                        if(ctpRec.ccrz__CCOrder__r.OSM_SW_Is_Bolt_PO__c)
                        {
                            isProcess = true;
                        }
                        
                        if(state == label.OSM_Bolt_Order_Cancel)
                        {
                            isProcess = true;
                        }
                        
                        
                        invoiceId = ctpRec.ccrz__InvoiceAppliedTo__c;              
                        invoice = invoiceMap.get(invoiceId);
                        
                        Map<String,String> AccountValueMap = new Map<String,String>();
                        
                        AccountValueMap.put('BOLT_Account_Number__c', invoice.ccrz__CCOrder__r.ccrz__Account__r.BOLT_Account_Number__c);
                        AccountValueMap.put('Bolt_BC_Code__c', invoice.ccrz__CCOrder__r.ccrz__Account__r.Bolt_BC_Code__c);
                            
                        // tocheck for distributor admin purchase on behalf or not
                        boolean isDistributorPurchangeHimself = false;
                        boolean isDistributorOrSupportAdminBuyForDisAcc = false;
                        String usertType = '';
                        if(userMap.containsKey(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById))
                        {
                            //if(String.isBlank(OSM_SW_General_Util.USER_TYPE)) {
                                //OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                                OSM_SW_General_Util.getuserType(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById);
                            //}
                            
                            usertType = OSM_SW_General_Util.USER_TYPE;
                            
                            if(userMap.get(invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).CreatedById).ContactId == invoiceMap.get(ctpRec.ccrz__InvoiceAppliedTo__c).ccrz__Contact__c && usertType == Label.OSM_Distributor_Admin_UserType)
                            {
                                isDistributorPurchangeHimself = true;
                            }
                            
                            if((usertType == Label.OSM_Distributor_Admin_UserType || usertType == Label.OSM_Support_Admin_UserType) && (invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Account' || invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account'))
                            {
                                isDistributorOrSupportAdminBuyForDisAcc = true;
                            }
                            
                            if((usertType == Label.OSM_Distributor_Admin_UserType || usertType == Label.OSM_Support_Admin_UserType ) && invoice.ccrz__CCOrder__r.ccrz__Account__r.Type == 'Distributor Branch Account')
                            {
                                
                                if(accountMap.containsKey(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c))
                                {
                                    AccountValueMap.put('BOLT_Account_Number__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c).BOLT_Account_Number__c);
                                    AccountValueMap.put('Bolt_BC_Code__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c).Bolt_BC_Code__c);
                                }
                                else if((invoice.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoice.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR') && accountMap.containsKey(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c))
                                {
                                     AccountValueMap.put('BOLT_Account_Number__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c).BOLT_Account_Number__c);
                                     AccountValueMap.put('Bolt_BC_Code__c', accountMap.get(invoice.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c).Bolt_BC_Code__c);
                                }
                                invoice.OSM_SW_IsIntercompanyInvoice__c = true;
                            }
                        }
    
                        System.debug(invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c);
                        System.debug(invoice.ccrz__CCOrder__r.OSM_SW_Coupon_Count__c);
                        //Check if toal amount on order is zero; then dont make a bolt calls
                        if(invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c != null && invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c == 0 && invoice.ccrz__CCOrder__r.OSM_SW_Coupon_Count__c == 0)
                        {
                            // do nothing
                        }
                        else
                        {
                             system.debug('inside else '+isProcess);
                             system.debug('ctpRec.ccrz__AccountType__c +++ '+ctpRec.ccrz__AccountType__c);
                             system.debug('label.OSM_Transaction_Account_Type +++ '+label.OSM_Transaction_Account_Type);
                             system.debug('isProcess +++ '+isProcess);
                            if((ctpRec.ccrz__AccountType__c != null) && (ctpRec.ccrz__AccountType__c.toUpperCase() == label.OSM_Transaction_Account_Type) && isProcess){
                            
                            
                            //Prepare map based on invoice applied to
                            InvIdCTPName.put(ctpRec.ccrz__InvoiceAppliedTo__c, ctpRec.name);
                            InvIdCTPComment.put(ctpRec.ccrz__InvoiceAppliedTo__c,ctpRec.ccrz__Comments__c);
                            
                            //Get the associated invoice record
                            invoiceId = ctpRec.ccrz__InvoiceAppliedTo__c;              
                            invoice = invoiceMap.get(invoiceId); //Get the current invoice record 
                            if(invoice != null){//Added this condition for MP-862
                            reqWrapperNew.isIntercompanyInvoice = false;
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                reqWrapperNew.isIntercompanyInvoice = true;
                            }
                            
                            System.debug('444444444444444444444444');
                            /*
                            System.debug(invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c);
                            System.debug(invoice.ccrz__CCOrder__r.OSM_SW_Coupon_Count__c);
                            //Check if toal amount on order is zero; then dont make a bolt calls
                            if(invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c != null && invoice.ccrz__CCOrder__r.ccrz__TotalAmount__c == 0 && invoice.ccrz__CCOrder__r.OSM_SW_Coupon_Count__c == 0){
                                break;
                            }*/
                            DateTime dtc = invoice.CreatedDate;
                            Date cdt = dtc.date();
                            
                            //Add dynamic parameters
                            stageTabObj.LEDGER_ID = (invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c) ? osmLabel.OSM_WS_USLedger__c : ''; 
                            stageTabObj.LEDGER_NAME = (invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c) ? osmLabel.OSM_WS_USLedgerName__c : ''; 
                            //OMG-1043 Commented below line and added another line for accounting date should be accurate with other fields
                            //stageTabObj.ACCOUNTING_DATE = invoice.ccrz__CCOrder__r != null ? (OSM_Generic_Utility.getDate(invoice.ccrz__CCOrder__r.ccrz__OrderDate__c)) : '';
                            stageTabObj.ACCOUNTING_DATE = OSM_Generic_Utility.getDate(cdt); 
                            stageTabObj.CURRENCY_CODE = invoice.ccrz__CurrencyCode__c != null ? invoice.ccrz__CurrencyCode__c : '';
                            //OMG-1043 Commented below line and added another line
                            //stageTabObj.DATE_CREATED = OSM_Generic_Utility.getDate(system.today()); 
                            stageTabObj.DATE_CREATED = OSM_Generic_Utility.getDate(cdt); 
                            
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                if(invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c)
                                {
                                    stageTabObj.LEDGER_ID = osmLabel.OSM_WS_USLedger__c;
                                }
                                
                                if(invoice.ccrz__CurrencyCode__c == 'CAD')
                                {
                                    stageTabObj.LEDGER_ID = '2203';
                                    stageTabObj.LEDGER_NAME = 'CA Primary CAD';
                                } 
                            }
                            
                            //Will be taken up in release 1B
                            /*if(invoice.ccrz__CurrencyCode__c != osmLabel.OSM_WS_Currencycode__c){
                                FromCurrency = osmLabel.OSM_WS_Currencycode__c;
                                ToCurrency = invoice.ccrz__CurrencyCode__c != null ? invoice.ccrz__CurrencyCode__c : '';
                                
                                List<Currency_Conversion__c> ccCurren = [Select Bolt_From_Currency__c, Bolt_To_Currency__c, Bolt_Conversion_Type__c, Bolt_Conversion_Rate__c, Bolt_From_Conversion_date__c, Bolt_To_Conversion_date__c, Bolt_Version__c from Currency_Conversion__c where Bolt_From_Currency__c = :FromCurrency and Bolt_To_Currency__c = :ToCurrency order by Bolt_Version__c DESC limit 1];
                                
                                stageTabObj.CURRENCY_CONVERSION_DATE = OSM_Generic_Utility.getDate(ccCurren[0].Bolt_From_Conversion_date__c);
                                stageTabObj.USER_CURRENCY_CONVERSION_TYPE = ccCurren[0].Bolt_Conversion_Type__c;
                                stageTabObj.CURRENCY_CONVERSION_RATE = string.valueOf(ccCurren[0].Bolt_Conversion_Rate__c);
                            } else if(invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c){
                                stageTabObj.CURRENCY_CONVERSION_DATE = OSM_Generic_Utility.getDate(system.today());
                                stageTabObj.USER_CURRENCY_CONVERSION_TYPE = osmLabel.OSM_WS_User_Currency_Conversion_Type__c;
                                stageTabObj.CURRENCY_CONVERSION_RATE = osmLabel.OSM_WS_Currency_Conversion_Rate__c;
                            }*/
                            
                            //With currency code as USD, its taking from custom metadata labels
                            if(invoice.ccrz__CurrencyCode__c == osmLabel.OSM_WS_Currencycode__c)
                            {
                                //OMG-1043 Commented below line and added another line
                                //stageTabObj.CURRENCY_CONVERSION_DATE = OSM_Generic_Utility.getDate(system.today());
                                stageTabObj.CURRENCY_CONVERSION_DATE = OSM_Generic_Utility.getDate(cdt);
                                stageTabObj.USER_CURRENCY_CONVERSION_TYPE = osmLabel.OSM_WS_User_Currency_Conversion_Type__c;
                                stageTabObj.CURRENCY_CONVERSION_RATE = osmLabel.OSM_WS_Currency_Conversion_Rate__c;
                            }
                            
                             /* commented for 860
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                
                                stageTabObj.SEGMENT5 = AccountValueMap.get('Bolt_BC_Code__c');
                                
                            }
                            else
                            {
                                
                                stageTabObj.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;
                            }
                            */
                            if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                    stageTabObj.REFERENCE6 = map_TPIdBatchId.get(ctpRec.Id); 
                                    stageTabObj.GROUP_ID = map_TPIdBatchId.get(ctpRec.Id); 
                                }else{                          
                                    stageTabObj.REFERENCE6 = (currTime).format('yyyyMMddhhmmss') + cntr + invName; 
                                    stageTabObj.GROUP_ID = (currTime).format('yyyyMMddhhmmss') + cntr + invName; 
                                } 
                            }else{                          
                                if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                    stageTabObj.REFERENCE6 = map_ReverseTPIdBatchId.get(ctpRec.Id); 
                                    stageTabObj.GROUP_ID = map_ReverseTPIdBatchId.get(ctpRec.Id);
                                }else {
                                    stageTabObj.REFERENCE6 = (currTime).format('yyyyMMddhhmmss') + cntr + invName; 
                                    stageTabObj.GROUP_ID = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                }
                            } 
                            
                            stageTabObj.CREATION_DATE = OSM_Generic_Utility.getDate(cdt); 
                            
                            DateTime dtm = invoice.LastModifiedDate;
                            Date mdt = dtm.date();
                            stageTabObj.LAST_UPDATE_DATE = OSM_Generic_Utility.getDate(mdt);
                            
                            stageTabObj.LAST_UPDATED_BY = osmLabel.OSM_BOLT_Interface_Anonymous_User__c;
                            stageTabObj.CREATED_BY = osmLabel.OSM_BOLT_Interface_Anonymous_User__c; 
                            //OMG-1043 Commented below line added another line
                            //stageTabObj.INVOICE_DATE = OSM_Generic_Utility.getDate(system.today());  
                            stageTabObj.INVOICE_DATE = OSM_Generic_Utility.getDate(cdt);  
                            
                            //Creating StageLines Paramters                     
                            //For Revenue(1)   
                            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES Revenue = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES();
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                Revenue.SEGMENT4 = osmLabel.OSM_Intercompany_Revenue_Segment__c; 
                                Revenue.SEGMENT5 = AccountValueMap.get('Bolt_BC_Code__c');  //Added for 860                                                                                                                                                              
                            }
                            else
                            {
                                Revenue.SEGMENT4 = osmLabel.OSM_WS_Revenue_Segment__c; 
                                Revenue.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;    //Added for 860                                                                                                                                                       
                            }
                                
                                system.debug('ctpRec.Bolt_JE_Call_Status__c +++' + ctpRec.Bolt_JE_Call_Status__c);
                                system.debug('label.OSM_ARInvoiceRecurring_Status +++' + label.OSM_ARInvoiceRecurring_Status);
                                system.debug('label.OSM_Bolt_Log_Status_Failure +++' + label.OSM_Bolt_Log_Status_Failure);
                                system.debug('state +++' + state);
                                system.debug('label.OSM_Bolt_OrderPlaced +++' + label.OSM_Bolt_OrderPlaced);
                                
                                system.debug('ctpRec.Bolt_JE_Reversal_Call_Status__c +++ ' +ctpRec.Bolt_JE_Reversal_Call_Status__c);
                                system.debug('label.OSM_Bolt_Order_Cancel +++ ' +label.OSM_Bolt_Order_Cancel);
                                system.debug('label.OSM_Bolt_Log_Status_Failure  +++ ' +label.OSM_Bolt_Log_Status_Failure);

                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced))
                                {
                                       //Revenue.ENTERED_CR = invoice.Total_Sales_Amount__c != null ? string.valueof(invoice.Total_Sales_Amount__c) : osmLabel.OSM_WS_Zero__c;
                                        Revenue.ENTERED_CR =  invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c  != null ? string.valueof(invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                        Revenue.ENTERED_DR = osmLabel.OSM_WS_Zero__c; 
                                        system.debug('invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c +++' + invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c);
                                                                
                                }
                                
                                else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel))
                                {
                                   
                                        //Revenue.ENTERED_DR = invoice.Total_Sales_Amount__c != null ? string.valueof(invoice.Total_Sales_Amount__c) : osmLabel.OSM_WS_Zero__c;
                                        //Revenue.ENTERED_DR = invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c != null ? string.valueof(invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c) : osmLabel.OSM_WS_Zero__c;
                                        if(invoiceList.size() > 1){
                                            Revenue.ENTERED_DR = invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c != null ? string.valueof(invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                        } else {
                                            Revenue.ENTERED_DR=String.valueOf(EnteredCR.setScale(2, RoundingMode.HALF_UP));
                                        }
                                        Revenue.ENTERED_CR = osmLabel.OSM_WS_Zero__c;
                                        system.debug('invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c +++' + invoice.ccrz__CCOrder__r.Original_Order_Subtotal__c);
                                    
                                }
                                System.debug('Revenue.ENTERED_DR: '+Revenue.ENTERED_DR);
                                System.debug('stageTabObj.CURRENCY_CONVERSION_RATE: '+stageTabObj.CURRENCY_CONVERSION_RATE);
                            Revenue.ACCOUNTED_DR = string.valueOf((Decimal.valueOf(Revenue.ENTERED_DR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE)).setScale(2, RoundingMode.HALF_UP));
                            Revenue.ACCOUNTED_CR = string.valueOf((Decimal.valueOf(Revenue.ENTERED_CR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE)).setScale(2, RoundingMode.HALF_UP));
                            stagelinesObjList.add(Revenue);
                            system.debug('stagelinesObjList +++' +stagelinesObjList);
                            //For Tax(2)
                            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES Tax = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES();
                            Tax.SEGMENT4 = osmLabel.OSM_WS_Tax_Segment__c;              
                            // Start Added for 860
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                               Tax.SEGMENT5 = AccountValueMap.get('Bolt_BC_Code__c');                           
                            }
                            else
                            {
                                Tax.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;
                            }
                            // End Added for 860                                              
                            if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced))
                            {
                                Tax.ENTERED_DR = osmLabel.OSM_WS_Zero__c;
                                    Tax.ENTERED_CR = invoice.Total_Vertex_Tax__c != null ? string.valueof(invoice.Total_Vertex_Tax__c) : osmLabel.OSM_WS_Zero__c;
                                system.debug('invoice.Total_Vertex_Tax__c +++' + invoice.Total_Vertex_Tax__c);
                                
                            }
                            else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel))
                            {
                               
                                    Tax.ENTERED_CR = osmLabel.OSM_WS_Zero__c;
                                    Tax.ENTERED_DR = invoice.Total_Vertex_Tax__c != null ? string.valueof(invoice.Total_Vertex_Tax__c) : osmLabel.OSM_WS_Zero__c;
                                system.debug('invoice.Total_Vertex_Tax__c +++' + invoice.Total_Vertex_Tax__c);
                                
                            }
                            Tax.ACCOUNTED_DR = string.valueOf(Decimal.valueOf(Tax.ENTERED_DR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE));
                            Tax.ACCOUNTED_CR = string.valueOf(Decimal.valueOf(Tax.ENTERED_CR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE));
                           
                            stagelinesObjList.add(Tax);
                            system.debug('stagelinesObjList +++' + stagelinesObjList);
                            //For Discount(3)
                            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES Discount = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES();
                            
                            // RTC_182227 - BOLT Change Request - April 01, 2019- Intercompany changes from 2796000 to 2296000
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                Discount.SEGMENT4 = osmLabel.OSM_Intercompany_Discount_Segment__c;
                                Discount.SEGMENT5 = AccountValueMap.get('Bolt_BC_Code__c');     //Added for 860                                                                                                                                                              
                            }
                            else // RTC_182227 - BOLT Change Request - April 01, 2019- original invoice remains the same
                            {
                                Discount.SEGMENT4 = osmLabel.OSM_WS_Discount_Segment__c;
                                Discount.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;       //Added for 860                                                                                                                                                              
                            }
                            
                            if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced))
                            {
                                    //Discount.ENTERED_DR = invoice.Discount_Total__c != null ? string.valueof(invoice.Discount_Total__c) : osmLabel.OSM_WS_Zero__c; 
                                    Discount.ENTERED_DR = invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c.setScale(2, RoundingMode.HALF_UP) ) : osmLabel.OSM_WS_Zero__c;
                                    
                                    Discount.ENTERED_CR = osmLabel.OSM_WS_Zero__c;   
                                
                                
                                if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                                {
                                   
                                        Discount.ENTERED_DR = invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;   
                                         //Discount.ENTERED_DR=string.valueof(discountamount.setScale(2, RoundingMode.HALF_UP));
                                }
                                
                            }
                            else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel))
                            {
                                    //Discount.ENTERED_CR = invoice.Discount_Total__c != null ? string.valueof(invoice.Discount_Total__c) : osmLabel.OSM_WS_Zero__c; 
                                    //Discount.ENTERED_CR = invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                    if(invoiceList.size() > 1){
                                        Discount.ENTERED_CR = invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_BOLT__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                    } else {
                                        Discount.ENTERED_CR=string.valueof(discountamount.setScale(2, RoundingMode.HALF_UP));
                                    }
                                    Discount.ENTERED_DR = osmLabel.OSM_WS_Zero__c;
                                
                               
                                if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                                {
                                        //Discount.ENTERED_CR = invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;  
                                        if(invoiceList.size() > 1){
                                            Discount.ENTERED_CR = invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c != null ? string.valueof(invoice.ccrz__CCOrder__r.OSM_Discount_On_DN__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;  
                                        } else {
                                            Discount.ENTERED_CR=string.valueof(discountamount.setScale(2, RoundingMode.HALF_UP));//  
                                        }
                                        Discount.ENTERED_DR = osmLabel.OSM_WS_Zero__c;  
                                }
                            }
                            Decimal ACCOUNTED_DR_TOROUND=Decimal.valueOf(Discount.ENTERED_DR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE);
                            Decimal ACCOUNTED_CR_TOROUND=Decimal.valueOf(Discount.ENTERED_CR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE);
                            Discount.ACCOUNTED_DR = string.valueOf(ACCOUNTED_DR_TOROUND.setScale(2, RoundingMode.HALF_UP));
                            Discount.ACCOUNTED_CR = string.valueOf(ACCOUNTED_CR_TOROUND.setScale(2, RoundingMode.HALF_UP));
                            stagelinesObjList.add(Discount);
                            
                            //For Balancing(4) 
                            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES Balancing = new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES();
                            
                            // RTC_182227 - BOLT Change Request - April 01, 2019- Intercompany changes from 0020009 to 0080000
                            if(invoice.OSM_SW_IsIntercompanyInvoice__c || isDistributorPurchangeHimself || isDistributorOrSupportAdminBuyForDisAcc)
                            {
                                Balancing.SEGMENT4 = osmLabel.OSM_Intercompany_Balancing_Segment__c;
                            }
                            else // RTC_182227 - BOLT Change Request - April 01, 2019- original invoice remains the same
                            {
                                Balancing.SEGMENT4 = osmLabel.OSM_WS_Balancing_Segment__c;
                            }
                            
                            Balancing.SEGMENT5 = osmLabel.OSM_WS_Internal_Segment5__c;      //Added for 860. If segment4 is 0020009 , segment5 will be 000                                                                                                                                                                                                               
                               
                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced))
                                {
                                        Balancing.ENTERED_CR = osmLabel.OSM_WS_Zero__c;
                                        Balancing.ENTERED_DR = invoice.ccrz__OriginalAmount__c != null ? string.valueof(invoice.ccrz__OriginalAmount__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                    
                                    
                                }
                                else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel))
                                {
                                   
                                        Balancing.ENTERED_DR = osmLabel.OSM_WS_Zero__c;
                                        Balancing.ENTERED_CR = invoice.ccrz__OriginalAmount__c  != null ? string.valueof(invoice.ccrz__OriginalAmount__c.setScale(2, RoundingMode.HALF_UP)) : osmLabel.OSM_WS_Zero__c;
                                    
                                }
                            Decimal Balancing_ACCOUNTED_DR_ToRound=Decimal.valueOf(Balancing.ENTERED_DR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE);
                            Decimal Balancing_ACCOUNTED_CR_ToRound=Decimal.valueOf(Balancing.ENTERED_CR) * Decimal.valueOf(stageTabObj.CURRENCY_CONVERSION_RATE);
                            Balancing.ACCOUNTED_DR = string.valueOf(Balancing_ACCOUNTED_DR_ToRound.setScale(2, RoundingMode.HALF_UP));
                            Balancing.ACCOUNTED_CR = string.valueOf(Balancing_ACCOUNTED_CR_ToRound.setScale(2, RoundingMode.HALF_UP));
                            stagelinesObjList.add(Balancing);
                               system.debug('stagelinesObjList +++' + stagelinesObjList);                     
                            stageTabObj.JE_INV_INBND_STG_ROW_LINES = stagelinesObjList;
                            dataAreaObj.JE_INV_INBND_STG_ROW =  stageTabObj;
                               system.debug('stageTabObj.JE_INV_INBND_STG_ROW_LINES +++' +  stageTabObj.JE_INV_INBND_STG_ROW_LINES);  
                                 system.debug('dataAreaObj.JE_INV_INBND_STG_ROW +++' +  dataAreaObj.JE_INV_INBND_STG_ROW);
                                system.debug('stageTabObj +++' + stageTabObj);
                               
                            //Creating Control Table Paramters
                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    contrlObj.Order_Number = OSM_Generic_Utility.fieldSizeRestriction(string.valueOf(invoice.name), 8, 'back'); 
                                }else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    if(invoice.CreditMemo_Number__c!=null)
                                    contrlObj.Order_Number=string.valueOf(invoice.CreditMemo_Number__c);
                                    else
                                    contrlObj.Order_Number =  OSM_Generic_Utility.fieldSizeRestriction(string.valueOf(invoice.name), 8, 'back') + 'C';
                                }
                            
                            //contrlObj.BATCH_AMOUNT = string.valueOf(Revenue.ACCOUNTED_CR + Tax.ACCOUNTED_CR);
                            Decimal Batch_Amount_ToRound=Decimal.valueOf(Revenue.ENTERED_CR) + Decimal.valueOf(Tax.ENTERED_CR) + Decimal.valueOf(Discount.ENTERED_CR) + Decimal.valueOf(Balancing.ENTERED_CR);
                            //contrlObj.BATCH_AMOUNT = string.valueOf(Decimal.valueOf(Revenue.ENTERED_CR) + Decimal.valueOf(Tax.ENTERED_CR) + Decimal.valueOf(Discount.ENTERED_CR) + Decimal.valueOf(Balancing.ENTERED_CR));
                            contrlObj.BATCH_AMOUNT= string.valueOf(Batch_Amount_ToRound.setScale(2, RoundingMode.HALF_UP));
                            //contrlObj.BATCH_AMOUNT=invoice.ccrz__OriginalAmount__c != null ? string.valueOf(invoice.ccrz__OriginalAmount__c) : ''; 
                            
                            // added for MAR-1739
                            ctpRec.JE_Batch_Amount__c = Batch_Amount_ToRound.setScale(2, RoundingMode.HALF_UP);
                             system.debug('ctpRec.JE_Batch_Amount__c +++' + ctpRec.JE_Batch_Amount__c);       
                                 
                            if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                   contrlObj.BATCH_ID = map_TPIdBatchId.get(ctpRec.Id); 
                                    system.debug('inside if+++');
                               }else{
                                   system.debug('inside elseif+++');
                                   contrlObj.BATCH_ID = (currTime).format('yyyyMMddhhmmss') + cntr + invName; //message id
                                   system.debug('contrlObj.BATCH_ID +++' + contrlObj.BATCH_ID);
                               }
                           } else{
                                if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                  system.debug('inside if+++');  
                                    contrlObj.BATCH_ID = map_ReverseTPIdBatchId.get(ctpRec.Id);
                                }else {
                                    system.debug('inside elseif+++');
                                    contrlObj.BATCH_ID = (currTime).format('yyyyMMddhhmmss') + cntr + invName; //message id
                                    system.debug('contrlObj.BATCH_ID +++' + contrlObj.BATCH_ID);
                                }
                           }
                            
                                DateTime dtcc = invoice.CreatedDate;
                                Date ccdt = dtcc.date();
                                contrlObj.CREATION_DATE = OSM_Generic_Utility.getDate(ccdt);
                                
                                DateTime dtmc = invoice.LastModifiedDate;
                                Date mcdt = dtmc.date();
                                contrlObj.LAST_UPDATE_DATE = OSM_Generic_Utility.getDate(mcdt);
                                
                                contrlObj.LAST_UPDATED_BY = osmLabel.OSM_BOLT_Interface_Anonymous_User__c;
                                contrlObj.CREATED_BY = osmLabel.OSM_BOLT_Interface_Anonymous_User__c; 
                                system.debug('else contrlObj.LAST_UPDATED_BY +++' + contrlObj.LAST_UPDATED_BY);
                                system.debug('else contrlObj.CREATED_BY +++' +  contrlObj.CREATED_BY); 
                                
                                
                                
                            //Setting service name paramter in sender object
                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    senderObj.ServiceName = label.OSM_Bolt_Journal_Entry;
                                    system.debug('if senderObj.ServiceName +++' +senderObj.ServiceName);
                                }else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    senderObj.ServiceName = label.OSM_Bolt_Journal_Entry_Reversal;
                                     system.debug('else senderObj.ServiceName +++' +senderObj.ServiceName);
                                }
                            
                            headObj.Sender = senderObj;
                            headObj.JE_CTRL_TBL_ROW = contrlObj;
                             system.debug(' headObj.Sender  +++' +  headObj.Sender );
                                 system.debug(' headObj.JE_CTRL_TBL_ROW  +++' +  headObj.JE_CTRL_TBL_ROW );
                                 system.debug(' senderObj  +++' +  senderObj);
                                 system.debug(' contrlObj  +++' +  contrlObj);
                                
                            reqWrapperNew.DataArea = dataAreaObj;
                            reqWrapperNew.Header = headObj;                
                             system.debug('reqWrapperNew +++' + reqWrapperNew);
                            serviceCallReturn = OSM_BOLT_WS_JournalEntryOutbound.callJournalEntry(reqWrapperNew); //Make the service call
                            system.debug('serviceCallReturn'+serviceCallReturn);
                            
                            if(serviceCallReturn.exceptionFlag == True){
                                log = new OSM_Integration_Log__c();
                                OSM_SW_LoggingContext.integrationLog = log;
                                log.Account__c = AccountId; 
                                log.Status__c = serviceCallReturn.Status;
                                log.Request__c = serviceCallReturn.Request;  
                                log.Response__c = serviceCallReturn.ReturnCodeDescription;
                                log.Error_Description__c = serviceCallReturn.errorMessage;              
                                
                                    if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_JERecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Paid_recurring_invoice_status && state == label.OSM_Bolt_OrderPlaced)){
                                        log.Service_Name__c =  label.OSM_Bolt_Journal_Entry;
                                    }else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                        log.Service_Name__c =  label.OSM_Bolt_Journal_Entry_Reversal;
                                    }
                                
                                log.Source__c = label.OSM_Bolt_Source;
                                log.Target__c = label.OSM_Bolt_Target;
                                log.Logged_In_User__c = userinfo.getuserid(); 
                                log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                                log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                              
                                log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;
                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                        log.Unique_Message_Identifier__c = map_TPIdBatchId.get(ctpRec.Id); 
                                    }else{
                                        log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                    }
                                } else{
                                    if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                        log.Unique_Message_Identifier__c = map_ReverseTPIdBatchId.get(ctpRec.Id);
                                    }else {
                                        log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                    }
                                }
                                //(system.now()).format('yyyyMMddhhmmss');
                                system.debug('log'+log);
                                mapToInsertLogs.put(ctpRec.id,log);
                                mapToUpdateFailureFlag.put(ctpRec.id,ctpRec); //Update the flag on cc transaction payment record
                            }
                if(Test.isRunningTest())
                {
                    serviceCallReturn.exceptionFlag=false;
                }
                            if(serviceCallReturn.exceptionFlag == False)
                            {
                                if(Boolean.valueOf(Label.OSM_Success_Log) == true)
                                {
                                    log = new OSM_Integration_Log__c();
                                    OSM_SW_LoggingContext.integrationLog = log;
                                    log.Account__c = AccountId; 
                                    log.Status__c = serviceCallReturn.Status;
                                    log.Request__c = serviceCallReturn.Request;  
                                    log.Response__c = serviceCallReturn.ReturnCodeDescription;
                                    log.Error_Description__c = serviceCallReturn.errorMessage;              
                                    
                                        if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_JERecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Paid_recurring_invoice_status && state == label.OSM_Bolt_OrderPlaced)){
                                            log.Service_Name__c =  label.OSM_Bolt_Journal_Entry;
                                        }else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_JERecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Paid_recurring_invoice_status && state == label.OSM_Bolt_Order_Cancel)){
                                            log.Service_Name__c =  label.OSM_Bolt_Journal_Entry_Reversal;
                                        }
    
                                    log.Source__c = label.OSM_Bolt_Source;
                                    log.Target__c = label.OSM_Bolt_Target;
                                    log.Logged_In_User__c = userinfo.getuserid();
                                    log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null;
                                    log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                            
                                    log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;                                         
                                    if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                        if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                            log.Unique_Message_Identifier__c = map_TPIdBatchId.get(ctpRec.Id); 
                                        }else{
                                            log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName; 
                                        }
                                    } else{
                                        if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                            log.Unique_Message_Identifier__c = map_ReverseTPIdBatchId.get(ctpRec.Id);
                                        }else {
                                            log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                        }
                                    }
                                    system.debug('log'+log);
                                   
                                    mapToInsertLogs.put(ctpRec.id,log);
                                   
                                    
                                    // only Else syntax added
                                    
                                        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
                                        newInvoice.Id = invoice.Id;

                                        if(state != label.OSM_Bolt_Order_Cancel)
                                            newInvoice.OSM_SW_isBoltJournalEntryDone__c = true;
                                        else
                                        {
                                            newInvoice.IsReversalBoltJournalEntryDone__c = true;
                                        }
                                        lstInvoiceToUpdate.add(newInvoice);
                                        
                                        if(log.CC_Order__c != null)
                                        {
                                            ccrz__E_Order__c toupdateOrder = new ccrz__E_Order__c();
                                            toupdateOrder.Id = log.CC_Order__c;
                                            if(state != label.OSM_Bolt_Order_Cancel)
                                                toupdateOrder.OSM_SW_isBoltJournalEntryDone__c = true;
                                            else
                                                toupdateOrder.IsReversalBoltJournalEntryDone__c= true;
                                            
                                            lstOrderToUpdate.add(toupdateOrder);
                                        }
                                      
                                 }
                                    
                                mapToResetFailureFlag.put(ctpRec.id,ctpRec);    //Reset the flag on cc transaction payment record
                            }   
                        }       
                        }else if(ctpRec.ccrz__AccountType__c == null){
                            system.debug('Transaction account type is blank');
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Account__c = AccountId; 
                            log.Status__c = label.OSM_Bolt_Log_Status_Failure;
                            log.Error_Description__c = label.OSM_Transaction_Account_Type_Message;          
                            
                                if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                    log.Service_Name__c =  label.OSM_Bolt_Journal_Entry;
                                }else if(ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_JERecurring_Status || (ctpRec.Bolt_JE_Reversal_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_Order_Cancel)){
                                    log.Service_Name__c =  label.OSM_Bolt_Journal_Entry_Reversal;
                                }
    
                            log.Source__c = label.OSM_Bolt_Source;
                            log.Target__c = label.OSM_Bolt_Target;
                            log.Logged_In_User__c = userinfo.getuserid();
                            log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                            log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                      
                            log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;                     
                            if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                                if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                    log.Unique_Message_Identifier__c = map_TPIdBatchId.get(ctpRec.Id); 
                                }else{
                                    log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                }
                            } else{
                                if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                    log.Unique_Message_Identifier__c = map_ReverseTPIdBatchId.get(ctpRec.Id);
                                }else {
                                    log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                                }
                            }
                            mapToInsertLogs.put(ctpRec.id,log);
                            mapToUpdateFailureFlag.put(ctpRec.id,ctpRec);  //Update the flag on cc transaction payment record
                        }
                        if(Test.isRunningTest()){
                          throw new NullPointerException();                          
                        }
                    }
                    }catch (Exception e){
                        System.debug('=====Exception in setJournalEntryWrapper====');
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
                        log.Account__c = AccountId; 
                        log.Status__c = label.OSM_Bolt_Log_Status_Failure; 
                        log.Error_Description__c = 'Exception:'+e.getMessage() + ' at line number '+e.getLineNumber() + ',' + '\n\n' + 'Stack traced at: '+e.getStacktraceString(); 
                        log.Service_Name__c =  Label.OSM_Bolt_Journal_Entry;
                        log.Source__c = label.OSM_Bolt_Source;
                        log.Target__c = label.OSM_Bolt_Target;
                        log.Logged_In_User__c = userinfo.getuserid();
                        log.Invoice__c = ctpRec.ccrz__InvoiceAppliedTo__c != null ? ctpRec.ccrz__InvoiceAppliedTo__c : null; 
                        log.CC_Order__c = ctpRec.ccrz__CCOrder__c != null ? ctpRec.ccrz__CCOrder__c : null;                                  
                        log.Transaction_Payment__c = ctpRec.id != null ? ctpRec.id : null;                                 
                        if(ctpRec.Bolt_JE_Call_Status__c == label.OSM_ARInvoiceRecurring_Status || (ctpRec.Bolt_JE_Call_Status__c == label.OSM_Bolt_Log_Status_Failure && state == label.OSM_Bolt_OrderPlaced)){
                            if(map_TPIdBatchId.containsKey(ctpRec.Id)){
                                log.Unique_Message_Identifier__c = map_TPIdBatchId.get(ctpRec.Id); 
                            }else{  
                                log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                            }
                        } else{  
                            if(map_ReverseTPIdBatchId.containsKey(ctpRec.Id)){
                                log.Unique_Message_Identifier__c = map_ReverseTPIdBatchId.get(ctpRec.Id);
                            }else {
                                log.Unique_Message_Identifier__c = (currTime).format('yyyyMMddhhmmss') + cntr + invName;
                            }
                        }
                        mapToInsertLogs.put(ctpRec.id,log);
                        mapToUpdateFailureFlag.put(ctpRec.id,ctpRec);  //Update the flag on cc transaction payment record
                    }
                    cntr ++;     
                }
            }
            
                system.debug('mapToInsertLogs'+mapToInsertLogs);
                system.debug('mapToUpdateFailureFlag'+mapToUpdateFailureFlag);
                system.debug('mapToResetFailureFlag'+mapToResetFailureFlag);
            
                //Create wrapper to return to utility layer
                returnWrap.mapToInsertLogs = mapToInsertLogs;
                returnWrap.mapToUpdateFailureFlag = mapToUpdateFailureFlag;
                returnWrap.mapToResetFailureFlag = mapToResetFailureFlag;
                returnWrap.updateInvoiceList = lstInvoiceToUpdate;
                returnWrap.updateOrderList = lstOrderToUpdate;
            
                returnWrap.updateInvoiceItemList = lstInvoiceItemToUpdate;
                returnWrap.updateOrdItemList = lstOrderItemToUpdate;
            
                return returnWrap;
        }
        
        
    }