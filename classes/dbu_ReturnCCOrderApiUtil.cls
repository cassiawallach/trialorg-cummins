/**
 * @description       : Used for Order submit API and Return orders API
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : Devaraj
**/
public without sharing class dbu_ReturnCCOrderApiUtil {
    
    @AuraEnabled
    public static String getUserInfo(){
        return UserInfo.getUserType();
    }
    @AuraEnabled
    public static List<dbu_CCOrderAPIResponseWrapper> returnOrderItemDetails(String urlParam){
        String orderId;
        System.debug('urlParam=====>'+urlParam);
        if(String.isNotBlank(urlParam)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            System.debug('?????????\t'+params.size());
            if(params.size() > 0 && params.containsKey('orderid')){
                orderId =  params.get('orderid');
            }
        } 
        List<dbu_CCOrderAPIResponseWrapper> ccOrderWrapLst = new List<dbu_CCOrderAPIResponseWrapper>();
        if(orderId != ''){
            ccOrderWrapLst =  dbu_CallCCOrderApi.fetchOrderDetailsOnClick(orderId);
        }
        return ccOrderWrapLst;
    }
    
    @AuraEnabled
    public static String callReturnOrderAPI(String orderid, List<string> orderItemId ){
        ccrz__E_Order__c orderDetails1 = New ccrz__E_Order__c();
        List<ccrz__E_OrderItem__c> listOrderItemDetails = New List<ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> listOrderItems = New List<ccrz__E_OrderItem__c>();
        orderDetails1 =[Select id,name,ccrz__ShipMethod__c,CC_Order__c,ccrz__PaymentMethod__c,dbu_StoreLocationAddress__c,ccrz__Name__c,ccrz__OriginatedCart__c,ccrz__Storefront__c,ccrz__OrderDate__c,ccrz__OrderStatus__c,ccrz__CurrencyISOCode__c,ccrz__Contact__c,ccrz__Account__c,ccrz__Note__c,ccrz__TotalSurcharge__c,
                        ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c,ccrz__IsAnonymous__c,ccrz__User__c,ccrz__BillTo__c,ccrz__ShipTo__c
                        from ccrz__E_Order__c where id=:orderid];
        ccrz__E_Order__c cloneOrder = orderDetails1.Clone(false,true,false,false);
        cloneOrder.CC_Order__c=orderid;
        cloneOrder.dbu_Is_Cloned__c=True;
        cloneOrder.ccrz__OrderDate__c=System.Today();
        cloneOrder.CurrencyIsoCode = orderDetails1.ccrz__CurrencyISOCode__c;
        Insert cloneOrder;
        listOrderItemDetails =[Select id,ccrz__OrderItemId__c,Name,ccrz__Price__c,ccrz__PricingType__c,dbu_Is_return_mail_sent__c,dbu_Return_Additional_Information__c,dbu_Reason_for_Return__c,ccrz__RequestDate__c,ccrz__Quantity__c,ccrz__SubAmount__c,ccrz__Product__c,ccrz__Order__c,dbu_Selected_Return_Items__c,ccrz__OrderItemStatus__c,ccrz__AdjustmentAmount__c,
                               dbu_Dropoff_Location__c,dbu_Ship_to_Address__c,dbu_Shipto__c,dbu_CC_Order_Item__c,dbu_Estimated_Return_Amount__c,ccrz__ProductType__c,ccrz__UnitOfMeasure__c,ccrz__StoreId__c,ccrz__ItemStatus__c,ccrz__OriginalQuantity__c,ccrz__OriginalItemPrice__c,Vertex_Tax__c,ccrz__OrderLineType__c,
                               dbu_Return_Tax__c,dbu_StoreCode__c,dbu_Return_Amount__c,dbu_store_language__c from ccrz__E_OrderItem__c Where ccrz__Order__c =:orderid AND dbu_Selected_Return_Items__c=True AND ccrz__OrderItemStatus__c= Null];
        
        Set<String> orgReturnLineItemIds = new Set<String>();
        for(ccrz__E_OrderItem__c orderItems:listOrderItemDetails){
            orgReturnLineItemIds.add(orderItems.Id);
            ccrz__E_OrderItem__c createNewOItems = new ccrz__E_OrderItem__c();
            createNewOItems.ccrz__Order__c=cloneOrder.id;
            createNewOItems.ccrz__Price__c=orderItems.ccrz__Price__c;
            createNewOItems.ccrz__Quantity__c=orderItems.ccrz__Quantity__c;
            createNewOItems.ccrz__SubAmount__c=orderItems.dbu_Return_Amount__c;
            createNewOItems.ccrz__RequestDate__c=orderItems.ccrz__RequestDate__c;
            createNewOItems.ccrz__PricingType__c=orderItems.ccrz__PricingType__c;
            createNewOItems.dbu_Reason_for_Return__c=orderItems.dbu_Reason_for_Return__c;
            createNewOItems.dbu_Return_Additional_Information__c=orderItems.dbu_Return_Additional_Information__c;
            createNewOItems.dbu_Is_return_mail_sent__c=orderItems.dbu_Is_return_mail_sent__c;
            createNewOItems.dbu_Dropoff_Location__c=orderItems.dbu_Dropoff_Location__c;
            createNewOItems.dbu_Ship_to_Address__c=orderItems.dbu_Ship_to_Address__c;
            createNewOItems.dbu_Shipto__c=orderItems.dbu_Shipto__c;
            createNewOItems.dbu_Estimated_Return_Amount__c=orderItems.dbu_Estimated_Return_Amount__c;
            createNewOItems.ccrz__OrderLineType__c=orderItems.ccrz__OrderLineType__c;
            createNewOItems.ccrz__Product__c=orderItems.ccrz__Product__c;
            createNewOItems.ccrz__ProductType__c=orderItems.ccrz__ProductType__c;
            createNewOItems.ccrz__UnitOfMeasure__c=orderItems.ccrz__UnitOfMeasure__c;
            createNewOItems.ccrz__OrderItemStatus__c='Return Initiated';
            createNewOItems.ccrz__StoreId__c=orderItems.ccrz__StoreId__c;
            createNewOItems.ccrz__ItemStatus__c=orderItems.ccrz__ItemStatus__c;
            createNewOItems.ccrz__OriginalQuantity__c=orderItems.ccrz__Quantity__c;
            createNewOItems.ccrz__OriginalItemPrice__c=orderItems.ccrz__OriginalItemPrice__c;
            createNewOItems.Vertex_Tax__c=orderItems.Vertex_Tax__c;
            createNewOItems.dbu_CC_Order_Item__c =orderItems.id;
            createNewOItems.dbu_Return_Amount__c = orderItems.dbu_Return_Amount__c;
            createNewOItems.dbu_Return_Tax__c = orderItems.dbu_Return_Tax__c;
            createNewOItems.CurrencyIsoCode = orderDetails1.ccrz__CurrencyISOCode__c;
            createNewOItems.dbu_StoreCode__c = orderItems.dbu_StoreCode__c;
            createNewOItems.ccrz__AdjustmentAmount__c=orderItems.dbu_Return_Tax__c;
            createNewOItems.dbu_store_language__c = orderItems.dbu_store_language__c;
            createNewOItems.ccrz__OrderItemId__c = orderItems.ccrz__OrderItemId__c;
            listOrderItems.add(createNewOItems);
        }
        insert listOrderItems;
        List<ccrz__E_TransactionPayment__c> cloneTransactionList = new  List<ccrz__E_TransactionPayment__c>();
        List<ccrz__E_TransactionPayment__c> transanctionList = new  List<ccrz__E_TransactionPayment__c>();
        transanctionList = [SELECT Id,Name, ccrz__AccountNumber__c, ccrz__TransactionType__c,ccrz__PaymentType__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c =: orderid];
        if(!transanctionList.isEmpty()){
            for(ccrz__E_TransactionPayment__c transRecord : transanctionList){
                ccrz__E_TransactionPayment__c transObj = new ccrz__E_TransactionPayment__c();
                transObj.ccrz__CCOrder__c = cloneOrder.id;
                transObj.ccrz__AccountNumber__c = transRecord.ccrz__AccountNumber__c;
                transObj.ccrz__TransactionType__c = transRecord.ccrz__TransactionType__c;
                transObj.ccrz__PaymentType__c = transRecord.ccrz__PaymentType__c;
               cloneTransactionList.add(transObj);
            }
        }
        if(cloneTransactionList.size() > 0){
            insert cloneTransactionList;
            
        }
        //-----------------
        List<CC_Tax__c> ccTaxList = new List<CC_Tax__c>();
        Map<String,ccrz__E_OrderItem__c> cloneLineItemIdMap = new  Map<String,ccrz__E_OrderItem__c>();
        List<CC_Tax__c> listCCTaxRecords =  [SELECT Id,dbu_Is_Shipping_Tax__c,JurisdictionId__c,JurisdictionValue__c,Situs__c,Taxable__c,ImpositionTypeId__c,EffectiveRate__c,ImpositionId__c,ImpositionTypevalue__c,JurisdictionLevel__c,TaxCollectedFromParty__c,TaxResult__c,TaxType__c,ImpositionValue__c,CalculatedTax__c,CC_Order_Item__c,CC_Order_Item__r.ccrz__OrderItemId__c 
                                             FROM CC_Tax__c WHERE CC_Order_Item__c IN : orgReturnLineItemIds AND dbu_Is_Shipping_Tax__c = false];
        System.debug('listCCTaxRecords size==='+listCCTaxRecords.size());
        System.debug('listCCTaxRecords ==='+listCCTaxRecords);
        List<ccrz__E_OrderItem__c> cloneLineItems = [SELECT Id,ccrz__OrderItemId__c,ccrz__OriginalQuantity__c,ccrz__Quantity__c FROM ccrz__E_OrderItem__c  Where ccrz__Order__c =: cloneOrder.Id];
        System.debug('cloneLineItems===='+cloneLineItems);
        for(ccrz__E_OrderItem__c lineItemObj : cloneLineItems){
            cloneLineItemIdMap.put(lineItemObj.ccrz__OrderItemId__c , lineItemObj);
        }
         for(CC_Tax__c taxInstance : listCCTaxRecords){
             System.debug('isTrue==='+cloneLineItemIdMap.containsKey(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c));
            if(cloneLineItemIdMap.containsKey(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c)){
                CC_Tax__c taxObj = new CC_Tax__c();
                taxObj.ImpositionValue__c = taxInstance.ImpositionValue__c;
                taxObj.CalculatedTax__c = taxInstance.CalculatedTax__c;
                taxObj.CC_Order_Item__c = cloneLineItemIdMap.get(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c).Id;
                taxObj.JurisdictionId__c = taxInstance.JurisdictionId__c;
                taxObj.Situs__c = taxInstance.Situs__c;
                taxObj.Taxable__c = taxInstance.Taxable__c;
                taxObj.ImpositionTypeId__c = taxInstance.ImpositionTypeId__c;
                taxObj.EffectiveRate__c = taxInstance.EffectiveRate__c;
                taxObj.ImpositionId__c = taxInstance.ImpositionId__c;
                taxObj.JurisdictionLevel__c = taxInstance.JurisdictionLevel__c;
                taxObj.TaxCollectedFromParty__c = taxInstance.TaxCollectedFromParty__c;
                taxObj.ImpositionTypevalue__c = taxInstance.ImpositionTypevalue__c;
                taxObj.TaxResult__c = taxInstance.TaxResult__c;
                taxObj.TaxType__c = taxInstance.TaxType__c;
                
                ccTaxList.add(taxObj);
            }
        }
        System.debug('ccTaxList====='+ccTaxList.size());
        if(ccTaxList.size() > 0){
            insert ccTaxList;
        }

        //-----------------
        /*Here going to update the status of OrderItem*/
        List<ccrz__E_OrderItem__c> unselectedOItems = new List<ccrz__E_OrderItem__c>();
        
        for(ccrz__E_OrderItem__c ordItem :[Select Id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c Where ccrz__OrderItemStatus__c='Return Initiated' AND dbu_Selected_Return_Items__c =True AND ccrz__Order__c =: orderid]){
            
            ordItem.dbu_Selected_Return_Items__c= False;
            unselectedOItems.add(ordItem);
        }
        if(unselectedOItems.size()>0){
            update unselectedOItems;
        }
        //List<ccrz__E_OrderItem__c> lstFinalOItem = New List<ccrz__E_OrderItem__c>();  
        List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c originalOItem:[Select Id,dbu_Is_Returned__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c Where ccrz__OrderItemStatus__c=Null AND ccrz__Order__c =: orderid]){
            originalOItem.ccrz__OrderItemStatus__c='Return Initiated';
            originalOItem.dbu_Is_Returned__c = True;
            lstOrderItemToUpdate.add(originalOItem);
        }
        if(lstOrderItemToUpdate.Size()>0){
            update lstOrderItemToUpdate;
        }
        
        /*end here*/
        retunOrderItemsDetails(cloneOrder.id, orderid);
        return null;
    }
    
    /*@AuraEnabled
public static void resetSelectedOrdItems( String orderId){
List<ccrz__E_Order__c> orderDetails = New List<ccrz__E_Order__c>();
Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
List<ccrz__E_OrderItem__c> listOrderItems = new List<ccrz__E_OrderItem__c>();
orderDetails =[Select id, name, ccrz__OrderStatus__c,dbu_Days_Since_Order_Date__c,(Select id,Name,ccrz__Product__c,dbu_Selected_Return_Items__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where id=:orderId];
for (ccrz__E_Order__c orderDeta: orderDetails) {
if (orderDeta.ccrz__E_OrderItems__r != null) {
mapOrderItemList.put(orderDeta.id, orderDeta.ccrz__E_OrderItems__r);
}
for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDeta.id)){
if(oItem.dbu_Selected_Return_Items__c){
oItem.dbu_Selected_Return_Items__c=False;
listOrderItems.add(oItem);
}
}
}system.debug('listOrderItems----->>>'+listOrderItems);
if(listOrderItems != Null){
Update listOrderItems;
}
}*/
    @AuraEnabled
    public static Boolean checkingGenuineProduct(String orderid){
        List<ccrz__E_Order__c> orderDetails = New List<ccrz__E_Order__c>();
        List<ccrz__E_OrderItem__c> lstOrderItem = New List<ccrz__E_OrderItem__c>();
        Boolean coreCheck= False;
        orderDetails =[Select id, name, ccrz__OrderStatus__c,dbu_Days_Since_Order_Date__c,(Select id,Name,ccrz__Product__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.ccrz__SKU__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where id=:orderid];
        for(ccrz__E_Order__c orderDeta: orderDetails){
            for(ccrz__E_OrderItem__c oItem: orderDeta.ccrz__E_OrderItems__r){
                if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c){
                    coreCheck= True;
                }
            }  
        }
        if(orderDetails[0].dbu_Days_Since_Order_Date__c >= Integer.valueOf(System.Label.dbu_OrderDays) && coreCheck==False){
            return False;
        }else if(orderDetails[0].dbu_Days_Since_Order_Date__c >= Integer.valueOf(System.Label.dbu_CoreOrderDays) && coreCheck==True){
            return False;
        }else{
            return True;
        }
        
    }
    
    public static dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper retunOrderOrSubmitDetails(String orderid,List<String> orderItemId, String orderSubmitOrReturn){
        
        dbu_Integration_OrderSubmit.OrderSubmitRequestData  orderSubmitRequestData;
        dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response;
        string mSec;
        List<ccrz__E_Order__c> orderDetails = New List<ccrz__E_Order__c>();
        ccrz__E_Order__c obj =new ccrz__E_Order__c();
        //List<String> genuineProduct = new List<String>();
        //Ramesh Added the SOQL ccrz__TransactionCode__c 
        //Ramesh Added the SOQL ccrz__SubAmount__c
        Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
        orderDetails =[Select id, name,ccrz__BuyerPhone__c,dbu_SubmitOrder_Success__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
                       ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
                       ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
                       ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
                       ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
                       ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
                       (Select id,Name,ccrz__Product__c,ccrz__Price__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c, ccrz__Product__r.ccrz__TaxRateId__c, ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c, ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c,dbu_isShipTo__c,dbu_isInStock__c,ccrz__SubAmount__c from ccrz__E_OrderItems__r Where id=:orderItemId),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c where id=:orderid];
        System.debug('orderDetails--->>'+orderDetails);
        for (ccrz__E_Order__c orderDeta: orderDetails) {
            if (orderDeta.ccrz__E_OrderItems__r != null) {
                mapOrderItemList.put(orderDeta.id, orderDeta.ccrz__E_OrderItems__r);
            }
            obj.id = orderDeta.Id;
            
            if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('submit')){
                obj.ccrz__OrderStatus__c = 'Order Submitted';
            }
        }
        system.debug('mapOrderItemList--->>>' + mapOrderItemList);
        if(orderDetails.size()>0 && orderDetails != Null){
            try{ 
                dbu_Integration_OrderSubmit.ShipToCustomer shipToCustomer = new dbu_Integration_OrderSubmit.ShipToCustomer();
                // New Inventory chanages
               // if(orderDetails[0].ccrz__ShipMethod__c =='Ship To Address' || orderDetails[0].ccrz__ShipMethod__c =='Adresse d\'expédition'){
                    shipToCustomer.address1 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                    shipToCustomer.address2 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                    shipToCustomer.address3 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                    shipToCustomer.city =orderDetails[0].ccrz__ShipTo__r.ccrz__City__c;
                    shipToCustomer.state =orderDetails[0].ccrz__ShipTo__r.ccrz__State__c;
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                        shipToCustomer.country ='US';
                    }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                        shipToCustomer.country ='CA';
                    }
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c != null){
                        //shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                        //6th Feb Changed by Shri Ram 
                        if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).length() >= 5){
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                            }else{
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                            }
                        }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                            
                            shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                        }
                    }
                dbu_Integration_OrderSubmit.ShipToCustomer pickFromCustomer = new dbu_Integration_OrderSubmit.ShipToCustomer();
                // New Inventory chanages
               // }else if(orderDetails[0].ccrz__ShipMethod__c =='Pick Up' || orderDetails[0].ccrz__ShipMethod__c =='Ramassage'){
                    pickFromCustomer.address1 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
                    pickFromCustomer.address2 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c;
                    pickFromCustomer.address3 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c;
                    pickFromCustomer.city =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c;
                    pickFromCustomer.state =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c;
                    if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'US' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A.'){
                        pickFromCustomer.country ='US';
                    }else if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'CA'){
                        pickFromCustomer.country ='CA';
                    }
                    if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c != null){
                        //shipToCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).substring(0,5);
                        //6th Feb Changed by Shri Ram 
                        if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'US' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A.'){
                            if((orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).length() >= 5){
                                pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).substring(0,5);
                            }else{
                                pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                            }
                        }else if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'CA'){
                            
                            pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                        }
                    }
               // }
                shipToCustomer.partyName =orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                pickFromCustomer.partyName =orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                
                List<dbu_Integration_OrderSubmit.ShipToCustomer> shipToCustomerList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();
                List<dbu_Integration_OrderSubmit.ShipToCustomer> pickFromCustomerList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();
                shipToCustomerList.add(shipToCustomer);
                pickFromCustomerList.add(pickFromCustomer);
                
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.ShipToDistributor shipToDistributor = new  dbu_Integration_OrderSubmit.ShipToDistributor();
                shipToDistributor.address1 = orderDetails[0].ccrz__Account__r.BillingStreet;
                shipToDistributor.address2 = orderDetails[0].ccrz__Account__r.CMI_Address2__c;
                shipToDistributor.address3 = orderDetails[0].ccrz__Account__r.CMI_Address3__c;
                shipToDistributor.city = orderDetails[0].ccrz__Account__r.BillingCity;
                shipToDistributor.state = orderDetails[0].ccrz__Account__r.BillingState;
                if(orderDetails[0].ccrz__Account__r.BillingCountry =='United States' || orderDetails[0].ccrz__Account__r.BillingCountry =='US'){
                    shipToDistributor.country = 'US';
                }else if(orderDetails[0].ccrz__Account__r.BillingCountry =='Canada' || orderDetails[0].ccrz__Account__r.BillingCountry =='CA'){
                    shipToDistributor.country = 'CA';
                }
                shipToDistributor.postalCode = orderDetails[0].ccrz__Account__r.BillingPostalCode;
                shipToDistributor.partyName = orderDetails[0].ccrz__Account__r.Name;
                List<dbu_Integration_OrderSubmit.ShipToDistributor> shipToDistributorList = new List<dbu_Integration_OrderSubmit.ShipToDistributor>();
                shipToDistributorList.add(shipToDistributor);
                
                // need to create objects depends on the method input parameter dynamically
                // dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
                List<dbu_Integration_OrderSubmit.Lines> linesList = new List<dbu_Integration_OrderSubmit.Lines>();
                
                if(mapOrderItemList.keyset() != null && mapOrderItemList.size() > 0){
                    for (ccrz__E_Order__c orderDetail: orderDetails) {
                        for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDetail.id)){
                            dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
                            
                            lines.lineId = oItem.Name;
                            lines.orderedQuantity = Integer.ValueOf(oItem.ccrz__Quantity__c);
                            lines.orderReturnFlag = '';
                            if(oItem.ccrz__Product__r.dbu_Product_Code__c != Null){
                                lines.productCode = oItem.ccrz__Product__r.dbu_Product_Code__c;
                            }
                            //else{
                            //   lines.productCode = 'CECO'; // Its temporary fix for Submit Order
                            //}
                            
                            //lines.shippingMode = '';
                            lines.partNumber = oItem.ccrz__Product__r.dbu_Part_Number__c;
                            if(oItem.ccrz__Price__c != null){
                           //Ramesh CHG0111237 Reverted
                           lines.unitSellingPrice = oItem.ccrz__Price__c; 
                           system.debug('oItem--->>>' + oItem);
                           system.debug('oItem11--->>>'+ lines.unitSellingPrice);
                           //Ramesh CHG0111237 Reverted
                      }else{
                                lines.unitSellingPrice = 0.00;
                            }
                           // if(oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Ship To Address' || oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Adresse d\'expédition'){
                               // lines.deliveryMethod = 'SHIP';  
                           // }else if(oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Pick Up' || oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Ramassage'){
                              //  lines.deliveryMethod = 'PICK';//HardCode
                           // }
                           // New Inventory chanages
                            if(oItem.dbu_isShipTo__c){
                                lines.deliveryMethod = 'SHIP';
                                lines.shippingMode = 'SHIP';
                            }else{
                                lines.deliveryMethod = 'PICK';
                                if(oItem.dbu_isInStock__c != null && oItem.dbu_isInStock__c){
                                    lines.shippingMode = 'PICK';
                                }else{
                                    lines.shippingMode = 'pick';
                                }
                            }
                            // End Here
                            
                            lines.unitDiscount = 0.0;
                            if(oItem.ccrz__AbsoluteDiscount__c != null){
                                lines.couponDiscount = oItem.ccrz__AbsoluteDiscount__c;
                            }else{
                                lines.couponDiscount = 0;
                            }
                            
                            if(oItem.ccrz__Order__r.ccrz__ShipAmount__c != null){
                                lines.shippingCharges = oItem.ccrz__Order__r.ccrz__ShipAmount__c;
                            }else{
                                lines.shippingCharges = 0;
                            }
                            
                            if(oItem.Vertex_Tax__c != null){
                                lines.taxAmount = oItem.Vertex_Tax__c;
                            }else{
                                lines.taxAmount = 0.00;
                            }
                            //Added on 20thApril2021
                            lines.unitOfMeasure = oItem.ccrz__Product__r.ccrz__UnitOfMeasure__c;
                            if(oItem.ccrz__Product__r.ccrz__Quantityperunit__c != null)
                                lines.quantityPerUnit = String.valueOf(oItem.ccrz__Product__r.ccrz__Quantityperunit__c);
                            //end
                            //lines.taxAmount = oItem.Vertex_Tax__c;
                            //lines.taxClassificationCode = 'Tax Group';
                            if(oItem.ccrz__Product__r.ccrz__TaxRateId__c != null){
                                lines.taxClassificationCode = oItem.ccrz__Product__r.ccrz__TaxRateId__c;
                            }
                            //lines.fulfillmentLocationCode = 'F2';//hardcoded
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US') && oItem.dbu_isShipTo__c){
                                lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_US;
                            }else if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA') && (oItem.dbu_isShipTo__c)){
                                lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_CA;
                            }
                            if(!oItem.dbu_isShipTo__c){
                                lines.fulfillmentLocationCode = oItem.ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c;
                            }
                            lines.shipToDistributor = shipToDistributorList;
                            // New Inventory changes
                            if(oItem.dbu_isShipTo__c){
                               lines.shipToCustomer = shipToCustomerList;
                                   }else{
                                       lines.shipToCustomer = pickFromCustomerList;
                                   }
                           // lines.shipToCustomer = shipToCustomerList;
                            
                            linesList.add(lines);
                            
                        }
                    }
                }
                System.debug('linesList=>'+linesList);
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.BillToCustomer billToCustomer = new dbu_Integration_OrderSubmit.BillToCustomer();
                billToCustomer.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
                billToCustomer.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
                billToCustomer.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
                billToCustomer.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
                billToCustomer.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    billToCustomer.country = 'US';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    billToCustomer.country ='CA';
                }
                if(orderDetails[0].ccrz__BillTo__r !=null && String.isNotBlank((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c))){
                    //billToCustomer.postalCode = (orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                    if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                        if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                            billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                        }else{
                            billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                        }
                    }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                        
                        billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }
                billToCustomer.partyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                billToCustomer.contactNumber = orderDetails[0].ccrz__BuyerPhone__c;//CHG0083792
                List<dbu_Integration_OrderSubmit.BillToCustomer> billToCustomerList = new List<dbu_Integration_OrderSubmit.BillToCustomer>();
                billToCustomerList.add(billToCustomer);
                
                
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.BuyingPartyAddress buyingPartyAddress = new dbu_Integration_OrderSubmit.BuyingPartyAddress();
                buyingPartyAddress.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
                buyingPartyAddress.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
                buyingPartyAddress.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
                buyingPartyAddress.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
                buyingPartyAddress.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    buyingPartyAddress.country = 'US';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    buyingPartyAddress.country ='CA';
                }
                if(orderDetails[0].ccrz__BillTo__r != null && String.isNotBlank(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c)){
                    if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                        if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                            buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                        }else{
                            buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                        }
                    }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                        
                        buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }
                
                
                List<dbu_Integration_OrderSubmit.BuyingPartyAddress> buyingPartyAddressList = new List<dbu_Integration_OrderSubmit.BuyingPartyAddress>();
                buyingPartyAddressList.add(buyingPartyAddress);
                
                
                orderSubmitRequestData = new dbu_Integration_OrderSubmit.OrderSubmitRequestData();
                orderSubmitRequestData.buyingPartyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                orderSubmitRequestData.buyingPartyNumber = '';
                orderSubmitRequestData.buyingPartyEmailID = orderDetails[0].ccrz__BuyerEmail__c;
                orderSubmitRequestData.buyingPartyAddress = buyingPartyAddressList;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    orderSubmitRequestData.distributorCode = '02930';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    orderSubmitRequestData.distributorCode = '56270';
                }
                //orderSubmitRequestData.distributorCode = '';
                if(orderDetails[0].DBU_Customer_BMS_Number__c!=null)
            orderSubmitRequestData.customerCode=orderDetails[0].DBU_Customer_BMS_Number__c;
                orderSubmitRequestData.destinationTransactionSystem = 'BMS';
                orderSubmitRequestData.orderNumber =orderDetails[0].Name;
                //Added new fields 20thApril2021
                orderSubmitRequestData.cartId =orderDetails[0].ccrz__OriginatedCart__c;
               //Ramesh CHG0112651 start
               if(orderDetails[0].ccrz__TransactionPayments__r != null && orderDetails[0].ccrz__TransactionPayments__r.size() > 0){
                if(orderDetails[0].ccrz__PaymentMethod__c == 'credit card'){
                    orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionCode__c;
                }else {
                orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionSubcode__c;
                }
        }
     //Ramesh CHG0112651END
     //end
                orderSubmitRequestData.sourceTransactionSystem = 'CSSNA ECOM';
                orderSubmitRequestData.status = orderDetails[0].ccrz__OrderStatus__c;
                orderSubmitRequestData.submittedDate = String.ValueOf(orderDetails[0].ccrz__OrderDate__c);
                // New inventory Changes
                //if(orderDetails[0].ccrz__ShipMethod__c =='Ship To Address' || orderDetails[0].ccrz__ShipMethod__c =='Adresse d\'expédition'){
                    //orderSubmitRequestData.shippingMode = 'SHIP';
               // }else if(orderDetails[0].ccrz__ShipMethod__c =='Pick Up' || orderDetails[0].ccrz__ShipMethod__c =='Ramassage'){
                   // orderSubmitRequestData.shippingMode = 'PICK';
                //}
                orderSubmitRequestData.shippingMode = '';
                if(orderDetails[0].ccrz__PaymentMethod__c =='credit card'){
                    orderSubmitRequestData.paymentType = 'Card';
                }else if(orderDetails[0].ccrz__PaymentMethod__c =='PayPal'){
                    orderSubmitRequestData.paymentType = 'PayPal';
                }
                //orderSubmitRequestData.paymentType = 'Card'; // Its temporary fix for Submit Order
                if(orderDetails[0].ccrz__TotalAmount__c != null){
                    orderSubmitRequestData.totalOrderAmount = orderDetails[0].ccrz__TotalAmount__c;
                }else{
                    orderSubmitRequestData.totalOrderAmount = 0.00;
                }
                if(orderDetails[0].ccrz__TaxAmount__c != null){
                    orderSubmitRequestData.totalTaxAmount = orderDetails[0].ccrz__TaxAmount__c;
                }else{
                    orderSubmitRequestData.totalTaxAmount = 0.00;
                }
                orderSubmitRequestData.billToCustomer = billToCustomerList;
                orderSubmitRequestData.lines = linesList;
                System.debug('orderSubmitRequestData=>'+orderSubmitRequestData);
                System.debug('JSON.serialize(orderSubmitRequestData)\t'+JSON.serialize(orderSubmitRequestData));
                Long reqTime = DateTime.now().getTime();
                response =  dbu_Integration_OrderSubmit.getOrderStatus(orderSubmitRequestData);
                Long respTime = DateTime.now().getTime();
                long milliSeconds = respTime-reqTime ;
                mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                String req=JSON.serialize(orderSubmitRequestData);
                System.debug('Response===>'+response);
                if(response.Status.equalsIgnoreCase('SUCCESS')){
                    obj.dbu_SubmitOrder_Success__c=True;
                    dbu_Integration_Error_Log.createErrorLog(200,mSec,req,Json.serialize(response),'Order Submit Service','Success');
                }
                /*Here going to update the status of OrderItem*/
                
                List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = mapOrderItemList.get(orderId);
                if(lstOrderItemToUpdate != null && lstOrderItemToUpdate.size() > 0){
                    for(ccrz__E_OrderItem__c ordItem : lstOrderItemToUpdate){
                        
                        if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('submit')){
                            ordItem.ccrz__OrderItemStatus__c = 'Order Submitted';
                        }
                        
                    }
                    if(lstOrderItemToUpdate.Size()>0){
                        update lstOrderItemToUpdate;
                    }
                    
                    if(obj.id != null){
                        update obj;
                    }
                }
                /*end here*/
                
            }catch(Exception ex){
                /*List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = mapOrderItemList.get(orderid);
if(lstOrderItemToUpdate != null && lstOrderItemToUpdate.size() > 0){
for(ccrz__E_OrderItem__c ordItem : lstOrderItemToUpdate){
////////////
if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('N')){
ordItem.ccrz__OrderItemStatus__c = 'Return Initiated';
//ordItem.dbu_Selected_Return_Items__c= False;
}
}
update lstOrderItemToUpdate;
}*/
                system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
            }
        }
        return response;
    }
    @future(callout=true)
    public static void retunOrderItemsDetails(Id orderid, Id originalOrderId){
        
        dbu_Integration_OrderSubmit.OrderSubmitRequestData  orderSubmitRequestData;
        dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response;
        List<ccrz__E_Order__c> orderDetails = New List<ccrz__E_Order__c>();
        ccrz__E_Order__c obj =new ccrz__E_Order__c();
        Boolean shippingMethod =False;
        string dropOffLoc;
        string mSec;
         //Ramesh Added the SOQL ccrz__TransactionCode__c
        //Ramesh Added the SOQL ccrz__SubAmount__c 
        Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
        orderDetails =[Select id, name,ccrz__BuyerPhone__c,DBU_Customer_BMS_Number__c, ccrz__OrderStatus__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,dbu_Shipto__c,ccrz__ShipMethod__c,CC_Order__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
                       ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
                       ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
                       ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
                       (Select id,Name,ccrz__Product__c,dbu_Dropoff_Location__c,ccrz__Price__c,dbu_Shipto__c,dbu_Selected_Return_Items__c,dbu_StoreCode__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c,ccrz__SubAmount__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c where id=:orderid];
        System.debug('orderDetails--->>'+orderDetails);

        List<string> originalIdList = new List<string>();
        List<string> orderIdList = new List<string>();

        for (ccrz__E_Order__c orderDeta: orderDetails) {
            if (orderDeta.ccrz__E_OrderItems__r != null) {
                mapOrderItemList.put(orderDeta.id, orderDeta.ccrz__E_OrderItems__r);
            }

  
            
            obj.id = orderDeta.Id;
            for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDeta.id)){

                if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c == true && oItem.ccrz__Product__r.dbu_Has_Core_Child__c == false)
                {
                    originalIdList.add(oItem.ccrz__Product__r.id);
                }
                else if(oItem.ccrz__Product__r.dbu_Has_Core_Child__c == true)
                {
                    orderIdList.add(oItem.ccrz__Product__r.id);
                }

                if(oItem.dbu_Shipto__c == True)
                {
                    shippingMethod=True;
                }
                else
                {
                    dropOffLoc=oItem.dbu_Dropoff_Location__c;
                }
                
                
            }
        }
        system.debug('mapOrderItemList--->>>' + mapOrderItemList);
        if(orderDetails.size()>0 && orderDetails != Null){
            try{ 
                dbu_Integration_OrderSubmit.ShipToCustomer shipToCustomer = new dbu_Integration_OrderSubmit.ShipToCustomer();
                if(shippingMethod){
                    shipToCustomer.address1 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                    shipToCustomer.address2 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                    shipToCustomer.address3 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                    shipToCustomer.city =orderDetails[0].ccrz__ShipTo__r.ccrz__City__c;
                    shipToCustomer.state =orderDetails[0].ccrz__ShipTo__r.ccrz__State__c;
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                        shipToCustomer.country ='US';
                    }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                        shipToCustomer.country ='CA';
                    }
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c != null){
                        //shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                        //6th Feb Changed by Shri Ram 
                        if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).length() >= 5){
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                            }else{
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                            }
                        }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                            
                            shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                            
                        }
                    }
                }else{
                    List<String> commaSaparate = dropOffLoc.split(',');
                    if(commaSaparate[2] != Null){
                        shipToCustomer.address1 =commaSaparate[2];
                    }
                    shipToCustomer.address2 ='';
                    shipToCustomer.address3 ='';
                    if(commaSaparate[1] != Null)
                        shipToCustomer.city =commaSaparate[1];
                    if(commaSaparate[3] != Null)
                        shipToCustomer.state =commaSaparate[3];
                    if(commaSaparate[4] != Null){
                        if(commaSaparate[4] == 'United States' || commaSaparate[4] == 'US' || commaSaparate[4] == 'U.S.A' || commaSaparate[4] == 'U.S.A.'){
                            shipToCustomer.country ='US';
                        }else if(commaSaparate[4] == 'Canada' || commaSaparate[4] == 'CA'){
                            shipToCustomer.country ='CA';
                        }
                    }
                    
                    if(commaSaparate[5] != null){
                        if(commaSaparate[4] == 'United States' || commaSaparate[4] == 'US' || commaSaparate[4] == 'U.S.A' || commaSaparate[4] == 'U.S.A.'){
                            if((commaSaparate[5]).length() > 5){
                                shipToCustomer.postalCode =(commaSaparate[5]).substring(0,5);
                            }else{
                                shipToCustomer.postalCode =commaSaparate[5];
                            }
                        }else if(commaSaparate[4] == 'Canada' || commaSaparate[4] == 'CA'){
                            
                            shipToCustomer.postalCode =commaSaparate[5];
                        }
                    }
                }
                shipToCustomer.partyName =orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                
                List<dbu_Integration_OrderSubmit.ShipToCustomer> shipToCustomerList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();
                shipToCustomerList.add(shipToCustomer);
                
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.ShipToDistributor shipToDistributor = new  dbu_Integration_OrderSubmit.ShipToDistributor();
                shipToDistributor.address1 = orderDetails[0].ccrz__Account__r.BillingStreet;
                shipToDistributor.address2 = orderDetails[0].ccrz__Account__r.CMI_Address2__c;
                shipToDistributor.address3 = orderDetails[0].ccrz__Account__r.CMI_Address3__c;
                shipToDistributor.city = orderDetails[0].ccrz__Account__r.BillingCity;
                shipToDistributor.state = orderDetails[0].ccrz__Account__r.BillingState;
                if(orderDetails[0].ccrz__Account__r.BillingCountry =='United States' || orderDetails[0].ccrz__Account__r.BillingCountry =='US'){
                    shipToDistributor.country = 'US';
                }else if(orderDetails[0].ccrz__Account__r.BillingCountry =='Canada' || orderDetails[0].ccrz__Account__r.BillingCountry =='CA'){
                    shipToDistributor.country = 'CA';
                }
                shipToDistributor.postalCode = orderDetails[0].ccrz__Account__r.BillingPostalCode;
                shipToDistributor.partyName = orderDetails[0].ccrz__Account__r.Name;
                List<dbu_Integration_OrderSubmit.ShipToDistributor> shipToDistributorList = new List<dbu_Integration_OrderSubmit.ShipToDistributor>();
                shipToDistributorList.add(shipToDistributor);
                
                // need to create objects depends on the method input parameter dynamically
                //dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
                List<dbu_Integration_OrderSubmit.Lines> linesList = new List<dbu_Integration_OrderSubmit.Lines>();
                List<String>  orderListForShipping = new List<String>();
                list<String> orderItemIdsForShipping = new List<String>();

                system.debug('mapOrderItemList.keyset() :: '+mapOrderItemList.keyset());

                //CECI - 757 Starts

                //idMap is to hold the product ID and related product ID
                map<string, string> idMap = new map<string, string>();
                List<string>strList = new List<string>();

                List<ccrz__E_Product__c> productList = [select id, name, (select id, ccrz__Product__c from ccrz__E_RelatedProducts1__r where ccrz__Product__c IN :originalIdList) from ccrz__E_Product__c where id IN :orderIdList];
                for(ccrz__E_Product__c product : productList) 
                {
                   if(product.ccrz__E_RelatedProducts1__r.size() == 0)
                    {
                        idMap.put(product.id, null);
                    }

                    else
                    {
                        for(ccrz__E_RelatedProduct__c relatedProduct : product.ccrz__E_RelatedProducts1__r)
                        {
                            idMap.put(product.id, relatedProduct.id);
                        }
                    }
                }
                //CECI - 757 Ends
                
                if(mapOrderItemList.keyset() != null && mapOrderItemList.size() > 0){
                    for (ccrz__E_Order__c orderDetail: orderDetails) {
                        orderListForShipping.add(orderDetail.Id);
                        for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDetail.id)){
                            dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
                            orderItemIdsForShipping.add(oItem.Id);
                            lines.lineId = oItem.Name;
                            lines.orderedQuantity = Integer.ValueOf(oItem.ccrz__Quantity__c);

                           /*if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c == True && oItem.ccrz__Product__r.dbu_Has_Core_Child__c == False)
                            {
                                lines.orderReturnFlag = 'C';
                                lines.productCode = oItem.ccrz__Product__r.dbu_Product_Code__c;     //'CLEAN';    //new
                            }

                            else if(oItem.ccrz__Product__r.dbu_Has_Core_Child__c == True)
                            {
                                lines.orderReturnFlag = 'N';
                                if(idMap.get(oItem.ccrz__Product__r.id) == null)
                                {
                                    lines.productCode = 'DIRTY';
                                }

                                else
                                {
                                    lines.productCode = 'CLEAN';
                                }
                            }

                            else
                            {
                                lines.productCode = oItem.ccrz__Product__r.dbu_Product_Code__c;
                                lines.orderReturnFlag = 'N';
                            } */
                            if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c == True){	
                                lines.orderReturnFlag = 'C';	
                            }else{	
                                lines.orderReturnFlag = 'N';	
                            }	
                            if(oItem.ccrz__Product__r.dbu_Product_Code__c != Null){
                                lines.productCode = oItem.ccrz__Product__r.dbu_Product_Code__c;	
                            }
                            // CECI-757 send Dirty as Code for only core charge product  - START - 
                            if(oItem.ccrz__Product__r.dbu_Has_Core_Child__c == True){
                                if(idMap.get(oItem.ccrz__Product__r.id) == null)
                                    {
                                        lines.productCode = 'DIRTY';
                                    }
                            }
                            // CECI-757 send Dirty as Code for only core charge product  - END - 
                            //else{
                            //   lines.productCode = 'CECO'; // Its temporary fix for Submit Order
                            //}
                            lines.shippingMode = '';
                            lines.partNumber = oItem.ccrz__Product__r.dbu_Part_Number__c;
                            if(oItem.ccrz__Price__c != null){
                                 //Ramesh CHG0111237 Reverted
                                 lines.unitSellingPrice = oItem.ccrz__Price__c;
                                 system.debug('oItem11--->>>'+ lines.unitSellingPrice);
                                 //Ramesh CHG0111237 Reverted.
                            }else{
                                lines.unitSellingPrice = 0.00;
                            }
                            if(oItem.dbu_Shipto__c == True){
                                lines.deliveryMethod = 'SHIP';  
                            }else 
                                lines.deliveryMethod = 'PICK';//HardCode
                            
                            lines.unitDiscount = 0.0;
                            if(oItem.ccrz__AbsoluteDiscount__c != null){
                                lines.couponDiscount = oItem.ccrz__AbsoluteDiscount__c;
                            }else{
                                lines.couponDiscount = 0;
                            }
                            
                            lines.shippingCharges = 0;
                            
                            /* if(oItem.ccrz__Order__r.ccrz__ShipAmount__c != null){
lines.shippingCharges = oItem.ccrz__Order__r.ccrz__ShipAmount__c;
}else{
lines.shippingCharges = 0;
}*/
                            
                            if(oItem.Vertex_Tax__c != null){
                                lines.taxAmount = oItem.Vertex_Tax__c;
                            }else{
                                lines.taxAmount = 0.00;
                            }
                            //Added on 20thApril2021
                            lines.unitOfMeasure = oItem.ccrz__Product__r.ccrz__UnitOfMeasure__c;
                            if(oItem.ccrz__Product__r.ccrz__Quantityperunit__c != null)
                                lines.quantityPerUnit = String.valueOf(oItem.ccrz__Product__r.ccrz__Quantityperunit__c);
                            //end
                            //lines.taxAmount = oItem.Vertex_Tax__c;
                            //lines.taxClassificationCode = 'Tax Group';
                            if(oItem.ccrz__Product__r.ccrz__TaxRateId__c != null){
                                lines.taxClassificationCode = oItem.ccrz__Product__r.ccrz__TaxRateId__c;
                            }
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US') && oItem.dbu_Shipto__c == True){
                                lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_US;
                            }else if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA') && oItem.dbu_Shipto__c == True){
                                lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_CA;
                            }else if(oItem.dbu_Shipto__c == False){
                                lines.fulfillmentLocationCode = oItem.dbu_StoreCode__c;
                            }
                            //lines.fulfillmentLocationCode = 'F2';//hardcoded
                            lines.shipToDistributor = shipToDistributorList;
                            lines.shipToCustomer = shipToCustomerList;
                            
                            linesList.add(lines);
                        }
                    }
                }
                System.debug('linesList=>'+linesList);
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.BillToCustomer billToCustomer = new dbu_Integration_OrderSubmit.BillToCustomer();
                billToCustomer.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
                billToCustomer.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
                billToCustomer.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
                billToCustomer.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
                billToCustomer.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    billToCustomer.country = 'US';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    billToCustomer.country ='CA';
                }
                if(orderDetails[0].ccrz__BillTo__r !=null && String.isNotBlank((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c))){
                    
                    if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                        if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                            billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                        }else{
                            billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                        }
                    }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                        
                        billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }
                billToCustomer.partyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                billToCustomer.contactNumber = orderDetails[0].ccrz__BuyerPhone__c;//CHG0083792
                List<dbu_Integration_OrderSubmit.BillToCustomer> billToCustomerList = new List<dbu_Integration_OrderSubmit.BillToCustomer>();
                billToCustomerList.add(billToCustomer);
                
                
                // need to create objects depends on the method input parameter dynamically
                dbu_Integration_OrderSubmit.BuyingPartyAddress buyingPartyAddress = new dbu_Integration_OrderSubmit.BuyingPartyAddress();
                buyingPartyAddress.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
                buyingPartyAddress.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
                buyingPartyAddress.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
                buyingPartyAddress.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
                buyingPartyAddress.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    buyingPartyAddress.country = 'US';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    buyingPartyAddress.country ='CA';
                }
                if(orderDetails[0].ccrz__BillTo__r != null && String.isNotBlank(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c)){
                    //buyingPartyAddress.postalCode = (orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                    if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                        if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                            buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                        }else{
                            buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                        }
                    }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                        
                        buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }
                
                List<dbu_Integration_OrderSubmit.BuyingPartyAddress> buyingPartyAddressList = new List<dbu_Integration_OrderSubmit.BuyingPartyAddress>();
                buyingPartyAddressList.add(buyingPartyAddress);
                
                
                orderSubmitRequestData = new dbu_Integration_OrderSubmit.OrderSubmitRequestData();
                orderSubmitRequestData.buyingPartyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                orderSubmitRequestData.buyingPartyNumber = '';
                orderSubmitRequestData.buyingPartyEmailID = orderDetails[0].ccrz__BuyerEmail__c;
                orderSubmitRequestData.buyingPartyAddress = buyingPartyAddressList;
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    orderSubmitRequestData.distributorCode = '02930';
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    orderSubmitRequestData.distributorCode = '56270';
                }
                if(orderDetails[0].DBU_Customer_BMS_Number__c!=null)
            orderSubmitRequestData.customerCode=orderDetails[0].DBU_Customer_BMS_Number__c;
                //orderSubmitRequestData.distributorCode = '';
                orderSubmitRequestData.destinationTransactionSystem = 'BMS';
                orderSubmitRequestData.orderNumber = orderDetails[0].Name;
                //Added new fields 20thApril2021
                orderSubmitRequestData.cartId =orderDetails[0].ccrz__OriginatedCart__c;
                //Ramesh CHG0112651 start
                if(orderDetails[0].ccrz__TransactionPayments__r != null && orderDetails[0].ccrz__TransactionPayments__r.size() > 0){
                    if(orderDetails[0].ccrz__PaymentMethod__c == 'credit card'){
                        orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionCode__c;
                    }else {
                    orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionSubcode__c;
                    }
                    }
                    //Ramesh CHG0112651END
                    //end
                orderSubmitRequestData.sourceTransactionSystem = 'CSSNA ECOM';
                orderSubmitRequestData.status = orderDetails[0].ccrz__OrderStatus__c;
                orderSubmitRequestData.submittedDate = String.ValueOf(orderDetails[0].ccrz__OrderDate__c);
                //orderSubmitRequestData.shippingMode = 'SHIP';//orderDetails[0].ccrz__ShipMethod__c; Its temporary fix
                if(shippingMethod){
                    orderSubmitRequestData.shippingMode = 'SHIP';
                }else{
                    orderSubmitRequestData.shippingMode = 'PICK';
                }
                if(orderDetails[0].ccrz__PaymentMethod__c =='credit card'){
                    orderSubmitRequestData.paymentType = 'Card';
                }else if(orderDetails[0].ccrz__PaymentMethod__c =='PayPal'){
                    orderSubmitRequestData.paymentType = 'PayPal';
                }
                if(orderDetails[0].ccrz__TotalAmount__c != null){
                    orderSubmitRequestData.totalOrderAmount = orderDetails[0].ccrz__TotalAmount__c;
                }else{
                    orderSubmitRequestData.totalOrderAmount = 0.00;
                }
                if(orderDetails[0].ccrz__TaxAmount__c != null){
                    orderSubmitRequestData.totalTaxAmount = orderDetails[0].ccrz__TaxAmount__c;
                }else{
                    orderSubmitRequestData.totalTaxAmount = 0.00;
                }
                orderSubmitRequestData.billToCustomer = billToCustomerList;
                orderSubmitRequestData.lines = linesList;
                System.debug('orderSubmitRequestData=>'+orderSubmitRequestData);
                System.debug('JSON.serialize(orderSubmitRequestData)\t'+JSON.serialize(orderSubmitRequestData));
                String dbuLocationCode;
                String req=JSON.serialize(orderSubmitRequestData);
                Long reqTime = DateTime.now().getTime();
                response =  dbu_Integration_OrderSubmit.getOrderStatus(orderSubmitRequestData);
               Long respTime = DateTime.now().getTime();
                long milliSeconds = respTime-reqTime ;
                mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                if(response.Status.equalsIgnoreCase('SUCCESS')){
                    obj.dbu_SubmitOrder_Success__c=True;
                    dbuLocationCode = response.locationCode;
                    //dbuLocationCode = 'A2';
                    dbu_Integration_ShipStation.getShipStation(orderListForShipping,orderItemIdsForShipping,dbuLocationCode);
                    dbu_Integration_Error_Log.createErrorLog(200,mSec,req,Json.serialize(response),'Order Submit Service','Success');
                }
                System.debug('Response===>'+response);
                
                System.debug('dbuLocationCode===>'+dbuLocationCode);
                
                // String dbuLocationCode='A2';
                List<dbu_Store_Location__c> storeLocation = new List<dbu_Store_Location__c>();
                storeLocation=[Select id,name,dbu_City__c,dbu_Country__c,dbu_State__c,dbu_StoreCode__c,dbu_Street__c,dbu_ZipCode__c from dbu_Store_Location__c where dbu_StoreCode__c=:dbuLocationCode limit 1];
                if(storeLocation.size()>0){
                    obj.dbu_StoreLocationAddress__c = storeLocation[0].dbu_Street__c+','+storeLocation[0].dbu_City__c+','+storeLocation[0].dbu_State__c+','+storeLocation[0].dbu_ZipCode__c+','+storeLocation[0].dbu_Country__c;
                    if(obj.id != null){
                        update obj; 
                    }
                }
            }catch(Exception ex){
                system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
           }
        }
        //return response;
    }
    
    @AuraEnabled
    public static String partialReturnOrder(List<Object> orderData ,String addInfo, String estimatedReturnAmount, String orderId,String storeLanguage){
        System.debug('estimatedReturnAmount===='+ estimatedReturnAmount);
        system.debug('returnOrderItems---->>' + orderData);
        List<returnOrderItemsWrp> ordrItemList = new List<returnOrderItemsWrp>();
        Set<Id> ordrItmIds = new Set<Id>();
        Decimal totalVertaxTax=0.00;
        Decimal priceToBeReduced=0.00;
        Decimal handlingFee=0.00;
        Map<Id,ccrz__E_OrderItem__c> ordrItmMap;
        List<ccrz__E_OrderItem__c> ordItmsUpdt = new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> ordItmsInst = new List<ccrz__E_OrderItem__c>();
        for(Object obj:orderData){
            Map<Object,Object> data = (Map<Object,Object>)obj;
            returnOrderItemsWrp ordItm = (returnOrderItemsWrp)System.JSON.deserialize(JSON.serialize(data), returnOrderItemsWrp.class);
            ordrItemList.add(ordItm);
            if(ordItm.sfid!=Null && !ordrItmIds.contains(ordItm.sfid))
                ordrItmIds.add(ordItm.sfid);
            
        }
        List<ccrz__E_OrderItem__c> orderItemsUpdt = new List<ccrz__E_OrderItem__c>();
        if(test.isRunningTest()){
            orderItemsUpdt=[Select id,Name from ccrz__E_OrderItem__c limit 100];
            ccrz__E_Order__c ordId=[Select id,Name from ccrz__E_Order__c limit 1];
            for(ccrz__E_OrderItem__c ordItem:orderItemsUpdt){
                ordrItmIds.add(ordItem.id);
            }
            returnOrderItemsWrp returnOrdWrp = new returnOrderItemsWrp();
            returnOrdWrp.quantity ='1';
            returnOrdWrp.price ='122.20';
            returnOrdWrp.orderId =ordId.id;
            returnOrdWrp.sfid =orderItemsUpdt[0].id;
            returnOrdWrp.returnReason ='Damaged in shipping';
            returnOrdWrp.returnQuantity ='1';
            returnOrdWrp.handlingFee ='22';
            ordrItemList.add(returnOrdWrp);
        }
        for(ccrz__E_OrderItem__c orderItms:[Select Id,ccrz__Order__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c Where ccrz__Order__c =: orderId AND ccrz__OrderItemStatus__c=Null]){
            orderItms.ccrz__OrderItemStatus__c='Abandoned';
            orderItms.dbu_Selected_Return_Items__c = False;
            orderItemsUpdt.add(orderItms);
        }
        if(orderItemsUpdt.size()>0){
            Update orderItemsUpdt;
        }
        
        Set<Id> orgOrderItemIds = new Set<Id>();
        
        if(ordrItmIds!=Null && !ordrItmIds.IsEmpty())
            ordrItmMap = new Map<Id,ccrz__E_OrderItem__c>([Select Id,ccrz__Order__c,ccrz__Price__c,ccrz__Quantity__c,ccrz__SubAmount__c,ccrz__RequestDate__c,ccrz__OrderLineType__c,ccrz__PricingType__c,ccrz__ProductType__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Order__r.dbu_Days_Since_Order_Date__c,
                                                           ccrz__Product__c,dbu_Reason_for_Return__c,dbu_Is_Returned__c,ccrz__StoreId__c,Vertex_Tax__c,ccrz__ItemStatus__c,ccrz__UnitOfMeasure__c,ccrz__OriginalQuantity__c,ccrz__OriginalItemPrice__c,ccrz__Order__r.ccrz__CurrencyISOCode__c, ccrz__OrderItemId__c
                                                           from ccrz__E_OrderItem__c Where Id IN : ordrItmIds]);
        for(returnOrderItemsWrp ordrItm : ordrItemList){
            
            if(ordrItm.sfid!=Null && ordrItmMap.containsKey(ordrItm.sfid)){
                ccrz__E_OrderItem__c retrnItem;
                ccrz__E_OrderItem__c orderItm = ordrItmMap.get(ordrItm.sfid);
                orgOrderItemIds.add(orderItm.Id); // adding original orderitemids
                System.debug('====Country CODE===='+ordrItmMap.get(ordrItm.sfid).ccrz__Order__r.ccrz__CurrencyISOCode__c);
                String currencyCode = ordrItmMap.get(ordrItm.sfid).ccrz__Order__r.ccrz__CurrencyISOCode__c;
                retrnItem = orderItm.clone(false, true, false, false);
                retrnItem.CurrencyIsoCode = currencyCode;
                retrnItem.ccrz__Quantity__c = Integer.valueOf(ordrItm.returnQuantity);
                // retrnItem.dbu_Is_Returned__c = true;
                retrnItem.dbu_Reason_for_Return__c = ordrItm.returnReason ;
                retrnItem.dbu_Return_Additional_Information__c = addInfo;
                retrnItem.dbu_Selected_Return_Items__c = True;
                retrnItem.dbu_store_language__c= storeLanguage;
                System.debug('order item ==========='+ordrItm);
                System.debug('item Price==========='+ordrItm.price);
                if(currencyCode == 'USD'){
                    retrnItem.ccrz__SubAmount__c = Decimal.valueOf((ordrItm.price).removeStartIgnoreCase('$'))*Integer.valueOf(ordrItm.returnQuantity);
                    retrnItem.ccrz__AdjustmentAmount__c = -Decimal.valueOf((ordrItm.price).removeStartIgnoreCase('$'))*Integer.valueOf(ordrItm.returnQuantity);
                }else if(currencyCode == 'CAD'){
                    retrnItem.ccrz__SubAmount__c = Decimal.valueOf((ordrItm.price).removeStartIgnoreCase('CAD $'))*Integer.valueOf(ordrItm.returnQuantity);
                    retrnItem.ccrz__AdjustmentAmount__c = -Decimal.valueOf((ordrItm.price).removeStartIgnoreCase('CAD $'))*Integer.valueOf(ordrItm.returnQuantity); 
                }
                System.debug('retrnItem.ccrz__AdjustmentAmount__c ::: '+retrnItem.ccrz__AdjustmentAmount__c);
                if(orderItm.ccrz__Product__r.dbu_Has_Core_Charge__c == True && orderItm.ccrz__Order__r.dbu_Days_Since_Order_Date__c > 45 && orderItm.ccrz__Order__r.dbu_Days_Since_Order_Date__c <= Integer.valueOf(System.Label.dbu_CoreOrderDays)){
                    if(orderItm.Vertex_Tax__c != Null){
                        totalVertaxTax  = Integer.valueOf(ordrItm.returnQuantity)*(orderItm.Vertex_Tax__c / orderItm.ccrz__Quantity__c);
                        if(currencyCode == 'USD'){
                            priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$')));  
                        }else if(currencyCode == 'CAD'){
                            priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $')));
                        }
                        
                        handlingFee = (priceToBeReduced / 100) * 10;
                        retrnItem.dbu_Estimated_Return_Amount__c = (priceToBeReduced - handlingFee) + totalVertaxTax;
                    }else{
                        if(currencyCode == 'USD'){
                            priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$'))); 
                        }else if(currencyCode == 'CAD'){
                            priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $')));
                        }
                        
                        handlingFee = (priceToBeReduced / 100) * 10;
                        retrnItem.dbu_Estimated_Return_Amount__c = (priceToBeReduced - handlingFee);
                    }
                }else{
                    if(ordrItm.returnReason == System.Label.dbu_Return_Part_no_longer_wanted || ordrItm.returnReason == System.Label.dbu_Return_Ordered_the_wrong_part){
                        if (orderItm.Vertex_Tax__c != Null) {
                            totalVertaxTax  = Integer.valueOf(ordrItm.returnQuantity)*(orderItm.Vertex_Tax__c / orderItm.ccrz__Quantity__c);
                            if(currencyCode == 'USD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$'))); 
                            }else if(currencyCode == 'CAD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $')));
                            }
                            
                        }else{
                            if(currencyCode == 'USD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$'))); 
                            }else if(currencyCode == 'CAD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $')));
                            }
                            
                        }
                        handlingFee = (priceToBeReduced / 100) * 15;
                        retrnItem.dbu_Estimated_Return_Amount__c = (priceToBeReduced - handlingFee) + totalVertaxTax;
                    }else{
                        if (orderItm.Vertex_Tax__c != Null) {
                            totalVertaxTax  = Integer.valueOf(ordrItm.returnQuantity)*(orderItm.Vertex_Tax__c / orderItm.ccrz__Quantity__c);
                            if(currencyCode == 'USD'){
                                priceToBeReduced = (Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$'))))+totalVertaxTax; 
                            }else if(currencyCode == 'CAD'){
                                priceToBeReduced = (Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $'))))+totalVertaxTax;
                            }
                            
                        }else{
                            if(currencyCode == 'USD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('$'))); 
                            }else if(currencyCode == 'CAD'){
                                priceToBeReduced = Integer.valueOf(ordrItm.returnQuantity)* Decimal.valueOf(((ordrItm.price).removeStartIgnoreCase('CAD $')));
                            }
                            
                        }
                        retrnItem.dbu_Estimated_Return_Amount__c = priceToBeReduced;
                    }
                }
                //retrnItem.dbu_Estimated_Return_Amount__c = Decimal.valueOf(estimatedReturnAmount);
                retrnItem.dbu_Return_Tax__c = totalVertaxTax;
                retrnItem.dbu_Return_Amount__c = retrnItem.dbu_Estimated_Return_Amount__c - totalVertaxTax;
                ordItmsInst.add(retrnItem);
                
                /*if(ordrItm.quantity ==ordrItm.returnQuantity){
orderItm.dbu_Reason_for_Return__c = ordrItm.returnReason;
orderItm.dbu_Return_Additional_Information__c = addInfo;
orderItm.dbu_Selected_Return_Items__c = True;

}*/
                
                //ordItmsUpdt.add(orderItm);
            }
            
        }
        
        if(ordItmsInst!=Null && !ordItmsInst.IsEmpty())
            Database.Insert(ordItmsInst);
        
        //-----------------
        List<CC_Tax__c> ccTaxList = new List<CC_Tax__c>();
        Map<String,ccrz__E_OrderItem__c> cloneLineItemIdMap = new  Map<String,ccrz__E_OrderItem__c>();
        List<CC_Tax__c> listCCTaxRecords =  [SELECT Id,dbu_Is_Shipping_Tax__c,JurisdictionId__c,JurisdictionValue__c,Situs__c,Taxable__c,ImpositionTypeId__c,EffectiveRate__c,ImpositionId__c,ImpositionTypevalue__c,JurisdictionLevel__c,TaxCollectedFromParty__c,TaxResult__c,TaxType__c,ImpositionValue__c,CalculatedTax__c,CC_Order_Item__c,CC_Order_Item__r.ccrz__OrderItemId__c 
                                             FROM CC_Tax__c WHERE CC_Order_Item__c IN : orgOrderItemIds AND dbu_Is_Shipping_Tax__c = false];
        List<ccrz__E_OrderItem__c> cloneLineItems = [SELECT Id,ccrz__OrderItemId__c,ccrz__OriginalQuantity__c,ccrz__Quantity__c FROM ccrz__E_OrderItem__c  Where ccrz__Order__c =: orderId AND ccrz__OrderItemStatus__c=Null];
        for(ccrz__E_OrderItem__c lineItemObj : cloneLineItems){
            cloneLineItemIdMap.put(lineItemObj.ccrz__OrderItemId__c , lineItemObj);
        }
        for(CC_Tax__c taxInstance : listCCTaxRecords){
            if(cloneLineItemIdMap.containsKey(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c)){
                CC_Tax__c taxObj = new CC_Tax__c();
                taxObj.ImpositionValue__c = taxInstance.ImpositionValue__c;
                Decimal originalQty = cloneLineItemIdMap.get(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c).ccrz__OriginalQuantity__c;
                Decimal returnQty = cloneLineItemIdMap.get(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c).ccrz__Quantity__c;
                Decimal oneQtyTax = (Decimal.valueOf(taxInstance.CalculatedTax__c))/originalQty;
                System.debug('oneQtyTax===='+oneQtyTax);
                Decimal calculatedTax = (oneQtyTax * returnQty).setScale(2);
                 System.debug('calculatedTax===='+calculatedTax);
                taxObj.CalculatedTax__c = String.valueOf(calculatedTax);
                taxObj.CC_Order_Item__c = cloneLineItemIdMap.get(taxInstance.CC_Order_Item__r.ccrz__OrderItemId__c).Id;
                taxObj.JurisdictionId__c = taxInstance.JurisdictionId__c;
                taxObj.Situs__c = taxInstance.Situs__c;
                taxObj.Taxable__c = taxInstance.Taxable__c;
                taxObj.ImpositionTypeId__c = taxInstance.ImpositionTypeId__c;
                taxObj.EffectiveRate__c = taxInstance.EffectiveRate__c;
                taxObj.ImpositionId__c = taxInstance.ImpositionId__c;
                taxObj.JurisdictionLevel__c = taxInstance.JurisdictionLevel__c;
                taxObj.TaxCollectedFromParty__c = taxInstance.TaxCollectedFromParty__c;
                taxObj.ImpositionTypevalue__c = taxInstance.ImpositionTypevalue__c;
                taxObj.TaxResult__c = taxInstance.TaxResult__c;
                taxObj.TaxType__c = taxInstance.TaxType__c;
                
                ccTaxList.add(taxObj);
            }
        }
        System.debug('ccTaxList====='+ccTaxList.size());
        if(ccTaxList.size() > 0){
            insert ccTaxList;
        }
        //-----------------
        /*ccrz__E_Order__c record = new ccrz__E_Order__c();
record.Id = orderId;
record.dbu_Estimated_Return_Amount__c = Decimal.valueOf(estimatedReturnAmount);
if(record != null){
update record;

}   
if(ordItmsUpdt!=Null && !ordItmsUpdt.IsEmpty())
Database.Update(ordItmsUpdt);*/
        return Null;
    }
    
    //=== Added by Mukesh == for shipto and pickup radio button on return===
     @AuraEnabled
    public static returnOrderItemsWrp returnOrderItemsLocation(String urlParam){
        String orderId;
        System.debug('urlParam=====>'+urlParam);
        if(String.isNotBlank(urlParam)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            System.debug('?????????\t'+params.size());
            if(params.size() > 0 && params.containsKey('orderid')){
                orderId =  params.get('orderid');
            }
        } 
        System.debug('OrderId=====>'+orderId);
        
        List<ccrz__E_OrderItem__c> orderItemList = [SELECT Id,dbu_isShipTo__c,ccrz__OrderItemStatus__c FROM ccrz__E_OrderItem__c 
                                                    WHERE ccrz__Order__c =: orderId 
                                                    AND (ccrz__OrderItemStatus__c = 'Shipped' OR ccrz__OrderItemStatus__c = 'Available for Pickup')];
        returnOrderItemsWrp oitemWrap = new returnOrderItemsWrp();
        for(ccrz__E_OrderItem__c oItem : orderItemList ){
            if(oItem.dbu_isShipTo__c){
                oitemWrap.isShipTo = true;
            }else{
                oitemWrap.isPickupOnly = true;
            }
         }
        
        return oitemWrap;
    }
    
    
    
    public class returnOrderItemsWrp{
        public String quantity;
        public String price;
        public String orderId;
        public String sfid;
        public String returnReason;
        public String returnQuantity;
        public String handlingFee;
        public String Id;
       @AuraEnabled public Boolean isShipTo;
       @AuraEnabled public Boolean isPickupOnly;
    } 
}