/************************************************************
    Name:  OSM_SW_IntercompanyInvoiceOfRecurring
    Copyright © 2018  Cummins
    =============================================================
    =============================================================
    Purpose:                                                            
    This class is developed to create intercompany of Recurring invoice
    =============================================================
    =============================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR                DATE              DETAIL                                
    1.0 -    Sangeeta Rani         25/05/2020     INITIAL DEVELOPMENT          

    *************************************************************/
    
 public class OSM_SW_IntercompanyInvoiceOfRecurring
 {
 
 //This method used to create intercompany invoice and order record
 public static void createIntercompnayOrderAndInvoice(Set < Id > invoiceId)
 {
     system.debug('order id set>>>>>>'+invoiceId);
     Set<Id> orderIds=new Set<Id>();
    List<ccrz__E_Order__c> clonedOrdersList=new List<ccrz__E_Order__c>();
    List<ccrz__E_OrderItem__c> clonedOrdersItemList=new List<ccrz__E_OrderItem__c>();
    Map<Id,ccrz__E_Order__c> orderIdMap=new Map<Id,ccrz__E_Order__c>();
    Set<Id> orderItemIdsSet=new Set<Id>();
    List<ccrz__E_Invoice__c> clonedInvoiceList=new List<ccrz__E_Invoice__c>();
    Set<Id> invoiceIdSet=new Set<Id>();
    Map<Id,ccrz__E_Invoice__c> invoiceIdMap=new Map<Id,ccrz__E_Invoice__c>();
    List<ccrz__E_InvoiceItem__c> clonedInvoiceItemList=new List<ccrz__E_InvoiceItem__c>();
    Map<id,ccrz__E_OrderItem__c> orderItemIdMap=new Map<id,ccrz__E_OrderItem__c>();
    Map<id,ccrz__E_InvoiceItem__c> invoiceItemIdMap=new Map<id,ccrz__E_InvoiceItem__c>();
    Map<Id,OSM_Integration_Log__c> logVsOrderIdMap=new Map<Id,OSM_Integration_Log__c>();
    List<OSM_Integration_Log__c> logList=new List<OSM_Integration_Log__c>();
    List<OSM_Orders_In_Invoice__c> clonedJunctionList=new List<OSM_Orders_In_Invoice__c>();
    set<id> junctionParentRecordSet=new set<id>();
    List<OSM_InvoiceLine_And_OrderLine__c> clonedJunChildList=new List<OSM_InvoiceLine_And_OrderLine__c>();
    set<id> orderItemIdSet=new set<id>();
    Map<id,OSM_Orders_In_Invoice__c> clonedJunctionRecordsMap=new Map<id,OSM_Orders_In_Invoice__c>();
    List<ccrz__E_OrderItem__c> orderItemsList=new List<ccrz__E_OrderItem__c>();
    List<ccrz__E_InvoiceItem__c> invoiceItemList=new List<ccrz__E_InvoiceItem__c>();
    List<OSM_InvoiceLine_And_OrderLine__c> OrderInvoiceChildJunList=new List<OSM_InvoiceLine_And_OrderLine__c>();
    List<ccrz__E_Order__c> newClonedOrderRecordsList=new List<ccrz__E_Order__c>();
    List<ccrz__E_OrderItem__c> clonedOrderItems=new List<ccrz__E_OrderItem__c>();
    List<ccrz__E_Invoice__c> clonedInviceRecordsList=new List<ccrz__E_Invoice__c>();
    List<ccrz__E_InvoiceItem__c> clonedInvoiceItems=new List<ccrz__E_InvoiceItem__c>();
    List<OSM_Orders_In_Invoice__c> clonedJunctionRecordsList=new List<OSM_Orders_In_Invoice__c>();
    Set<Id> idSet=new Set<Id>();
    Map<Id,Id> accountVsParentAccountMap=new Map<Id,Id>();
    Map<Id,ccrz__E_CartItem__c> subprodTermVsCartItemMap=new Map<Id,ccrz__E_CartItem__c>();
    Set<Id> orderIdSet=new Set<Id>();
    Map<Id,String> orderIdVsSubTermMap=new Map<Id,String>();
    Set<Id> osmOrderSubscriptionIdSet=new Set<Id>();
    Map<String,Decimal> billingFrqVSValue=new Map<String,Decimal>();
    List<ccrz__E_Invoice__c> updatedInvoices=new List<ccrz__E_Invoice__c>();
    set<Id> parentIdsSet=new Set<Id>();
    Map<Id,Id> accountVSPrimaryContactMap=new Map<Id,Id>();
    List<ccrz__E_OrderItem__c> clonedOrderItemsList=new List<ccrz__E_OrderItem__c>(); 
    String AccountId; //Added By Dhiraj
     
    //Querying Invoice and invoice items object data...
    String queryInvoice='SELECT OwnerId,ccrz__BillAddress__c,ccrz__BillTo__r.BillingCountry,ccrz__BillTo__r.CSS_DistributorCode__c,Is_GOMS_Intercompany_Invoice__c,Total_Sales_Amount__c,ccrz__BillTo__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__Contact__c,ccrz__CurrencyCode__c,ccrz__DateDue__c,ccrz__DateIssued__c,ccrz__InvoiceId__c,ccrz__OriginalAmount__c,ccrz__ParentInvoice__c,ccrz__RemainingAmount__c,ccrz__SoldAddress__c,ccrz__SoldTo__c,ccrz__Status__c,ccrz__Storefront__c,ccrz__Terms__c,ccrz__Type__c,ccrz__User__c,Discount_Total__c,Payment_Method__c,Recurring_Invoice__c,BMS_DistributorAddressline__c,BMS_DistributorCity__c,BMS_DistributorName__c,BMS_DistributorState__c,BMS_Distributorpostalcode__c,OSM_SW_IsIntercompanyInvoice__c,BMS_InvoiceNumber__c,BMS_InvoiceTotal__c,BMS_PONumber__c,BMS_paymenttype__c,BMS_CreateDate__c,OSM_SW_IsBoltARInvoiceDone__c,BMS_InvoiceDate__c,OSM_SW_isBoltJournalEntryDone__c,OSM_SW_Is_Bolt_PO__c,ICInvoice_Number__c,Original_Sales_Order_Invoice_Number__c,IntercompanyCalled__c,ICInvoice_Date__c,(SELECT ccrz__Invoice__c,ccrz__Invoice__r.ccrz__OriginalAmount__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__InvoiceItemId__c,ccrz__OriginalAmount__c,ccrz__Sequence__c,ccrz__Status__c,ccrz__Type__c FROM ccrz__InvoiceItems__r where ccrz__Type__c=\'Item\') FROM ccrz__E_Invoice__c WHERE id IN: invoiceId';
    System.debug('query String for invoice>>>>'+queryInvoice);
    List<ccrz__E_Invoice__c> invoiceList=Database.query(queryInvoice);
    System.debug('result of invoice query>>>>'+invoiceList);
    //Added By Dhiraj
     for(ccrz__E_Invoice__c invoiceRec  :invoiceList) 
     {
         AccountId = invoiceRec.ccrz__BillTo__c;
     }
     //Code Ended Dhiraj
    //Quering OSM Order Invoice and order invoice line Junction object Data...
    string junctionQuery='SELECT CC_Invoice__c,CC_Order__c,OSM_SW_Is_Refund_Request__c,Vertex_Call_Status__c,Vertex_Tax__c,Vertex_Refund_Call_Status__c,(SELECT CC_Invoice_Item__c,CC_Order_Item__c,OSM_Orders_In_Invoice__c,Sales_Amount__c,Vertex_Tax__c FROM OSM_InvoiceLine_And_OrderLines__r) FROM OSM_Orders_In_Invoice__c where  CC_Invoice__c IN: invoiceId';
    System.debug('query String for junction object>>>>'+junctionQuery);
    List<OSM_Orders_In_Invoice__c> OrderInvoiceJunList=Database.query(junctionQuery);
    System.debug('result of junction object query>>>>'+OrderInvoiceJunList);
    
    Map<Id,Id> orderLineItemMap=new Map<Id,Id>();
    Map<Id,ccrz__E_OrderItem__c> orderItemIdRecordMap=new Map<Id,ccrz__E_OrderItem__c>();
    For(OSM_Orders_In_Invoice__c osmOrderIn:OrderInvoiceJunList)
    {
        orderIds.add(osmOrderIn.CC_Order__c);
        for(OSM_InvoiceLine_And_OrderLine__c osmOrderLine:osmOrderIn.OSM_InvoiceLine_And_OrderLines__r){
            orderLineItemMap.put(osmOrderLine.CC_Invoice_Item__c,osmOrderLine.CC_Order_Item__c);
        }
    }
    
    //Quering the Order and Order Items
    String queryOrder='SELECT OSM_Discount_On_BMS__c,Purchased_By_User_Type__c,OSM_Discount_On_BOLT__c,OSM_Discount_On_DN__c,OwnerId,ccrz__Account__c, ccrz__Account__r.IAM_Service_Provider_Code__c, ccrz__Account__r.CSS_DistributorCode__c ,ccrz__Account__r.Parentid,ccrz__AdjustmentAmount__c,ccrz__AdjustmentReason__c,ccrz__BillTo__c,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__CCEmailAddress__c,ccrz__CCSubscription__c,ccrz__Contact__c,ccrz__ContractId__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,ccrz__ExtCarrier__c,ccrz__ExtShipTo__c,ccrz__ExtShipTrackNo__c,ccrz__IsAnonymous__c,ccrz__Name__c,ccrz__Note__c,ccrz__OrderDate__c,ccrz__OrderId__c,ccrz__OrderSeller__c,ccrz__OrderStatus__c,ccrz__Order__c,ccrz__OriginatedCart__c,ccrz__PONumber__c,ccrz__PaymentMethod__c,ccrz__RequestDate__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,ccrz__ShipMethod__c,ccrz__ShipStructure__c,ccrz__ShipTo__c,ccrz__SkipTax__c,ccrz__SplitParentOrder__c,ccrz__SplitProcessed__c,ccrz__Storefront__c,ccrz__TaxExemptFlag__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c,ccrz__User__c,ccrz__VerifyExemptionFlag__c,Refund_status__c,BMS_BranchLocation__c,BMS_OrderRefNumber__c,Discount_Type__c,OE_Comment__c,Order_Source_Type__c,OrderProcessedforFSD__c,OSM_SW_Is_Bolt_PO__c,Original_Sales_Order__c,(SELECT ccrz__Product__r.Group_Name__c,OSM_SW_Product_Link__c,ccrz__Order__c,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,ccrz__Category__c,ccrz__Comments__c,ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription__c,ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__Next_Subscription_Date__c,ccrz__OrderItemGroup__c,ccrz__OrderItemId__c,ccrz__OrderItemStatus__c,ccrz__OrderLineType__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__ParentOrderItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__SplitSource__c,ccrz__StoreId__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Auto_Renewal__c,ccrz__Subscription_Duration__c,ccrz__Subscription_End_Date__c,ccrz__Subscription_Frequency__c,ccrz__Subscription_Start_Date__c,ccrz__Subscription_Status__c,ccrz__TertiaryAttr__c,ccrz__UnitOfMeasure__c,Original_Sales_Order_Item__c,Number_of_Bundles__c,Number_of_Counts__c,Dn_Price__c,OSM_SW_Coupon_Applied__c,Original_Dn_Price__c FROM ccrz__E_OrderItems__r) FROM ccrz__E_Order__c WHERE id IN: orderIds';
    System.debug('query String for order>>>>'+queryOrder);
    List<ccrz__E_Order__c> orderList=Database.query(queryOrder);
    System.debug('result of order query>>>>'+orderList);
    
    Set<String> distributorCodeList = new Set<String>();
     System.debug('orderList '+orderList);
     for(ccrz__E_Order__c order:orderList)
     {
         System.debug('ggsOrder '+order.ccrz__Account__r.CSS_DistributorCode__c);
         distributorCodeList.add(order.ccrz__Account__r.CSS_DistributorCode__c);
     }
     System.debug('distributorCodeList '+distributorCodeList);
     Map<string,Account> customerCodeToAccountRecord=new Map<String,Account>();
     List<Account> allAccountsList = [Select ID,IAM_Service_Provider_Code__c, CSS_DistributorCode__c, Name,BillingCity,BillingState,BillingCountry,BillingPostalCode,BillingStateCode,BillingCountryCode,BillingStreet from Account where IAM_Service_Provider_Code__c IN :distributorCodeList];  
     Map<String, ID> customerCodeToAccountMap = new Map<String, ID>();
     System.debug('allAccountsList '+ allAccountsList);
     for(Account acc : allAccountsList)
     {
         if(null != acc.IAM_Service_Provider_Code__c)
         {
             customerCodeToAccountMap.put(acc.IAM_Service_Provider_Code__c, acc.ID);
             customerCodeToAccountRecord.put(acc.IAM_Service_Provider_Code__c,acc);
         }
     }
     
    
     Map<ID, ID> distributorAccountToBoltAddressMap = new Map<ID, ID>();
     Set<ID> contactAdddressIDSet = new Set<ID>();
     Map<ID, ccrz__E_ContactAddr__c> contactAddressMap = new Map<ID, ccrz__E_ContactAddr__c>();
     
     for(ccrz__E_AccountAddressBook__c addressBook : [Select ID, ccrz__E_ContactAddress__r.ID, ccrz__Account__r.ID  From ccrz__E_AccountAddressBook__c where ccrz__E_ContactAddress__r.Bolt_Active__c=true AND ccrz__E_ContactAddress__r.Bolt_Site__c=true AND ccrz__E_ContactAddress__r.Site_Use_Status__c=true AND ccrz__Account__r.IAM_Service_Provider_Code__c IN :distributorCodeList])
     {
         distributorAccountToBoltAddressMap.put(addressBook.ccrz__Account__r.ID, addressBook.ccrz__E_ContactAddress__r.ID);
         contactAdddressIDSet.add(addressBook.ccrz__E_ContactAddress__r.ID);
     }
     
     for(ccrz__E_ContactAddr__c contactAddress : [Select Id, Name, ccrz__AddressFirstline__c, ccrz__AddressSecondline__c, ccrz__AddressThirdline__c, ccrz__AddrReadOnly__c, ccrz__City__c, ccrz__CompanyName__c, ccrz__Country__c, ccrz__CountryISOCode__c, ccrz__DaytimePhone__c, ccrz__Email__c, ccrz__FirstName__c, ccrz__HomePhone__c, ccrz__LastName__c, ccrz__MailStop__c, ccrz__MiddleName__c, ccrz__Partner_Id__c, ccrz__PostalCode__c, ccrz__ShippingComments__c, ccrz__State__c, ccrz__StateISOCode__c FROM ccrz__E_ContactAddr__c where ID in :contactAdddressIDSet])
     {
         contactAddressMap.put(contactAddress.ID, contactAddress);
     } 
     
     for(ccrz__E_Order__c order:orderList)
     {
         System.debug('customerCodeToAccountMap ' +customerCodeToAccountMap);
         ID accID = customerCodeToAccountMap.get(order.ccrz__Account__r.CSS_DistributorCode__c);
         System.debug('accID'+accID);
             
         accountVsParentAccountMap.put(order.ccrz__Account__c,accID);
         //accountVsParentAccountMap.put(order.ccrz__Account__c,order.ccrz__Account__r.Parentid);
        // cartIdSet.add(order.ccrz__OriginatedCart__c);
         orderIdSet.add(order.id);
         parentIdsSet.add(accID);
         //parentIdsSet.add(order.ccrz__Account__r.Parentid);
     }
     
    //Quering the primary contact record for Parent Account 
    List<Contact> primaryContactList=[SELECT CMI_Contact_Type__c,id,name,AccountId FROM Contact where CMI_Contact_Type__c='Primary' and AccountId IN:parentIdsSet limit 1];
    if(primaryContactList!=null && primaryContactList.size()>0)
    {
        for(Contact c:primaryContactList)
        {
            accountVSPrimaryContactMap.put(c.AccountId,c.Id);
        }
        system.debug('primary contact map>>>>'+accountVSPrimaryContactMap);
    }
    
    Savepoint sp = Database.setSavepoint();
    try{
        
        if(orderList!=null)
        {
            for(ccrz__E_Order__c order:orderList)
            {
                //orderItemsList.add(order.ccrz__E_OrderItems__r);
                ccrz__E_Order__c clonedOrder=order.clone(false,true);
                clonedOrder.Original_Sales_Order__c=order.id;
                clonedOrder.OSM_SW_Is_InterCompany_Order__c=true;
                clonedOrder.ccrz__TaxAmount__c=0.00;
                if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(clonedOrder.ccrz__Account__c) )
                {
                     clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(clonedOrder.ccrz__Account__c);
                }
                
                System.debug('cloned Order>>>'+clonedOrder);
                clonedOrdersList.add(clonedOrder);
                //log.CC_Order__c=order.id;
                order.IsInterCompanyProcessSuccess__c=true;
                OSM_Integration_Log__c log=new OSM_Integration_Log__c();
                log.Service_Name__c=Label.OSM_Intercompany;
                log.Status__c='Success';
                log.Logged_In_User__c = userinfo.getuserid();
                log.CC_Order__c=order.id;
                log.Account__c = AccountId; //Added by Dhiraj
                logVsOrderIdMap.put(order.id,log);
                if(order.ccrz__E_OrderItems__r!=null)
                {
                    for(ccrz__E_OrderItem__c orderItemListRecord:order.ccrz__E_OrderItems__r)
                    {
                        orderItemsList.add(orderItemListRecord);
                        orderItemIdRecordMap.put(orderItemListRecord.id,orderItemListRecord);
                    }
                }
            }
        }
        //Insert Cloned  order records
        if(clonedOrdersList!=null && clonedOrdersList.size()>0)
        {
         Database.SaveResult[] resultOrder=Database.Insert(clonedOrdersList);
         System.debug('result of cloned order insert>>>'+ resultOrder);
        } 
        
        //fetching cloned order records ...
         
          newClonedOrderRecordsList=[select id,Original_Sales_Order__c from ccrz__E_Order__c where Original_Sales_Order__c IN :orderList];
        if(newClonedOrderRecordsList!=null) 
        {
            for(ccrz__E_Order__c orderRecord:newClonedOrderRecordsList)
            {
                orderIdMap.put(orderRecord.Original_Sales_Order__c,orderRecord); 
            }
        }
        
        if(invoiceList!=null)
        {
            for(ccrz__E_Invoice__c invoiceRecord :invoiceList)
            {
                if(logVsOrderIdMap!=null && logVsOrderIdMap.containsKey(invoiceRecord.ccrz__CCOrder__c))
                {
                    OSM_Integration_Log__c log=logVsOrderIdMap.get(invoiceRecord.ccrz__CCOrder__c);
                    log.Invoice__c=invoiceRecord.id;
                    log.Account__c = AccountId; //Added by Dhiraj
                    logVsOrderIdMap.put(invoiceRecord.ccrz__CCOrder__c,log);
                }  
                //sharad to update invoice IC date
                invoiceRecord.ICInvoice_Date__c = System.Today();
                invoiceRecord.OSM_Child_Account__c=invoiceRecord.ccrz__BillTo__c;
                invoiceRecord.Recurring_Intercompany_Generated__c=true;
                //sharad code end
                ccrz__E_Invoice__c clonedInvoice=invoiceRecord.clone(false,true);
                if(orderIdMap!=null && orderIdMap.containsKey(invoiceRecord.ccrz__CCOrder__c))
                clonedInvoice.ccrz__CCOrder__c=orderIdMap.get(invoiceRecord.ccrz__CCOrder__c).id;
                clonedInvoice.Original_Sales_Order_Invoice_Number__c=invoiceRecord.id;
                clonedInvoice.IsRecurringIntercompanyInvoice__c=true;
                clonedInvoice.ICInvoice_Date__c = System.Today();
                //clonedInvoice.Original_Sales_Order__c=invoiceRecord.ccrz__CCOrder__c;
                if(!Label.OSM_North_America_Country.contains(invoiceRecord.ccrz__BillTo__r.BillingCountry) && !label.OSM_PO_Distributor_List.contains(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c))
                {
                    clonedInvoice.Is_GOMS_Intercompany_Invoice__c=true;
                    clonedInvoice.OSM_SW_IsIntercompanyInvoice__c=true;
                }
                //system.debug('account>>>'+invoiceRecord.ccrz__BillTo__c);
                //system.debug('parent account>>>'+accountVsParentAccountMap.get(invoiceRecord.ccrz__BillTo__c));
                //clonedInvoice.ccrz__OriginalAmount__c=clonedInvoice.Total_Sales_Amount__c;
                System.debug('accountVsParentAccountMap0 '+ accountVsParentAccountMap);
                if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(invoiceRecord.ccrz__BillTo__c) && accountVsParentAccountMap.get(invoiceRecord.ccrz__BillTo__c)!=null)
                {
                    System.debug('accountVsParentAccountMap1 '+ accountVsParentAccountMap);
                 clonedInvoice.ccrz__BillTo__c=accountVsParentAccountMap.get(invoiceRecord.ccrz__BillTo__c);
                 if(accountVSPrimaryContactMap!=null && accountVSPrimaryContactMap.containsKey(clonedInvoice.ccrz__BillTo__c))
                 {
                        clonedInvoice.ccrz__Contact__c=accountVSPrimaryContactMap.get(clonedInvoice.ccrz__BillTo__c);
                 }
                 
                }
                else
                {
                    throw new OSM_SW_IntercompanyParentException('Parent Account is not found...');
                }
                System.debug('accountVsParentAccountMap2 '+ accountVsParentAccountMap);
                if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(invoiceRecord.ccrz__SoldTo__c) && accountVsParentAccountMap.get(invoiceRecord.ccrz__SoldTo__c)!=null)
                {
                 
                 clonedInvoice.ccrz__SoldTo__c=accountVsParentAccountMap.get(invoiceRecord.ccrz__SoldTo__c);
                }
                else
                {
                    throw new OSM_SW_IntercompanyParentException('Parent Account is not found...');
                }
                clonedInvoice.OSM_Child_Account__c=invoiceRecord.ccrz__BillTo__c;
                //clonedInvoice.OSM_IC_InvoiceNumber__c=clonedInvoice.Name;
                
                // Start : Defect Fix - RTC_181557 - March 22, 2019
                Boolean distrContactAddressNotFoundException = true;
                if(null != distributorAccountToBoltAddressMap  && (Label.OSM_North_America_Country.contains(invoiceRecord.ccrz__BillTo__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c)))
                {
                    ID distributorAccID = accountVsParentAccountMap.get(invoiceRecord.ccrz__BillTo__c);
                    
                        if(null != distributorAccID && null != distributorAccountToBoltAddressMap)
                        {
                            ID distributorContactAddressID = distributorAccountToBoltAddressMap.get(distributorAccID);
                            
                            if(null != distributorContactAddressID && null != contactAddressMap)
                            {
                                ccrz__E_ContactAddr__c distributorContactAddress = contactAddressMap.get(distributorContactAddressID);
                                
                                if(null != distributorContactAddress)
                                {
                                    ccrz__E_ContactAddr__c clonedBillingContactAddress = distributorContactAddress.clone(false, true);
                                    ccrz__E_ContactAddr__c clonedSoldToContactAddress = distributorContactAddress.clone(false, true);
                                    
                                    List<ccrz__E_ContactAddr__c> clonedContactAddressList = new List<ccrz__E_ContactAddr__c>();
                                    clonedContactAddressList.add(clonedBillingContactAddress);
                                    clonedContactAddressList.add(clonedSoldToContactAddress);
                                    
                                    if(clonedContactAddressList!=null && clonedContactAddressList.size()>0)
                                    {
                                        Database.SaveResult[] resultContactAddress=Database.Insert(clonedContactAddressList);
                                        System.debug('result of contact address record insert>>>'+clonedContactAddressList);
                                    }
                                    
                                    clonedInvoice.ccrz__BillAddress__c = clonedBillingContactAddress.ID;
                                    clonedInvoice.ccrz__SoldAddress__c = clonedSoldToContactAddress.ID;
                                    
                                    distrContactAddressNotFoundException = false;
                                }
                            }
                        }
                    
                    
                }
                else if(!Label.OSM_North_America_Country.contains(invoiceRecord.ccrz__BillTo__r.BillingCountry) && !label.OSM_PO_Distributor_List.contains(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c))
                {
                    ID distributorAccID = accountVsParentAccountMap.get(invoiceRecord.ccrz__BillTo__c);
                        if(null != distributorAccID && null != customerCodeToAccountRecord)
                        {
                            Account distAccount=customerCodeToAccountRecord.get(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c);
                            List<ccrz__E_ContactAddr__c> clonedContactAddressList = new List<ccrz__E_ContactAddr__c>();
                            ccrz__E_ContactAddr__c ContactAddr=new ccrz__E_ContactAddr__c();
                            ContactAddr.ccrz__AddressFirstline__c=distAccount.BillingStreet;
                            ContactAddr.ccrz__City__c=distAccount.BillingCity;
                            ContactAddr.ccrz__State__c=distAccount.BillingState;
                            ContactAddr.ccrz__Country__c=distAccount.BillingCountry;
                            ContactAddr.ccrz__PostalCode__c=distAccount.BillingPostalCode;
                            ContactAddr.ccrz__StateISOCode__c=distAccount.BillingStateCode;
                            ContactAddr.ccrz__CountryISOCode__c=distAccount.BillingCountryCode;
                            clonedContactAddressList.add(ContactAddr);
                            if(clonedContactAddressList!=null && clonedContactAddressList.size()>0)
                            {
                                Database.SaveResult[] resultContactAddress=Database.Insert(clonedContactAddressList);
                            }
                            clonedInvoice.ccrz__BillAddress__c = ContactAddr.ID;
                            clonedInvoice.ccrz__SoldAddress__c = ContactAddr.ID;
                            clonedInvoice.Is_GOMS_Intercompany_Invoice__c=true;     
                            distrContactAddressNotFoundException = false;
                            
                        }
                }
                if(distrContactAddressNotFoundException)
                {
                    throw new OSM_SW_IntercompanyParentException('Parent Account BOLT Contact Address not found...');
                }
                
                // END : Defect Fix - RTC_181557 - March 22, 2019
                
                System.debug('cloned Invoice>>>'+clonedInvoice);
                clonedInvoiceList.add(clonedInvoice);
                invoiceIdSet.add(invoiceRecord.id);
                //log.Invoice__c=invoiceRecord.id;
                //
                if(invoiceRecord.ccrz__InvoiceItems__r!=null)
                {
                    for(ccrz__E_InvoiceItem__c invoiceItemListRecord:invoiceRecord.ccrz__InvoiceItems__r)
                    {
                        invoiceItemList.add(invoiceItemListRecord);
                    }
                }
                 
            }
        }
        
        //Insert Cloned invoice records
        if(clonedInvoiceList!=null && clonedInvoiceList.size()>0)
        {
         Database.SaveResult[] resultOrderItem=Database.Insert(clonedInvoiceList);
         System.debug('result of invoice record insert>>>'+clonedInvoiceList);
        }
        
        //update original invoice  records
        if(invoiceList!=null && invoiceList.size()>0)
        {
         Database.SaveResult[] resultOrderItem=Database.Update(invoiceList);
        }
        
        Decimal totalDNprice=0.0;
        //cloning the OrderItems..
        if(orderItemsList!=null)
        {
            for(ccrz__E_OrderItem__c orderItem:orderItemsList)
            {
                system.debug('order item>>>'+orderItem);
                ccrz__E_OrderItem__c clonedOrderItem=orderItem.clone(false,true);
                clonedOrderItem.Original_Sales_Order_Item__c=orderItem.id;
                clonedOrderItem.Vertex_Tax__c=0.00;
                if(orderIdMap !=null && orderIdMap.containsKey(clonedOrderItem.ccrz__Order__c))
                {
                    clonedOrderItem.ccrz__Order__c=orderIdMap.get(clonedOrderItem.ccrz__Order__c).id;
                }
                
                    system.debug('DN price>>>'+clonedOrderItem.Dn_Price__c);
                    if(clonedOrderItem.Dn_Price__c!=null && clonedOrderItem.Dn_Price__c>=0)
                    {
                        //clonedOrderItem.ccrz__SubAmount__c=clonedOrderItem.Dn_Price__c*clonedOrderItem.ccrz__Quantity__c;
                        clonedOrderItem.ccrz__SubAmount__c=clonedOrderItem.Dn_Price__c;
                        totalDNprice=totalDNprice+clonedOrderItem.Dn_Price__c;
                        if(clonedOrderItem.ccrz__Quantity__c!=null && clonedOrderItem.Original_Dn_Price__c!=null )
                        {
                        //clonedOrderItem.ccrz__Price__c=clonedOrderItem.Dn_Price__c/clonedOrderItem.ccrz__Quantity__c;
                        clonedOrderItem.ccrz__Price__c=clonedOrderItem.Original_Dn_Price__c/clonedOrderItem.ccrz__Quantity__c;
                        }
                        else
                        {
                            if(clonedOrderItem.ccrz__Quantity__c!=null)
                            clonedOrderItem.ccrz__Price__c=clonedOrderItem.Dn_Price__c/clonedOrderItem.ccrz__Quantity__c;
                        }
                            
                    }
                    // Changes made for Included Products in a Bundle - JK_Distributor_Flow July 01, 2019
                    else if(clonedOrderItem.Dn_Price__c==null 
                            && clonedOrderItem.ccrz__Price__c == 0 
                            && clonedOrderItem.ccrz__ParentOrderItem__c != null)
                    {
                        System.debug('It is a Included Product of a Bundle');
                    }
                    else
                    {
                        throw new OSM_SW_IntercompanyDNPriceException('The DN Price is not valid');
                    }
                
                
                System.debug('cloned Order Item>>>'+clonedOrderItem);
                clonedOrdersItemList.add(clonedOrderItem);
                orderItemIdsSet.add(orderItem.id);

            }
        }
        //Insert Cloned Order Item records
        if(clonedOrdersItemList!=null && clonedOrdersItemList.size()>0)
        {
         Database.SaveResult[] resultOrderItem=Database.Insert(clonedOrdersItemList);
         System.debug('result of order item insert>>>'+resultOrderItem);
        }
        //fetch the cloned order item records
        
        clonedOrderItems=[select id,ccrz__OrderLineType__c,ccrz__ParentOrderItem__c,Original_Sales_Order_Item__c,ccrz__SubAmount__c,ccrz__Quantity__c from ccrz__E_OrderItem__c where Original_Sales_Order_Item__c in :orderItemIdsSet];
        if(clonedOrderItems!=null)
        {
            for(ccrz__E_OrderItem__c clonedItemRecord:clonedOrderItems)
            {
                orderItemIdMap.put(clonedItemRecord.Original_Sales_Order_Item__c,clonedItemRecord);
                orderItemIdSet.add(clonedItemRecord.id);
            }
            for(ccrz__E_OrderItem__c clonedItemRecord:clonedOrderItems)
            {
                if(clonedItemRecord.ccrz__OrderLineType__c=='Minor')
                {
                    if(orderItemIdMap!=null && orderItemIdMap.containsKey(clonedItemRecord.ccrz__ParentOrderItem__c))
                    {
                        clonedItemRecord.ccrz__ParentOrderItem__c=orderItemIdMap.get(clonedItemRecord.ccrz__ParentOrderItem__c).id;
                        clonedOrderItemsList.add(clonedItemRecord);
                    }
                }
            }
        }
        //updating cloned items to update parent order item mapping
        
        update clonedOrderItemsList;
         //fetching cloned invoice records ...
        
        clonedInviceRecordsList=[select id,Is_GOMS_Intercompany_Invoice__c,Original_Sales_Order_Invoice_Number__c,Name from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN :invoiceIdSet];
        if(clonedInviceRecordsList!=null)
        {
            for(ccrz__E_Invoice__c invoiceRecord:clonedInviceRecordsList)
            {
                invoiceIdMap.put(invoiceRecord.Original_Sales_Order_Invoice_Number__c,invoiceRecord); 
            }
        }
        if(invoiceItemList!=null)
        {
            Decimal originalAmount=0.0;
            for(ccrz__E_InvoiceItem__c invoiceItemRecord:invoiceItemList)
            {
                ccrz__E_InvoiceItem__c clonedInvoiceItem=invoiceItemRecord.clone(false,true);
                if(invoiceIdMap!=null && invoiceIdMap.containsKey(invoiceItemRecord.ccrz__Invoice__c))
                clonedInvoiceItem.ccrz__Invoice__c =invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).id;
                if(orderIdMap!=null && orderIdMap.containsKey(invoiceItemRecord.ccrz__CCOrder__c))
                clonedInvoiceItem.ccrz__CCOrder__c=orderIdMap.get(invoiceItemRecord.ccrz__CCOrder__c).id;
                //need to complete this logic 
                /*if(orderItemIdMap!=null && orderItemIdMap.containsKey(invoiceItemRecord.ccrz__CCOrderItem__c) && orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c)!= null)
                {
                    clonedInvoiceItem.ccrz__CCOrderItem__c=orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c).id;
                    clonedInvoiceItem.ccrz__OriginalAmount__c=orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c).ccrz__SubAmount__c;
                    originalAmount=originalAmount+clonedInvoiceItem.ccrz__OriginalAmount__c;
                    invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).ccrz__OriginalAmount__c=originalAmount;
                    invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).BMS_InvoiceTotal__c=originalAmount;
                    
                }*/
                system.debug('MAPPPPPP>>>>'+orderItemIdRecordMap);
                
                    clonedInvoiceItem.ccrz__OriginalAmount__c=totalDNprice;
                    invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).ccrz__OriginalAmount__c=totalDNprice;
                
                
                System.debug('cloned Invoice item>>>'+clonedInvoiceItem);
                clonedInvoiceItemList.add(clonedInvoiceItem);
                
            }
        }
        //Insert Cloned invoice item records
        if(clonedInvoiceItemList!=null && clonedInvoiceItemList.size()>0)
        {
         Database.SaveResult[] resultInvoiceItem=Database.Insert(clonedInvoiceItemList);
         System.debug('result of invoice item record insert>>>'+resultInvoiceItem);
        }
        //update cloned invoice  record
        if(clonedInviceRecordsList!=null && clonedInviceRecordsList.size()>0)
        {
         Database.SaveResult[] resultClonedInvoiceUpdate=Database.Update(clonedInviceRecordsList);
        }
        
        //fetch the cloned invoice item records
        
        clonedInvoiceItems=[SELECT ccrz__Invoice__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__InvoiceItemId__c,ccrz__OriginalAmount__c,ccrz__Sequence__c,ccrz__Status__c,ccrz__Type__c FROM ccrz__E_InvoiceItem__c where ccrz__CCOrderItem__c in:orderItemIdSet];
        if(clonedInvoiceItems!=null)
        {
            for(ccrz__E_InvoiceItem__c clonedInvoiceItemRecord:clonedInvoiceItems)
            {
                invoiceItemIdMap.put(clonedInvoiceItemRecord.ccrz__CCOrderItem__c,clonedInvoiceItemRecord);
            }
        }
        //cloning junction object record of order and invoice
        if(OrderInvoiceJunList!=null)
        {
            for(OSM_Orders_In_Invoice__c orderInvoiceRecord:OrderInvoiceJunList)
            {
                junctionParentRecordSet.add(orderInvoiceRecord.id);
                OSM_Orders_In_Invoice__c clonedJunctionRecord=orderInvoiceRecord.clone(false,true);
                clonedJunctionRecord.Original_OSM_Orders_In_Invoice__c=orderInvoiceRecord.id;
                
                if(orderIdMap != null && orderIdMap.containsKey(clonedJunctionRecord.CC_Order__c) && orderIdMap.get(clonedJunctionRecord.CC_Order__c)!= null)
                {
                    clonedJunctionRecord.CC_Order__c=orderIdMap.get(clonedJunctionRecord.CC_Order__c).id;
                }
                if(invoiceIdMap !=null && invoiceIdMap.containsKey(clonedJunctionRecord.CC_Invoice__c) && invoiceIdMap.get(clonedJunctionRecord.CC_Invoice__c)!=null)
                {
                    clonedJunctionRecord.CC_Invoice__c=invoiceIdMap.get(clonedJunctionRecord.CC_Invoice__c).id;
                }
                //introduce by sharad
                
                
                    clonedJunctionRecord.Vertex_Call_Status__c = 'Pending';
                
                clonedJunctionList.add(clonedJunctionRecord);
                if(orderInvoiceRecord.OSM_InvoiceLine_And_OrderLines__r!=null)
                {
                    for(OSM_InvoiceLine_And_OrderLine__c  juncChildListRecord:orderInvoiceRecord.OSM_InvoiceLine_And_OrderLines__r)
                    {
                        OrderInvoiceChildJunList.add(juncChildListRecord);
                    }
                    
                }
               
            }
        }
        //insert cloned junction object record
        if(clonedJunctionList!=null && clonedJunctionList.size()>0)
        {
         Database.SaveResult[] resultJunctionObject=Database.Insert(clonedJunctionList);
         System.debug('result of junction record insert>>>'+resultJunctionObject);
        }
        //fetching cloned junction object record
        
        clonedJunctionRecordsList=[select id,Original_OSM_Orders_In_Invoice__c,Vertex_Call_Status__c,Vertex_Refund_Call_Status__c,Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.BillingCountry,Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c from OSM_Orders_In_Invoice__c where Original_OSM_Orders_In_Invoice__c in:junctionParentRecordSet ];
        List<Id> lstInvoiceIdForVertexCall = new List<Id>();
        List<OSM_Orders_In_Invoice__c> toupdate = new List<OSM_Orders_In_Invoice__c>();
        if(clonedJunctionRecordsList!=null)
        {
            for(OSM_Orders_In_Invoice__c clonedJunctionRecord:clonedJunctionRecordsList)
            {
                if(Label.OSM_North_America_Country.contains(clonedJunctionRecord.Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(clonedJunctionRecord.Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c) )
                {
                    lstInvoiceIdForVertexCall.add(clonedJunctionRecord.Id);
                }
                else
                {
                    clonedJunctionRecord.Vertex_Call_Status__c = 'Success';
                    clonedJunctionRecord.Vertex_Refund_Call_Status__c = 'Success';
                    toupdate.add(clonedJunctionRecord);
                }
                clonedJunctionRecordsMap.put(clonedJunctionRecord.Original_OSM_Orders_In_Invoice__c,clonedJunctionRecord);
            }
            
            if(toupdate != null && toupdate.size() > 0)
                update toupdate;
        }
         //cloning the child junction record
        if(OrderInvoiceChildJunList!=null)
        {
            for(OSM_InvoiceLine_And_OrderLine__c orderInvoiceChildRecord:OrderInvoiceChildJunList)
            {
                OSM_InvoiceLine_And_OrderLine__c clonedJunctionChildRecord=orderInvoiceChildRecord.clone(false,true);
                
                if(orderItemIdMap !=null && orderItemIdMap.containsKey(clonedJunctionChildRecord.CC_Order_Item__c) && orderItemIdMap.get(clonedJunctionChildRecord.CC_Order_Item__c)!= null)
                {
                    clonedJunctionChildRecord.Sales_Amount__c=orderItemIdMap.get(clonedJunctionChildRecord.CC_Order_Item__c).ccrz__SubAmount__c;
                    
                    // Changes made for JK_Distributor_Debugging on June 28, 2019
                    clonedJunctionChildRecord.Quantity__c=orderItemIdMap.get(clonedJunctionChildRecord.CC_Order_Item__c).ccrz__Quantity__c;
                    
                    clonedJunctionChildRecord.CC_Order_Item__c=orderItemIdMap.get(clonedJunctionChildRecord.CC_Order_Item__c).id;
                }
                
                if(invoiceItemIdMap!=null && invoiceItemIdMap.containsKey(clonedJunctionChildRecord.CC_Order_Item__c) && invoiceItemIdMap.get(clonedJunctionChildRecord.CC_Order_Item__c)!=null)
                {
                    clonedJunctionChildRecord.CC_Invoice_Item__c=invoiceItemIdMap.get(orderItemIdMap.get(orderInvoiceChildRecord.CC_Order_Item__c).id).id;
                }
                if(clonedJunctionRecordsMap!=null && clonedJunctionRecordsMap.containsKey(orderInvoiceChildRecord.OSM_Orders_In_Invoice__c) && clonedJunctionRecordsMap.get(orderInvoiceChildRecord.OSM_Orders_In_Invoice__c) !=null)
                {
                    clonedJunctionChildRecord.OSM_Orders_In_Invoice__c=clonedJunctionRecordsMap.get(orderInvoiceChildRecord.OSM_Orders_In_Invoice__c).id;
                }
                clonedJunChildList.add(clonedJunctionChildRecord);
                
               
            }
        }
        //insert cloned junction child object record
        if(clonedJunChildList!=null && clonedJunChildList.size()>0)
        {
         Database.SaveResult[] resultJunctionChildObject=Database.Insert(clonedJunChildList);
         System.debug('result of junction child record insert>>>'+resultJunctionChildObject);
        }
        for(OSM_Integration_Log__c log:logVsOrderIdMap.values())
        {
          logList.add(log);
        }
        if(lstInvoiceIdForVertexCall != null && lstInvoiceIdForVertexCall.size() > 0)
        {
            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTaxFuture(lstInvoiceIdForVertexCall);
        }
    }
     catch (Exception ex){
        // roll everything back in case of error
             
            Database.rollback(sp);
        
        OSM_Integration_Log__c errorDescriptionLog = new OSM_Integration_Log__c();
        errorDescriptionLog.Service_Name__c = 'Intercompany Process';
        errorDescriptionLog.Response__c = ex.getStackTraceString();
        errorDescriptionLog.Error_Description__c = ex.getMessage();
        errorDescriptionLog.Status__c = 'Failure';
         errorDescriptionLog.Account__c = AccountId; //Added by Dhiraj
        errorDescriptionLog.Logged_In_User__c = userinfo.getuserid();
        
        logList.add(errorDescriptionLog);
        
            system.debug('exception>>>>'+ex);
            //log.Status__c = 'Failure'; 
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            system.debug('map>>>>'+logVsOrderIdMap);
            if(logVsOrderIdMap!=null)
            {
                for(OSM_Integration_Log__c log:logVsOrderIdMap.values())
                {
                        log.Error_Description__c = msg;
                        log.Logged_In_User__c = userinfo.getuserid();
                        log.status__c='Failure';
                    	log.Account__c = AccountId; //Added by Dhiraj
                        logList.add(log);
                }
            }
            
         }
        system.debug('log List>>>>'+logList);
    if(logList!=null && logList.size()>0)
    { 
        if(!Test.isRunningTest()) 
        insert logList;
    }
    
     
 }
}