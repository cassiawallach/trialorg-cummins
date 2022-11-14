/************************************************************
    Name:  OSM_SW_IntercompanyOrderInvoice
    Copyright © 2018  Cummins
    =============================================================
    =============================================================
    Purpose:                                                            
    This class is developed to create intercompany sales order and 
    invoice record.              
    =============================================================
    =============================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR                DATE              DETAIL                                
    1.0 -    Sangeeta Rani         18/12/2018     INITIAL DEVELOPMENT          

    *************************************************************/
    
    public class OSM_SW_IntercompanyOrderInvoice{
 
        //This method used to create intercompany invoice and order record
        public static void createIntercompnayOrderAndInvoice(Set < Id > OrderId)
        {
           system.debug('order id set>>>>>>'+OrderId);
           List<ccrz__E_Order__c> clonedOrdersList=new List<ccrz__E_Order__c>();
           List<ccrz__E_OrderItem__c> clonedOrdersItemList=new List<ccrz__E_OrderItem__c>();
           Map<Id,ccrz__E_Order__c> orderIdMap=new Map<Id,ccrz__E_Order__c>();
           Set<Id> orderItemIdsSet=new Set<Id>(); 
           Set<Id> cartIdSet=new Set<Id>();
           Set<Id> productSubTermIdSet=new Set<Id>();
           Map<Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map<Id, ccrz__E_PriceListItem__c >();
           List<ccrz__E_Invoice__c> clonedInvoiceList=new List<ccrz__E_Invoice__c>();
           Set<Id> invoiceIdSet=new Set<Id>();
           Map<Id,ccrz__E_Invoice__c> invoiceIdMap=new Map<Id,ccrz__E_Invoice__c>();
           List<ccrz__E_InvoiceItem__c> clonedInvoiceItemList=new List<ccrz__E_InvoiceItem__c>();
           Map<id,ccrz__E_OrderItem__c> orderItemIdMap=new Map<id,ccrz__E_OrderItem__c>();
           Map<id,ccrz__E_InvoiceItem__c> invoiceItemIdMap=new Map<id,ccrz__E_InvoiceItem__c>();
           List<ccrz__E_TransactionPayment__c> clonedTransPaymentList=new List<ccrz__E_TransactionPayment__c>();
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
           
           
           //fetching the original order record used in FSD
           
           //string queryOrder=UtilsForIntercompanyClass.getCreatableFieldsSOQL('ccrz__E_Order__c','id IN: OrderId');
           String queryOrder='SELECT ccrz__Account__r.OSM_SW_Responsible_Region__c,ccrz__Account__r.PSBU_Channel_of_Distribution__c,ccrz__Account__r.EBU_Channel_of_Distribution__c,OSM_Discount_On_BMS__c,Third_Party_BMS_Customer_Name__c,IsInterCompanyProcessSuccess__c,Purchased_By_User_Type__c,OSM_Discount_On_BOLT__c,OSM_Discount_On_DN__c,OwnerId,ccrz__Account__c, ccrz__Account__r.IAM_Service_Provider_Code__c, ccrz__Account__r.CSS_DistributorCode__c ,ccrz__Account__r.Parentid,ccrz__AdjustmentAmount__c,ccrz__AdjustmentReason__c,ccrz__BillTo__c,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__CCEmailAddress__c,ccrz__CCSubscription__c,ccrz__Contact__c,ccrz__ContractId__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,ccrz__ExtCarrier__c,ccrz__ExtShipTo__c,ccrz__ExtShipTrackNo__c,ccrz__IsAnonymous__c,ccrz__Name__c,ccrz__Note__c,ccrz__OrderDate__c,ccrz__OrderId__c,ccrz__OrderSeller__c,ccrz__OrderStatus__c,ccrz__Order__c,ccrz__OriginatedCart__c,ccrz__PONumber__c,ccrz__PaymentMethod__c,ccrz__RequestDate__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,ccrz__ShipMethod__c,ccrz__ShipStructure__c,ccrz__ShipTo__c,ccrz__SkipTax__c,ccrz__SplitParentOrder__c,ccrz__SplitProcessed__c,ccrz__Storefront__c,ccrz__TaxExemptFlag__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c,ccrz__User__c,ccrz__VerifyExemptionFlag__c,Refund_status__c,BMS_BranchLocation__c,BMS_OrderRefNumber__c,Discount_Type__c,OE_Comment__c,Order_Source_Type__c,OrderProcessedforFSD__c,OSM_SW_Is_Bolt_PO__c,Original_Sales_Order__c,(SELECT ccrz__Product__r.Group_Name__c,OSM_SW_Product_Link__c,ccrz__Order__c,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,ccrz__Category__c,ccrz__Comments__c,ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription__c,ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__Next_Subscription_Date__c,ccrz__OrderItemGroup__c,ccrz__OrderItemId__c,ccrz__OrderItemStatus__c,ccrz__OrderLineType__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__ParentOrderItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__SplitSource__c,ccrz__StoreId__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Auto_Renewal__c,ccrz__Subscription_Duration__c,ccrz__Subscription_End_Date__c,ccrz__Subscription_Frequency__c,ccrz__Subscription_Start_Date__c,ccrz__Subscription_Status__c,ccrz__TertiaryAttr__c,ccrz__UnitOfMeasure__c,Original_Sales_Order_Item__c,Number_of_Bundles__c,Number_of_Counts__c,Dn_Price__c,OSM_SW_Coupon_Applied__c,Original_Dn_Price__c FROM ccrz__E_OrderItems__r) FROM ccrz__E_Order__c WHERE id IN: OrderId';
           System.debug('query String for order>>>>'+queryOrder);
           List<ccrz__E_Order__c> orderList=Database.query(queryOrder);
           System.debug('result of order query>>>>'+orderList);
            
            // RTC_181096 START : Changes for Account to be mapped to distributor code - not parent ID
            
            Set<String> distributorCodeList = new Set<String>();
            Set<String> iamCustDistCodeList = new Set<String>();
            Set<String> reasonCustDistCodeList = new Set<String>();
            Map<Id,String> iamDistvsAccId = new Map<Id,String>();
            System.debug('orderList '+orderList);
            for(ccrz__E_Order__c order:orderList)
            {
                AccountId = order.ccrz__Account__c; //Added By Dhiraj
                System.debug('ggsOrder '+order.ccrz__Account__r.CSS_DistributorCode__c);
                distributorCodeList.add(order.ccrz__Account__r.CSS_DistributorCode__c);
                if(order.Third_Party_BMS_Customer_Name__c !='')
                iamCustDistCodeList.add(order.Third_Party_BMS_Customer_Name__c);
            
                if(order.ccrz__Account__r.EBU_Channel_of_Distribution__c =='CIHR' || order.ccrz__Account__r.PSBU_Channel_of_Distribution__c =='CIHR')
                distributorCodeList.add(order.ccrz__Account__r.OSM_SW_Responsible_Region__c);
            }
            System.debug('distributorCodeList11 '+distributorCodeList);
            List<Account> iamCutAccountsList = [Select ID,IAM_Service_Provider_Code__c,EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,OSM_SW_Responsible_Region__c,CSS_DistributorCode__c, Name,BillingCity,BillingState,BillingCountry,BillingPostalCode,BillingStateCode,BillingCountryCode,BillingStreet from Account where Id IN :iamCustDistCodeList];  
            for(Account ac : iamCutAccountsList)
            { system.debug('1111ac.Id11'+ac.Id+'22ac.CSS_DistributorCode__c22'+ac.CSS_DistributorCode__c);
               distributorCodeList.add(ac.CSS_DistributorCode__c); 
               iamDistvsAccId.put(ac.Id,ac.CSS_DistributorCode__c);
               
                
            }
           System.debug('distributorCodeList22 '+distributorCodeList);
            Map<string,Account> customerCodeToAccountRecord=new Map<String,Account>();
            List<Account> allAccountsList = [Select ID,IAM_Service_Provider_Code__c, CSS_DistributorCode__c, Name,BillingCity,BillingState,BillingCountry,BillingPostalCode,BillingStateCode,BillingCountryCode,BillingStreet from Account where IAM_Service_Provider_Code__c IN :distributorCodeList];  
            Map<String, Id> customerCodeToAccountMap = new Map<String, Id>();
            System.debug('allAccountsList '+ allAccountsList);
            for(Account acc : allAccountsList)
            {
                if(null != acc.IAM_Service_Provider_Code__c)
                {
                    customerCodeToAccountMap.put(acc.IAM_Service_Provider_Code__c, acc.ID);
                    customerCodeToAccountRecord.put(acc.IAM_Service_Provider_Code__c,acc);
               }
            }
            
            // Start : Defect Fix - RTC_181557 - March 22, 2019 
            Map<ID, ID> distributorAccountToBoltAddressMap = new Map<ID, ID>();
            Set<ID> contactAdddressIDSet = new Set<ID>();
            Map<ID, ccrz__E_ContactAddr__c> contactAddressMap = new Map<ID, ccrz__E_ContactAddr__c>();
            System.debug('distributorCodeList: '+distributorCodeList);
            for(ccrz__E_AccountAddressBook__c addressBook : [Select ID, ccrz__E_ContactAddress__r.ID, ccrz__Account__r.ID  From ccrz__E_AccountAddressBook__c where ccrz__E_ContactAddress__r.Bolt_Active__c=true AND ccrz__E_ContactAddress__r.Bolt_Site__c=true AND ccrz__E_ContactAddress__r.Site_Use_Status__c=true AND ccrz__Account__r.IAM_Service_Provider_Code__c IN :distributorCodeList])
            {
        System.debug('addressBook: '+addressBook);
                distributorAccountToBoltAddressMap.put(addressBook.ccrz__Account__r.ID, addressBook.ccrz__E_ContactAddress__r.ID);
                contactAdddressIDSet.add(addressBook.ccrz__E_ContactAddress__r.ID);
            }
            
            for(ccrz__E_ContactAddr__c contactAddress : [Select Id, Name, ccrz__AddressFirstline__c, ccrz__AddressSecondline__c, ccrz__AddressThirdline__c, ccrz__AddrReadOnly__c, ccrz__City__c, ccrz__CompanyName__c, ccrz__Country__c, ccrz__CountryISOCode__c, ccrz__DaytimePhone__c, ccrz__Email__c, ccrz__FirstName__c, ccrz__HomePhone__c, ccrz__LastName__c, ccrz__MailStop__c, ccrz__MiddleName__c, ccrz__Partner_Id__c, ccrz__PostalCode__c, ccrz__ShippingComments__c, ccrz__State__c, ccrz__StateISOCode__c FROM ccrz__E_ContactAddr__c where ID in :contactAdddressIDSet])
            {
                contactAddressMap.put(contactAddress.ID, contactAddress);
            } 
            // END : Defect Fix - RTC_181557 - March 22, 2019
           for(ccrz__E_Order__c order:orderList)
            {
                
                if(order.Third_Party_BMS_Customer_Name__c !='' && order.Third_Party_BMS_Customer_Name__c != null)
                {  
          System.debug('order.Third_Party_BMS_Customer_Name__c: '+order.Third_Party_BMS_Customer_Name__c);
          System.debug('iamDistvsAccId.get(order.Third_Party_BMS_Customer_Name__c): '+iamDistvsAccId.get(order.Third_Party_BMS_Customer_Name__c));
                   ID accID = customerCodeToAccountMap.get(iamDistvsAccId.get(order.Third_Party_BMS_Customer_Name__c));
           System.debug('accID: '+accID);
                   System.debug('accID'+accID);
                   accountVsParentAccountMap.put(order.Third_Party_BMS_Customer_Name__c,accID); 
                   parentIdsSet.add(accID);
                }
               else if(order.ccrz__Account__r.EBU_Channel_of_Distribution__c=='CIHR' || order.ccrz__Account__r.PSBU_Channel_of_Distribution__c=='CIHR')
               {
                    System.debug('customerCodeToAccountMap ' +customerCodeToAccountMap);
                    ID accID = customerCodeToAccountMap.get(order.ccrz__Account__r.OSM_SW_Responsible_Region__c);
                    System.debug('accID'+accID);
                    accountVsParentAccountMap.put(order.ccrz__Account__c,accID);
                    parentIdsSet.add(accID);
               }
               else{
                System.debug('customerCodeToAccountMap ' +customerCodeToAccountMap);
                ID accID = customerCodeToAccountMap.get(order.ccrz__Account__r.CSS_DistributorCode__c);
                System.debug('accID'+accID);
                accountVsParentAccountMap.put(order.ccrz__Account__c,accID);
                parentIdsSet.add(accID);
               }
                //accountVsParentAccountMap.put(order.ccrz__Account__c,order.ccrz__Account__r.Parentid);
                cartIdSet.add(order.ccrz__OriginatedCart__c);
                orderIdSet.add(order.id);
                
                //parentIdsSet.add(order.ccrz__Account__r.Parentid);
            }
            
            // RTC_181096 END : Changes for Account to be mapped to distributor code - not parent ID
            
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
           //Querying cart and cart items records for this order..
           
           List<ccrz__E_Cart__c> cartList=[Select id,Name,(select Id,ccrz__ParentCartItem__c,ccrz__SubProdTerm__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where id IN:cartIdSet];
           system.debug('cart list>>>>'+cartList);
           
           //Querying OSM_Order_Subscription__c records
           system.debug('orderIdSet>>>> '+orderIdSet);
           List<OSM_Order_Subscription__c> OSMOrderSubscriptionList=[Select id,OSM_CCSubscription__c,OSM_CCSubscription__r.Monthly_Dn_Price__c,OSM_CCSubscription__r.Yearly_Dn_Price__c,OSM_CCSubscription__r.Quarterly_Dn_Price__c,OSM_CCSubscription__r.OneTime_Dn_Price__c,Billing_Frequency__c,OSM_CCOrder__c from OSM_Order_Subscription__c where OSM_CCOrder__c IN:orderIdSet];
           System.debug('OSMOrderSubscriptionList '+OSMOrderSubscriptionList);
            for(OSM_Order_Subscription__c orderSubRecord:OSMOrderSubscriptionList)
           {
               //orderIdVsSubTermMap.put(orderSubRecord.OSM_CCOrder__c,orderSubRecord.Billing_Frequency__c);
               //osmOrderSubscriptionIdSet.add(orderSubRecord.OSM_CCSubscription__c);
               
               if(orderSubRecord.Billing_Frequency__c=='Monthly')
               {
                   billingFrqVSValue.put('Monthly',orderSubRecord.OSM_CCSubscription__r.Monthly_Dn_Price__c);
                   
               }
               else if(orderSubRecord.Billing_Frequency__c=='Yearly')
               {
                   billingFrqVSValue.put('Yearly',orderSubRecord.OSM_CCSubscription__r.Yearly_Dn_Price__c);
                   
               }
               else if(orderSubRecord.Billing_Frequency__c=='Quarterly')
               {
                   billingFrqVSValue.put('Yearly',orderSubRecord.OSM_CCSubscription__r.Quarterly_Dn_Price__c);
                  
               }
               else if(orderSubRecord.Billing_Frequency__c=='One time')
               {
                   billingFrqVSValue.put('One Time',orderSubRecord.OSM_CCSubscription__r.OneTime_Dn_Price__c);
                   
               }
               orderIdVsSubTermMap.put(orderSubRecord.OSM_CCOrder__c,orderSubRecord.Billing_Frequency__c);
               System.debug('orderIdVsSubTermMap>>>>>>'+orderIdVsSubTermMap);
           }
           
           //fetching the order items for original order
           //string oueryOrderItem=UtilsForIntercompanyClass.getCreatableFieldsSOQL('ccrz__E_OrderItem__c','ccrz__Order__c IN: OrderId');
           //string oueryOrderItem='SELECT ccrz__Order__c,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,ccrz__Category__c,ccrz__Comments__c,ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription__c,ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__Next_Subscription_Date__c,ccrz__OrderItemGroup__c,ccrz__OrderItemId__c,ccrz__OrderItemStatus__c,ccrz__OrderLineType__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__ParentOrderItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__SplitSource__c,ccrz__StoreId__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Auto_Renewal__c,ccrz__Subscription_Duration__c,ccrz__Subscription_End_Date__c,ccrz__Subscription_Frequency__c,ccrz__Subscription_Start_Date__c,ccrz__Subscription_Status__c,ccrz__TertiaryAttr__c,ccrz__UnitOfMeasure__c,Original_Sales_Order_Item__c,Number_of_Bundles__c,Number_of_Counts__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c IN: OrderId';
           //System.debug('query String for orderItem>>>>'+oueryOrderItem);
           //List<ccrz__E_OrderItem__c> orderItemsList=Database.query(oueryOrderItem);
           //System.debug('result of orderItem query>>>>'+orderItemsList);
           
           //fetching the Invoice records used in FSD..
           //string oueryInvoice=UtilsForIntercompanyClass.getCreatableFieldsSOQL('ccrz__E_Invoice__c','ccrz__CCOrder__c IN: OrderId');
           //String queryInvoice='SELECT OwnerId,ccrz__BillAddress__c,ccrz__BillTo__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__Contact__c,ccrz__CurrencyCode__c,ccrz__DateDue__c,ccrz__DateIssued__c,ccrz__InvoiceId__c,ccrz__OriginalAmount__c,ccrz__ParentInvoice__c,ccrz__RemainingAmount__c,ccrz__SoldAddress__c,ccrz__SoldTo__c,ccrz__Status__c,ccrz__Storefront__c,ccrz__Terms__c,ccrz__Type__c,ccrz__User__c,Discount_Total__c,Payment_Method__c,Recurring_Invoice__c,BMS_DistributorAddressline__c,BMS_DistributorCity__c,BMS_DistributorName__c,BMS_DistributorState__c,BMS_Distributorpostalcode__c,OSM_SW_IsIntercompanyInvoice__c,BMS_InvoiceNumber__c,BMS_InvoiceTotal__c,BMS_PONumber__c,BMS_paymenttype__c,BMS_CreateDate__c,OSM_SW_IsBoltARInvoiceDone__c,BMS_InvoiceDate__c,OSM_SW_isBoltJournalEntryDone__c,Invoice_Pdf__c,OSM_SW_Is_Bolt_PO__c,OSM_IC_InvoiceNumber__c,Original_Sales_Order_Invoice_Number__c,IntercompanyCalled__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c IN: OrderId';
           String queryInvoice='SELECT OwnerId,ccrz__BillAddress__c,ccrz__BillTo__r.BillingCountry,ccrz__BillTo__r.CSS_DistributorCode__c,Is_GOMS_Intercompany_Invoice__c,Total_Sales_Amount__c,ccrz__BillTo__c,ccrz__CCOrder__c,ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c,ccrz__Comments__c,ccrz__Contact__c,ccrz__CurrencyCode__c,ccrz__DateDue__c,ccrz__DateIssued__c,ccrz__InvoiceId__c,ccrz__OriginalAmount__c,ccrz__ParentInvoice__c,ccrz__RemainingAmount__c,ccrz__SoldAddress__c,ccrz__SoldTo__c,ccrz__Status__c,ccrz__Storefront__c,ccrz__Terms__c,ccrz__Type__c,ccrz__User__c,Discount_Total__c,Payment_Method__c,Recurring_Invoice__c,BMS_DistributorAddressline__c,BMS_DistributorCity__c,BMS_DistributorName__c,BMS_DistributorState__c,BMS_Distributorpostalcode__c,OSM_SW_IsIntercompanyInvoice__c,BMS_InvoiceNumber__c,BMS_InvoiceTotal__c,BMS_PONumber__c,BMS_paymenttype__c,BMS_CreateDate__c,OSM_SW_IsBoltARInvoiceDone__c,BMS_InvoiceDate__c,OSM_SW_isBoltJournalEntryDone__c,OSM_SW_Is_Bolt_PO__c,ICInvoice_Number__c,Original_Sales_Order_Invoice_Number__c,IntercompanyCalled__c,ICInvoice_Date__c,(SELECT ccrz__Invoice__c,ccrz__Invoice__r.ccrz__OriginalAmount__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__InvoiceItemId__c,ccrz__OriginalAmount__c,ccrz__Sequence__c,ccrz__Status__c,ccrz__Type__c FROM ccrz__InvoiceItems__r ) FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c IN: OrderId';
																																																																																																																																																																																																																																																																																																																																																																																																																																							  

           System.debug('query String for invoice>>>>'+queryInvoice);
           List<ccrz__E_Invoice__c> invoiceList=Database.query(queryInvoice);
           System.debug('result of invoice query>>>>'+invoiceList);
           
           //fetching the Transation Payment record..
           
           //string queryTransactionPayment=UtilsForIntercompanyClass.getCreatableFieldsSOQL('ccrz__E_TransactionPayment__c','ccrz__CCOrder__c IN: OrderId');
           string queryTransactionPayment='SELECT OwnerId,ccrz__AccountNumber__c,ccrz__AccountType__c,ccrz__Account__c,ccrz__Address__c,ccrz__Amount__c,ccrz__BillTo__c,ccrz__CCOrder__c,ccrz__CCSubscription__c,ccrz__Comments__c,ccrz__Contact__c,ccrz__CurrencyISOCode__c,ccrz__ExpirationMonth__c,ccrz__ExpirationYear__c,ccrz__InvoiceAppliedFor__c,ccrz__InvoiceAppliedTo__c,ccrz__ParentTransactionPayment__c,ccrz__PaymentType__c,ccrz__RequestAmount__c,ccrz__SoldTo__c,ccrz__SourceTransactionPayment__c,ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubAccountNumber__c,ccrz__Token__c,ccrz__TransactionCode__c,ccrz__TransactionPaymentId__c,ccrz__TransactionSubcode__c,ccrz__TransactionTS__c,ccrz__TransactionType__c,ccrz__User__c,ccrz__VerificationCode__c,Bolt_Recurring_AR_Call_Status__c,Bolt_Recurring_JE_Call_Status__c,Bolt_Revoke_AR_Call_Status__c,Bolt_Revoke_JE_Call_Status__c,OSM_BAMS_Cancel_Request__c,OSM_BAMS_Cancel_Response__c,OSM_BAMS_Cancel_Transaction_Status__c,Transaction_Status__c,Bolt_AR_Call_Status__c,Bolt_Credit_Memo_Call_Status__c,Bolt_JE_Call_Status__c,Bolt_JE_Reversal_Call_Status__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c IN: OrderId';
           System.debug('query String for Transaction Payment>>>>'+queryTransactionPayment);
           List<ccrz__E_TransactionPayment__c> transactionPaymentList=Database.query(queryTransactionPayment);
           System.debug('result of transaction payment>>>>'+transactionPaymentList);
           
           //fetching the Order/Invoice junction object record
           //string junctionQuery='SELECT CC_Invoice__c,CC_Order__c,OSM_SW_Is_Refund_Request__c,Vertex_Call_Status__c,Vertex_Tax__c,Vertex_Refund_Call_Status__c FROM OSM_Orders_In_Invoice__c WHERE CC_Order__c IN: OrderId';
           string junctionQuery='SELECT CC_Invoice__c,CC_Order__c,OSM_SW_Is_Refund_Request__c,Vertex_Call_Status__c,Vertex_Tax__c,Vertex_Refund_Call_Status__c,(SELECT CC_Invoice_Item__c,CC_Order_Item__c,OSM_Orders_In_Invoice__c,Sales_Amount__c,Vertex_Tax__c FROM OSM_InvoiceLine_And_OrderLines__r) FROM OSM_Orders_In_Invoice__c where CC_Order__c IN: OrderId';
           System.debug('query String for junction object>>>>'+junctionQuery);
           List<OSM_Orders_In_Invoice__c> OrderInvoiceJunList=Database.query(junctionQuery);
           System.debug('result of junction object query>>>>'+OrderInvoiceJunList);
           
           
           
           
            
           
           
           // setup the save point for rollback
           //log.Service_Name__c=Label.OSM_Intercompany;
           Savepoint sp = Database.setSavepoint();
           try{
               
               //log.Status__c='Success';
               //cloning the original order to create Intercompany order
               if(orderList!=null)
               {
                   for(ccrz__E_Order__c order:orderList)
                   {
                       //orderItemsList.add(order.ccrz__E_OrderItems__r);
                       ccrz__E_Order__c clonedOrder=order.clone(false,true);
                       clonedOrder.Original_Sales_Order__c=order.id;
                       clonedOrder.OSM_SW_Is_InterCompany_Order__c=true;
                       clonedOrder.ccrz__TaxAmount__c=0.00;
                       // if(order.Third_Party_BMS_Customer_Name__c !='')
                       if(order.Third_Party_BMS_Customer_Name__c != null){
                           if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(order.Third_Party_BMS_Customer_Name__c) ){
                            //clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(clonedOrder.ccrz__Account__c);
                               clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(order.Third_Party_BMS_Customer_Name__c);
                           }
                       }
                       else { 
                           if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(clonedOrder.ccrz__Account__c) ) {
                                clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(clonedOrder.ccrz__Account__c);
                           }
                       }
                       System.debug('cloned Order>>>'+clonedOrder);
                       clonedOrdersList.add(clonedOrder);
                       //log.CC_Order__c=order.id;
                       order.IsInterCompanyProcessSuccess__c=true;
                       OSM_Integration_Log__c log=new OSM_Integration_Log__c();
                       log.Account__c = AccountId;//Added By Dhiraj
                       log.Service_Name__c=Label.OSM_Intercompany;
                       log.Status__c='Success';
                       log.Logged_In_User__c = userinfo.getuserid();
                       log.CC_Order__c=order.id;
                       logVsOrderIdMap.put(order.id,log);
                       if(order.ccrz__E_OrderItems__r!=null)
                       {
                           for(ccrz__E_OrderItem__c orderItemListRecord:order.ccrz__E_OrderItems__r)
                           {
                               orderItemsList.add(orderItemListRecord);
                           }
                       }
                   }
               }
               //Insert Cloned  order records
               if(clonedOrdersList!=null && clonedOrdersList.size()>0)
               {
                Database.SaveResult[] resultOrder=Database.Insert(clonedOrdersList);
                System.debug('result of cloned order insert>>>'+ resultOrder);
                Database.Upsert(orderList);
                System.debug('result of  order Updated>>>'+ orderList);
               } 
               if(orderItemsList!=null)
               {
                   for(ccrz__E_OrderItem__c orderItem:orderItemsList)
                   {
                       productSubTermIdSet.add(orderItem.ccrz__SubProdTerm__c);
                   }
               }
               //getting price list
               /*List<ccrz__E_PriceListItem__c> priceListItemRecord=[Select id,ccrz__SubProdTerm__c,ccrz__Product__c,ccrz__Price__c,Distributor_Price__c from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c=:productSubTermIdSet and ccrz__RecurringPrice__c = false];
               if(priceListItemRecord!=null)
               {
                   for(ccrz__E_PriceListItem__c objPrice : priceListItemRecord )
                   {
                               
                       mapSubProdIdToPriceListItem.put(objPrice.ccrz__SubProdTerm__c, objPrice);
                   }      
               }
               */
               
               //fetching cloned order records ...
                
                 newClonedOrderRecordsList=[select id,Original_Sales_Order__c from ccrz__E_Order__c where Original_Sales_Order__c IN :orderList];
               if(newClonedOrderRecordsList!=null) 
               {
                   for(ccrz__E_Order__c orderRecord:newClonedOrderRecordsList)
                   {
                       orderIdMap.put(orderRecord.Original_Sales_Order__c,orderRecord); 
                   }
               }
               //cloning the Invoice records
               System.debug('invoiceList '+invoiceList);
               if(invoiceList!=null)
               {
                   for(ccrz__E_Invoice__c invoiceRecord :invoiceList)
                   {
                       if(logVsOrderIdMap!=null && logVsOrderIdMap.containsKey(invoiceRecord.ccrz__CCOrder__c))
                       {
                           OSM_Integration_Log__c log=logVsOrderIdMap.get(invoiceRecord.ccrz__CCOrder__c);
                           log.Invoice__c=invoiceRecord.id;
                           log.Account__c = AccountId;//Added By Dhiraj
                           logVsOrderIdMap.put(invoiceRecord.ccrz__CCOrder__c,log);
                       }  
                       //sharad to update invoice IC date
                       invoiceRecord.ICInvoice_Date__c = System.Today();
                       invoiceRecord.OSM_Child_Account__c=invoiceRecord.ccrz__BillTo__c;
                       //sharad code end
                       ccrz__E_Invoice__c clonedInvoice=invoiceRecord.clone(false,true);
                       if(orderIdMap!=null && orderIdMap.containsKey(invoiceRecord.ccrz__CCOrder__c))
                       clonedInvoice.ccrz__CCOrder__c=orderIdMap.get(invoiceRecord.ccrz__CCOrder__c).id;
                       clonedInvoice.Original_Sales_Order_Invoice_Number__c=invoiceRecord.id;
                       clonedInvoice.OSM_SW_IsIntercompanyInvoice__c=true;
                       clonedInvoice.ICInvoice_Date__c = System.Today();
                       clonedInvoice.Original_Sales_Order__c=invoiceRecord.ccrz__CCOrder__c;
                       if(!Label.OSM_North_America_Country.contains(invoiceRecord.ccrz__BillTo__r.BillingCountry) && !label.OSM_PO_Distributor_List.contains(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c))
                       {
                           clonedInvoice.Is_GOMS_Intercompany_Invoice__c=true;
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
                      /*
                      if(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c != null)
                       {
                           if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c) ){
                            //clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(clonedOrder.ccrz__Account__c);
                               clonedInvoice.ccrz__BillTo__c=accountVsParentAccountMap.get(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c);
                                accountVsParentAccountMap.put(invoiceRecord.ccrz__BillTo__c,clonedInvoice.ccrz__BillTo__c);
                                if(accountVSPrimaryContactMap!=null && accountVSPrimaryContactMap.containsKey(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c))
                                {
                                clonedInvoice.ccrz__Contact__c=accountVSPrimaryContactMap.get(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c);
                                
                                }
                           }
                           else
                           {
                               throw new OSM_SW_IntercompanyParentException('Parent Account is not found...');
                           }
                       }
                       else{
                           
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
                       }
                       System.debug('accountVsParentAccountMap2 '+ accountVsParentAccountMap);
             if(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c != null)
                       {
                           if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c) ){
                            //clonedOrder.ccrz__Account__c=accountVsParentAccountMap.get(clonedOrder.ccrz__Account__c);
                               clonedInvoice.ccrz__SoldTo__c=accountVsParentAccountMap.get(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c);
                 if(accountVSPrimaryContactMap!=null && accountVSPrimaryContactMap.containsKey(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c))
                {
                  clonedInvoice.ccrz__Contact__c=accountVSPrimaryContactMap.get(invoiceRecord.ccrz__CCOrder__r.Third_Party_BMS_Customer_Name__c);
                }
                           }
                           else
                           {
                               throw new OSM_SW_IntercompanyParentException('Parent Account is not found...');
                           }
                       }
             else
             {
               if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(invoiceRecord.ccrz__SoldTo__c) && accountVsParentAccountMap.get(invoiceRecord.ccrz__SoldTo__c)!=null)
               {
              
              clonedInvoice.ccrz__SoldTo__c=accountVsParentAccountMap.get(invoiceRecord.ccrz__SoldTo__c);
               }
               else
               {
                 throw new OSM_SW_IntercompanyParentException('Parent Account is not found...');
               }
             }*/
                       clonedInvoice.OSM_Child_Account__c=invoiceRecord.ccrz__BillTo__c;
                       //clonedInvoice.OSM_IC_InvoiceNumber__c=clonedInvoice.Name;
                       
                       // Start : Defect Fix - RTC_181557 - March 22, 2019
                       Boolean distrContactAddressNotFoundException = true;
             System.debug('distributorAccountToBoltAddressMap: '+distributorAccountToBoltAddressMap);
                       if(null != distributorAccountToBoltAddressMap && (Label.OSM_North_America_Country.contains(invoiceRecord.ccrz__BillTo__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(invoiceRecord.ccrz__BillTo__r.CSS_DistributorCode__c)))
                       {
               System.debug('accountVsParentAccountMap: '+accountVsParentAccountMap);
               System.debug('invoiceRecord.ccrz__BillTo__c: '+invoiceRecord.ccrz__BillTo__c);
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
               
               //getting cartItems
               if(cartList!=null)
               {
                   for(ccrz__E_Cart__c cartRecord:cartList)
                   {
                       if(cartRecord.ccrz__E_CartItems__r!=null)
                       {
                           for(ccrz__E_CartItem__c cartItem:cartRecord.ccrz__E_CartItems__r)
                           {
                               subprodTermVsCartItemMap.put(cartItem.ccrz__SubProdTerm__c,cartItem);
                           }
                       }
                   }
               }
               system.debug('subprodTermVsCartItemMap>>>'+subprodTermVsCartItemMap);
               
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
                       //DN price calculation...
                       //if(clonedOrderItem.ccrz__Product__r.Group_Name__c!=null && clonedOrderItem.ccrz__Product__r.Group_Name__c=='SES')
                       //{
                           /*if(subprodTermVsCartItemMap!=null && subprodTermVsCartItemMap.containsKey(clonedOrderItem.ccrz__SubProdTerm__c) && subprodTermVsCartItemMap.get(clonedOrderItem.ccrz__SubProdTerm__c).ccrz__ParentCartItem__c==null)
                           {
                               if(mapSubProdIdToPriceListItem !=null && mapSubProdIdToPriceListItem.containsKey(clonedOrderItem.ccrz__SubProdTerm__c) && mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c !=null && mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c>0 )
                               {
                                clonedOrderItem.ccrz__SubAmount__c=mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c * clonedOrderItem.ccrz__Quantity__c;
                                clonedOrderItem.ccrz__Price__c=mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c;
                               }
                               else
                               {
                                   throw new OSM_SW_IntercompanyDNPriceException('The DN Price is not valid');
                               }
                           }*/
                           /*else if(subprodTermVsCartItemMap!=null && subprodTermVsCartItemMap.containsKey(clonedOrderItem.ccrz__SubProdTerm__c) && subprodTermVsCartItemMap.get(clonedOrderItem.ccrz__SubProdTerm__c).ccrz__ParentCartItem__c!=null)
                           {
                               if(mapSubProdIdToPriceListItem !=null && mapSubProdIdToPriceListItem.containsKey(clonedOrderItem.ccrz__SubProdTerm__c) && mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c !=null )
                               {
                                clonedOrderItem.ccrz__SubAmount__c=mapSubProdIdToPriceListItem.get(clonedOrderItem.ccrz__SubProdTerm__c).Distributor_Price__c * clonedOrderItem.ccrz__Quantity__c;
                               }
                               else
                               {
                                   throw new OSM_SW_IntercompanyDNPriceException('The DN Price is not valid');
                               }
                           }*/
                       //}
                       
                           /*if(orderIdVsSubTermMap!=null && orderIdVsSubTermMap.containsKey(orderItem.ccrz__Order__c))
                           {
                               if(billingFrqVSValue!=null && billingFrqVSValue.containsKey(orderIdVsSubTermMap.get(orderItem.ccrz__Order__c)))
                               { 
                                   system.debug('billing freq >>>>'+orderIdVsSubTermMap.get(orderItem.ccrz__Order__c));
                                   system.debug('billing freq value>>>>'+billingFrqVSValue.get(orderIdVsSubTermMap.get(orderItem.ccrz__Order__c)));
                                   clonedOrderItem.ccrz__Price__c=billingFrqVSValue.get(orderIdVsSubTermMap.get(orderItem.ccrz__Order__c));
                               }
                           }*/
                           system.debug('DN price>>>'+clonedOrderItem.Dn_Price__c);
                           if(clonedOrderItem.Dn_Price__c!=null && clonedOrderItem.Dn_Price__c>=0)
                           {
                               //clonedOrderItem.ccrz__SubAmount__c=clonedOrderItem.Dn_Price__c*clonedOrderItem.ccrz__Quantity__c;
                               clonedOrderItem.ccrz__SubAmount__c=clonedOrderItem.Dn_Price__c;
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
               //fetching the original Invoice item records..
               
               //string queryInvoiceItem=UtilsForIntercompanyClass.getCreatableFieldsSOQL('ccrz__E_InvoiceItem__c',' ccrz__Invoice__c IN: invoiceIdSet');
               //string queryInvoiceItem='SELECT ccrz__Invoice__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__InvoiceItemId__c,ccrz__OriginalAmount__c,ccrz__Sequence__c,ccrz__Status__c,ccrz__Type__c FROM ccrz__E_InvoiceItem__c WHERE  ccrz__Invoice__c IN: invoiceIdSet';
               //System.debug('query String for invoice item>>>>'+queryInvoiceItem);
               //List<ccrz__E_InvoiceItem__c> invoiceItemList=Database.query(queryInvoiceItem);
               //System.debug('result of invoice item query>>>>'+invoiceItemList);
               
               //cloning the invoice item records..
               if(invoiceItemList!=null)
               {
                   //Decimal originalAmount=0.0;
                   Map<Id, Decimal> map_invIdAmount = new Map<Id, Decimal>();
                   for(ccrz__E_InvoiceItem__c invoiceItemRecord:invoiceItemList)
                   {
                       ccrz__E_InvoiceItem__c clonedInvoiceItem=invoiceItemRecord.clone(false,true);
                       if(invoiceIdMap!=null && invoiceIdMap.containsKey(invoiceItemRecord.ccrz__Invoice__c))
                       clonedInvoiceItem.ccrz__Invoice__c =invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).id;
                       if(orderIdMap!=null && orderIdMap.containsKey(invoiceItemRecord.ccrz__CCOrder__c))
                       clonedInvoiceItem.ccrz__CCOrder__c=orderIdMap.get(invoiceItemRecord.ccrz__CCOrder__c).id;
                       if(orderItemIdMap!=null && orderItemIdMap.containsKey(invoiceItemRecord.ccrz__CCOrderItem__c) && orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c)!= null)
                       {
                           Decimal originalAmount=0.0;
                           clonedInvoiceItem.ccrz__CCOrderItem__c=orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c).id;
                           if(!map_invIdAmount.containsKey(invoiceItemRecord.ccrz__Invoice__c)){
                               map_invIdAmount.put(invoiceItemRecord.ccrz__Invoice__c, 0);
                           }else{
                               originalAmount = map_invIdAmount.get(invoiceItemRecord.ccrz__Invoice__c);
                           }
                           System.debug('originalAmount before update >>>'+originalAmount);
                           clonedInvoiceItem.ccrz__OriginalAmount__c=orderItemIdMap.get(invoiceItemRecord.ccrz__CCOrderItem__c).ccrz__SubAmount__c;
                           originalAmount = originalAmount + clonedInvoiceItem.ccrz__OriginalAmount__c;
                           System.debug('originalAmount after update >>>'+originalAmount);
                           invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).ccrz__OriginalAmount__c = originalAmount;
                           map_invIdAmount.put(invoiceItemRecord.ccrz__Invoice__c, originalAmount);
                           if(!invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).Is_GOMS_Intercompany_Invoice__c) {
                               invoiceIdMap.get(invoiceItemRecord.ccrz__Invoice__c).BMS_InvoiceTotal__c=originalAmount;
                           }
                           System.debug('map_invIdAmount before update >>>'+map_invIdAmount);
                       }
					   		
					   if(clonedInvoiceItem.ccrz__Type__c=='Tax')
                       {
                           clonedInvoiceItem.ccrz__OriginalAmount__c=0;
                       }
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
               
               clonedJunctionRecordsList=[select id,Vertex_Call_Status__c,Vertex_Refund_Call_Status__c,Original_OSM_Orders_In_Invoice__c,Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.BillingCountry,Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c from OSM_Orders_In_Invoice__c where Original_OSM_Orders_In_Invoice__c in:junctionParentRecordSet ];
               List<Id> lstInvoiceIdForVertexCall = new List<Id>();
               List<OSM_Orders_In_Invoice__c> toupdate = new List<OSM_Orders_In_Invoice__c>();
               if(clonedJunctionRecordsList!=null)
               {
                   for(OSM_Orders_In_Invoice__c clonedJunctionRecord:clonedJunctionRecordsList)
                   {
                       if(Label.OSM_North_America_Country.contains(clonedJunctionRecord.Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(clonedJunctionRecord.Original_OSM_Orders_In_Invoice__r.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c))
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
               //fetching the Order/Invoice line item junction child object record
               //string junctionChildQuery='SELECT CC_Invoice_Item__c,CC_Order_Item__c,OSM_Orders_In_Invoice__c,Sales_Amount__c,Vertex_Tax__c FROM OSM_InvoiceLine_And_OrderLine__c WHERE OSM_Orders_In_Invoice__c IN: junctionParentRecordSet';
               //System.debug('query String for junction child object>>>>'+junctionChildQuery);
               //List<OSM_InvoiceLine_And_OrderLine__c> OrderInvoiceChildJunList=Database.query(junctionChildQuery);
               //System.debug('result of junction child object query>>>>'+OrderInvoiceChildJunList);
               
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
               
               
               //cloning the Transaction Payment records
               if(transactionPaymentList!=null)
               {
                   for(ccrz__E_TransactionPayment__c transPaymentRecord:transactionPaymentList)
                   {
                       ccrz__E_TransactionPayment__c clonedTransPaymentRecord=transPaymentRecord.clone(false,true);
                       
                       if(orderIdMap!=null && orderIdMap.containsKey(clonedTransPaymentRecord.ccrz__CCOrder__c) && orderIdMap.get(clonedTransPaymentRecord.ccrz__CCOrder__c)!= null)
                       {
                           clonedTransPaymentRecord.ccrz__CCOrder__c=orderIdMap.get(clonedTransPaymentRecord.ccrz__CCOrder__c).id;
                       }
                       if(invoiceIdMap!=null && invoiceIdMap.containsKey(clonedTransPaymentRecord.ccrz__InvoiceAppliedTo__c) && invoiceIdMap.get(clonedTransPaymentRecord.ccrz__InvoiceAppliedTo__c)!=null)
                       {
                           clonedTransPaymentRecord.ccrz__InvoiceAppliedTo__c=invoiceIdMap.get(clonedTransPaymentRecord.ccrz__InvoiceAppliedTo__c).id;
                       }
                       if(accountVsParentAccountMap!=null && accountVsParentAccountMap.containsKey(transPaymentRecord.ccrz__Account__c))
                       {
                           clonedTransPaymentRecord.ccrz__Account__c=accountVsParentAccountMap.get(transPaymentRecord.ccrz__Account__c);
                           clonedTransPaymentRecord.ccrz__BillTo__c=accountVsParentAccountMap.get(transPaymentRecord.ccrz__Account__c);
                           clonedTransPaymentRecord.ccrz__SoldTo__c=accountVsParentAccountMap.get(transPaymentRecord.ccrz__Account__c);
                       }
                       
                       clonedTransPaymentRecord.Bolt_JE_Call_Status__c = 'Pending';
                       clonedTransPaymentRecord.Bolt_AR_Call_Status__c = 'Pending';
                       clonedTransPaymentList.add(clonedTransPaymentRecord);
                       System.debug('cloned transaction Payment record>>>'+clonedTransPaymentRecord);
                       
                       //log.Transaction_Payment__c=transPaymentRecord.id;
                       if(logVsOrderIdMap!=null && logVsOrderIdMap.containsKey(transPaymentRecord.ccrz__CCOrder__c))
                       {
                           OSM_Integration_Log__c log=logVsOrderIdMap.get(transPaymentRecord.ccrz__CCOrder__c);
                           log.Transaction_Payment__c=transPaymentRecord.id;
                           log.Account__c = AccountId;//Added By Dhiraj
                           logVsOrderIdMap.put(transPaymentRecord.ccrz__CCOrder__c,log);
                       }
                       
                   }
               }
               //insert cloned Transaction Payment record
               if(clonedTransPaymentList!=null && clonedTransPaymentList.size()>0)
               {
                Database.SaveResult[] resultTransPaymentItem=Database.Insert(clonedTransPaymentList);
                System.debug('result of Trans Payment record insert>>>'+resultTransPaymentItem);
               }
           }
            
           
           catch (Exception ex){
               // roll everything back in case of error
                    
                   Database.rollback(sp);
               
               OSM_Integration_Log__c errorDescriptionLog = new OSM_Integration_Log__c();
               errorDescriptionLog.Account__c = AccountId;//Added By Dhiraj
               errorDescriptionLog.Service_Name__c = 'Intercompany Process';
               errorDescriptionLog.Response__c = ex.getStackTraceString();
               errorDescriptionLog.Error_Description__c = ex.getMessage();
               errorDescriptionLog.Status__c = 'Failure';
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
                              log.Account__c = AccountId;//Added By Dhiraj
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