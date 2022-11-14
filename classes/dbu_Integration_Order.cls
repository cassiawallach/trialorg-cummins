/**********************************************************************
Name: dbu_Integration_Order
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    REST API Service to import bulk data from Parts.Cummins.Com 

======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         20/08/2020                 INITIAL DEVELOPMENT 
2.0    Ranadip Jha           01/10/2021                 Inventory Changes

***********************************************************************/

@RestResource(urlMapping='/dbu_Integration_Order/*')
global with sharing class dbu_Integration_Order {
    
    @HttpPost
    global static void UpdateOrderStatus(List<dbu_Integration_Order_Request> data) {
        Map<String,ccrz__E_Order__c> ordersMap = new Map<String,ccrz__E_Order__c>();
        Map<String,ccrz__E_Order__c> returnOrdersMap = new Map<String,ccrz__E_Order__c>();
        Map<String,ccrz__E_OrderItem__c> orderItemsMap = new Map<String,ccrz__E_OrderItem__c>();
        Map<String,ccrz__E_OrderItem__c> returnOrderItemsMap = new Map<String,ccrz__E_OrderItem__c>();
        Map<String,ccrz__E_OrderItem__c> returnOriginalOrderItemsMap = new Map<String,ccrz__E_OrderItem__c>();
        Set<String> orderExternalIds = new Set<String>();
        Set<String> returnOrderItemExternalIds = new Set<String>();
        Set<String> orderItemExternalIds = new Set<String>();
        List<ccrz__E_Order__c> ordersToBeUpdated = new List<ccrz__E_Order__c>();
        List<ccrz__E_OrderItem__c> orderItemsToBeUpdated = new List<ccrz__E_OrderItem__c>();
        
        Map<String,String> orderItemStatusMap = new Map<String,String>();
        Map<String,String> orderItemPickStatusMap = new Map<String,String>();
        Map<String,String> orderItemOpenStatusMap = new Map<String,String>();
        
        List<Id> sendMailForOrderItemReturnReject = new List<Id>();
        
        system.debug('data ' + JSON.serialize(data));
        
        try {
            
            for (dbu_Integration_Order_Request request : data) {
                orderExternalIds.add(request.CCOrderId);
            }
            
            System.debug('orderExternalIds=>'+orderExternalIds);
            List<ccrz__E_Order__c> orderItems = [SELECT Id,Name,CC_Order__c,ccrz__OrderStatus__c,ccrz__ShipMethod__c,dbu_Send_Email_For_Pickup_Items__c,dbu_BMSOrderId__c FROM ccrz__E_Order__c WHERE Name IN:orderExternalIds];
            
            for (ccrz__E_Order__c orderItem : orderItems) {
                
                if(orderItem.CC_Order__c != null){
                    returnOrderItemExternalIds.add(orderItem.Id);
                    returnOrdersMap.put(orderItem.Name, orderItem);
                }
                else {
                    ordersMap.put(orderItem.Name, orderItem);
                    orderItemExternalIds.add(orderItem.Id);
                }
            }
            System.debug('ordersMap=>'+ordersMap);
            System.debug('orderItemExternalIds=>'+orderItemExternalIds);
            System.debug('returnOrdersMap=>'+returnOrdersMap);
            System.debug('returnOrderItemExternalIds=>'+returnOrderItemExternalIds);
            
            if(orderItemExternalIds.size()>0)
            {
                List<ccrz__E_OrderItem__c> orderLineItems = [SELECT Id,ccrz__Product__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Order__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__Order__r.Name,ccrz__OrderItemStatus__c,ccrz__OrderItemId__c,dbu_BMS_Comment__c,dbu_isShipTo__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c IN:orderItemExternalIds];
                
                for (ccrz__E_OrderItem__c orderLineItem : orderLineItems) {
                    orderItemsMap.put(orderLineItem.ccrz__Order__r.Name+'-'+orderLineItem.ccrz__Product__r.dbu_Part_Number__c, orderLineItem);
                    //New
                    if(orderLineItem.ccrz__OrderItemStatus__c == 'Shipped'){
                        orderItemStatusMap.put(orderLineItem.Id,orderLineItem.ccrz__OrderItemStatus__c);
                    }
                    if( orderLineItem.ccrz__OrderItemStatus__c == 'Available for Pickup' ){
                        orderItemPickStatusMap.put(orderLineItem.Id,orderLineItem.ccrz__OrderItemStatus__c);
                    }
                    
                    if( orderLineItem.ccrz__OrderItemStatus__c == 'Open' ){
                        orderItemOpenStatusMap.put(orderLineItem.Id,orderLineItem.ccrz__OrderItemStatus__c);
                    }
                }
                System.debug('orderItemsMap=>'+orderItemsMap);
            }
            
            if(returnOrderItemExternalIds.size()>0)
            {
                Set<String> originalOrderItemIds = new Set<String>();
                List<ccrz__E_OrderItem__c> returnOrderLineItems = [SELECT Id,dbu_CC_Order_Item__r.Id,ccrz__Product__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Order__c,ccrz__Order__r.Name,ccrz__OrderItemStatus__c,ccrz__OrderItemId__c,dbu_BMS_Comment__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c IN:returnOrderItemExternalIds];
                for (ccrz__E_OrderItem__c orderLineItem : returnOrderLineItems) {
                    returnOrderItemsMap.put(orderLineItem.ccrz__Order__r.Name+'-'+orderLineItem.ccrz__Product__r.dbu_Part_Number__c, orderLineItem);
                    originalOrderItemIds.add(orderLineItem.dbu_CC_Order_Item__r.Id);
                }
                System.debug('originalOrderItemIds=>'+originalOrderItemIds);
                
                if(originalOrderItemIds.size()>0)
                {
                    List<ccrz__E_OrderItem__c> returnOriginalOrderLineItems = [SELECT Id,ccrz__OrderItemStatus__c,dbu_BMS_Comment__c FROM ccrz__E_OrderItem__c WHERE Id IN:originalOrderItemIds];
                    for (ccrz__E_OrderItem__c orderLineItem : returnOriginalOrderLineItems) {
                        returnOriginalOrderItemsMap.put(orderLineItem.Id, orderLineItem);
                    }
                }
                System.debug('returnOrderItemsMap=>'+returnOrderItemsMap);
                System.debug('returnOriginalOrderItemsMap=>'+returnOriginalOrderItemsMap);
            }
            
            ProcessNormalOrder(ordersMap,orderItemsMap,data,ordersToBeUpdated,orderItemsToBeUpdated);
            ProcessReturnOrder(returnOrdersMap,returnOrderItemsMap,returnOriginalOrderItemsMap,data,ordersToBeUpdated,orderItemsToBeUpdated,sendMailForOrderItemReturnReject);
            
            system.debug('orderItemsToBeUpdated size '+ orderItemsToBeUpdated.size());
            
            for(ccrz__E_Order__c orderData : ordersToBeUpdated){
                Integer orderItemSize = orderItemsToBeUpdated.size();
                Integer countOpenStatus = 0;
                Integer countShippedStatus = 0;
                Integer countPickUpStatus = 0;
                Integer countOrderSubmittedStatus = 0;
                
                if(orderData.CC_Order__c == Null){
                    for(ccrz__E_OrderItem__c orderItem : orderItemsToBeUpdated){
                        if((orderData.id == orderItem.ccrz__Order__c) && (orderItem.ccrz__OrderItemStatus__c.toLowerCase() == 'open')){
                            countOpenStatus ++;
                        }else if((orderData.id == orderItem.ccrz__Order__c) && (orderItem.ccrz__OrderItemStatus__c.toLowerCase() == 'shipped')){
                            countShippedStatus ++;
                        }else if((orderData.id == orderItem.ccrz__Order__c) && (orderItem.ccrz__OrderItemStatus__c.toLowerCase() == 'available for pickup')){
                            countPickUpStatus ++;
                        }else if((orderData.id == orderItem.ccrz__Order__c) && (orderItem.ccrz__OrderItemStatus__c.toLowerCase() == 'Order Submitted')){
                            countOrderSubmittedStatus ++;
                        }
                    }
                }
                system.debug('orderItemsMap.size() ' + orderItemsMap.size());
                system.debug('orderItemStatusMap.size() ' + orderItemStatusMap.size());
                system.debug('orderItemPickStatusMap.size() ' + orderItemPickStatusMap.size());
                system.debug('orderItemOpenStatusMap.size() ' + orderItemOpenStatusMap.size());
                system.debug('count ' + countOpenStatus);
                system.debug('countOpenStatus ' + countOpenStatus);
                system.debug('countShippedStatus ' + countShippedStatus);
                system.debug('countPickUpStatus ' + countPickUpStatus);
                if(orderData.ccrz__OrderStatus__c == 'Return Approved' || orderData.ccrz__OrderStatus__c == 'Return Rejected' || orderData.ccrz__OrderStatus__c == 'Return Partially Accepted'){
                    // do nothing
                } else{
                    if(countOpenStatus !=0 && countOpenStatus  < orderItemsMap.size() && countPickUpStatus + countShippedStatus == 0 && orderItemStatusMap.size()+orderItemPickStatusMap.size() == 0){
                        orderData.ccrz__OrderStatus__c = 'Open';
                        system.debug('if1');
                    //}else if(countPickUpStatus + countShippedStatus + orderItemStatusMap.size() + orderItemPickStatusMap.size() < orderItemsMap.size() && countPickUpStatus + countShippedStatus + orderItemStatusMap.size() + orderItemPickStatusMap.size() != 0){
                    }else if(countPickUpStatus + countShippedStatus  < orderItemsMap.size() && countPickUpStatus + countShippedStatus + orderItemStatusMap.size() + orderItemPickStatusMap.size() != 0){
                        orderData.ccrz__OrderStatus__c = 'Partially Fulfilled';
                        system.debug('if2');
                    }else if(countOpenStatus + orderItemOpenStatusMap.size() == orderItemsMap.size() && 
                             orderItemStatusMap.size() + orderItemPickStatusMap.size() == 0 && 
                             countPickUpStatus + countShippedStatus == 0){
                                 
                                 orderData.ccrz__OrderStatus__c = 'Open';
                                 system.debug('if3');
                                 
                             }else if(countPickUpStatus == orderItemsMap.size() || orderItemPickStatusMap.size() == orderItemsMap.size()){
                                 orderData.ccrz__OrderStatus__c = 'Available for Pickup';
                                 system.debug('if4');
                             }else if(countPickUpStatus + countShippedStatus + orderItemStatusMap.size() + orderItemPickStatusMap.size() == orderItemsMap.size()){
                                 orderData.ccrz__OrderStatus__c = 'Shipped';
                                 system.debug('if5');
                             }
                }
            }
            
            
            System.debug('ordersToBeUpdated=>'+ JSON.serialize(ordersToBeUpdated));
            System.debug('orderItemsToBeUpdated=>'+JSON.serialize(orderItemsToBeUpdated));
            
            
            upsert orderItemsToBeUpdated;
            
            upsert ordersToBeUpdated;
            
            System.debug('Order status updated successfully');
            dbu_RestResponseHelper.SetRestResponse(200,'OK','Order updated successfully');
            dbu_Integration_Error_Log.createErrorLog(200,'',JSON.serialize(data),'Order updated successfully','Order Service','Success');
            
        } 
        catch(System.StringException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Invalid input');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Order Service','Exception');
        }
        catch(System.QueryException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Failed to process data');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Order Service','Exception');
        }
        catch(dbu_CustomException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Comment is mandatory');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Invoice Service','Exception');
        }
        catch(Exception e){ //something else happened
            dbu_RestResponseHelper.SetRestResponse(500,'BAD_REQUEST',e.getMessage());
            dbu_Integration_Error_Log.createErrorLog(500,e.getMessage(),JSON.serialize(data),'','Order Service','Exception');
        }
        if(sendMailForOrderItemReturnReject.size() > 0)
            sendMail(sendMailForOrderItemReturnReject);
    }
    
    private static void ProcessNormalOrder(Map<String,ccrz__E_Order__c> ordersMap,
                                           Map<String,ccrz__E_OrderItem__c> orderItemsMap,
                                           List<dbu_Integration_Order_Request> data,
                                           List<ccrz__E_Order__c> ordersToBeUpdated,
                                           List<ccrz__E_OrderItem__c> orderItemsToBeUpdated )
    {
        for (dbu_Integration_Order_Request request : data) {
            
            if(!ordersMap.isEmpty())
            {
                ccrz__E_Order__c orderToBeUpdated = ordersMap.get(request.CCOrderId);
                
                if(orderToBeUpdated == null)
                {
                    continue;
                }
                System.debug('orderToBeUpdated=>'+orderToBeUpdated);
                
                if(request.BMSOrderStatus.toLowerCase()=='invoiced'){
                    //if(orderToBeUpdated.ccrz__ShipMethod__c=='Ship To Address' || orderToBeUpdated.ccrz__ShipMethod__c == 'Adresse d\'expédition'){
                    // orderToBeUpdated.ccrz__OrderStatus__c = 'Shipped';
                    //}else{
                    //orderToBeUpdated.ccrz__OrderStatus__c = 'Available for Pickup';
                    //}
                    orderToBeUpdated.ccrz__OrderStatus__c = 'Shipped';
                }
                else{
                    orderToBeUpdated.ccrz__OrderStatus__c = request.BMSOrderStatus;
                }
                /**Shriram 9thDec2021 */
                if(request.BMSOrderId != null){
                    System.debug('????????????????????\t'+request.BMSOrderId);
                    if(String.isNotBlank(orderToBeUpdated.dbu_BMSOrderId__c)){
                        System.debug('Inside is not blank of order Id orderToBeUpdated.dbu_BMSOrderId__c\t'+orderToBeUpdated.dbu_BMSOrderId__c);
                        if(!(orderToBeUpdated.dbu_BMSOrderId__c).equalsIgnoreCase(request.BMSOrderId)) {
                            List<String> lstOrderIds = orderToBeUpdated.dbu_BMSOrderId__c.split(',');
                            System.debug('Inside is not blank of order Id\t'+lstOrderIds);
                            if(!lstOrderIds.contains(request.BMSOrderId)){
                                System.debug('Appending order Id\t'+lstOrderIds);
                                orderToBeUpdated.dbu_BMSOrderId__c = orderToBeUpdated.dbu_BMSOrderId__c +','+ request.BMSOrderId;
                            }
                        }
                    }else{
                            System.debug('Inside is blank of order Id orderToBeUpdated.dbu_BMSOrderId__c\t'+orderToBeUpdated.dbu_BMSOrderId__c);
                            orderToBeUpdated.dbu_BMSOrderId__c = request.BMSOrderId;
                    }  
                }
                /** Ended here*/
                //orderToBeUpdated.ccrz__OrderStatus__c = request.BMSOrderStatus;
                
                //ordersToBeUpdated.add(orderToBeUpdated);
                if(!ordersToBeUpdated.isEmpty()){
                    for(ccrz__E_Order__c orderData : ordersToBeUpdated){
                        if(orderData.id != orderToBeUpdated.id){
                            ordersToBeUpdated.add(orderToBeUpdated);
                        }
                    }
                }else {
                    ordersToBeUpdated.add(orderToBeUpdated);
                }
                
                
                System.debug('ordersToBeUpdated=>'+ordersToBeUpdated);
                
                for (dbu_Integration_OrderItem_Request item : request.OrderItemsStatus) {
                    System.debug('orderItemsMap==\t'+orderItemsMap);
                    System.debug('orderItemsMap.Contains==\t'+orderItemsMap.containsKey(request.CCOrderId+'-'+item.BMSOrderItemId));
                    System.debug('item==\t'+item);
                    ccrz__E_OrderItem__c orderItemToBeUpdated = orderItemsMap.get(request.CCOrderId+'-'+item.BMSOrderItemId);
                    System.debug('orderItemToBeUpdated=>'+orderItemToBeUpdated);
                    
                    orderItemToBeUpdated.dbu_BMS_Comment__c = item.Comment;
                    
                    if(item.BMSOrderItemStatus.toLowerCase() == 'invoiced'){
                        // if(orderItemToBeUpdated.ccrz__Order__r.ccrz__ShipMethod__c=='Ship To Address' || orderItemToBeUpdated.ccrz__Order__r.ccrz__ShipMethod__c == 'Adresse d\'expédition'){
                        // orderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Shipped';
                        // }else{
                        //orderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Available for Pickup';
                        //}
                        // if(oItem.dbu_isShipTo__c){
                        if(orderItemToBeUpdated.dbu_isShipTo__c){
                            orderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Shipped';
                        }else{
                            orderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Available for Pickup';
                            // Email changes
                           // orderToBeUpdated.dbu_Send_Email_For_Pickup_Items__c = true;
                        }
                    }
                    else{ 
                        orderItemToBeUpdated.ccrz__OrderItemStatus__c = item.BMSOrderItemStatus;
                    }
                    //orderItemToBeUpdated.ccrz__OrderItemStatus__c = item.BMSOrderItemStatus;
                    
                    orderItemsToBeUpdated.add(orderItemToBeUpdated);
                }
            }
        }
    }
    
    private static void ProcessReturnOrder(Map<String,ccrz__E_Order__c> ordersMap,
                                           Map<String,ccrz__E_OrderItem__c> orderItemsMap,
                                           Map<String,ccrz__E_OrderItem__c> orderOriginalItemsMap,
                                           List<dbu_Integration_Order_Request> data,
                                           List<ccrz__E_Order__c> ordersToBeUpdated,
                                           List<ccrz__E_OrderItem__c> orderItemsToBeUpdated,
                                           List<Id> sendMailForOrderItemReturnReject )
    {
        for (dbu_Integration_Order_Request request : data) {
            if(!ordersMap.isEmpty())
            {
                ccrz__E_Order__c orderToBeUpdated = ordersMap.get(request.CCOrderId);
                if(orderToBeUpdated == null)
                {
                    continue;
                }
                System.debug('returnOrderToBeUpdated=>'+orderToBeUpdated);
                
                map<string,string> orderItemsForCurrentOrdermap = new map<string,string>();
                for (dbu_Integration_OrderItem_Request item : request.OrderItemsStatus) {
                    ccrz__E_OrderItem__c orderItemToBeUpdated = orderItemsMap.get(request.CCOrderId+'-'+item.BMSOrderItemId);
                    ccrz__E_OrderItem__c respectiveOrderItemToBeUpdated = orderOriginalItemsMap.get(orderItemToBeUpdated.dbu_CC_Order_Item__r.Id);
                    System.debug('returnorderItemToBeUpdated=>'+orderItemToBeUpdated);
                    System.debug('returnrespectiveOrderItemToBeUpdated=>'+respectiveOrderItemToBeUpdated);
                    
                    orderItemToBeUpdated.dbu_BMS_Comment__c = item.Comment;
                    respectiveOrderItemToBeUpdated.dbu_BMS_Comment__c = item.Comment;
                    if(item.BMSOrderItemStatus != 'Return Rejected')
                    {
                        if(item.BMSOrderItemStatus.toLowerCase() == 'invoiced')
                        {
                            orderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Return Approved';
                            respectiveOrderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Return Approved';
                        }
                        else
                        {
                            orderItemToBeUpdated.ccrz__OrderItemStatus__c = item.BMSOrderItemStatus;
                            respectiveOrderItemToBeUpdated.ccrz__OrderItemStatus__c = item.BMSOrderItemStatus;
                        }
                    }
                    else
                    {
                        if(item.BMSOrderItemStatus == 'Return Rejected'){
                            if(item.Comment == null || item.Comment == ''){
                                throw new dbu_CustomException();
                            }
                        }
                        // respectiveOrderItemToBeUpdated.ccrz__OrderItemStatus__c = 'Return Rejected';
                        // System.debug('respectiveOrderItemToBeUpdated=>'+respectiveOrderItemToBeUpdated);
                        
                        sendMailForOrderItemReturnReject.add(orderItemToBeUpdated.Id);
                    }
                    orderItemsForCurrentOrdermap.put(item.BMSOrderItemId,item.BMSOrderItemStatus);
                    orderItemsToBeUpdated.add(orderItemToBeUpdated);
                    orderItemsToBeUpdated.add(respectiveOrderItemToBeUpdated);
                }
                
                if(request.BMSOrderStatus.toLowerCase()=='invoiced')
                {
                    Integer rejectedCounter = 0;
                    Integer acceptedCounter = 0;
                    System.debug('orderItemsForCurrentOrdermap.values()=>'+orderItemsForCurrentOrdermap.values());
                    
                    for(String item :orderItemsForCurrentOrdermap.values())
                    {
                        if(item.toLowerCase()=='invoiced')
                        {
                            acceptedCounter = acceptedCounter + 1;
                        }
                        if(item == 'Return Rejected')
                        {
                            rejectedCounter = rejectedCounter + 1;
                        }
                    }
                    if(acceptedCounter == orderItemsForCurrentOrdermap.size()){
                        orderToBeUpdated.ccrz__OrderStatus__c = 'Return Approved';
                    }
                    else if (rejectedCounter == orderItemsForCurrentOrdermap.size())
                    {
                        // orderToBeUpdated.ccrz__OrderStatus__c = 'Return Rejected';
                    }
                    else {
                        orderToBeUpdated.ccrz__OrderStatus__c = 'Return Partially Accepted';
                    }
                    System.debug('order status updated');
                    
                }
                else{
                    if(request.BMSOrderStatus != 'Return Rejected'){
                        orderToBeUpdated.ccrz__OrderStatus__c = request.BMSOrderStatus;
                    }
                }
                
                
                System.debug('default status of order is updated');
                
                ordersToBeUpdated.add(orderToBeUpdated);
                
                System.debug('ordersToBeUpdated=>'+ordersToBeUpdated);
                
            }
        }
    }
    
    public static void sendMail(List<Id> sendMailForOrderItemReturnReject)
    {
        if(sendMailForOrderItemReturnReject.size()>0)
        {
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            
            List<ccrz__E_OrderItem__c> orderItemLst = new List<ccrz__E_OrderItem__c>();
            Map<Id,ccrz__E_OrderItem__c> MaporderItemLst = new Map<Id,ccrz__E_OrderItem__c>();
            orderItemLst = [Select Id,ccrz__Order__c,ccrz__Order__r.Name,ccrz__Order__r.ccrz__Contact__c,ccrz__Order__r.OwnerId from ccrz__E_OrderItem__c where Id IN: sendMailForOrderItemReturnReject];
            List<Id> lstUserId = new List<Id>();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
            for(ccrz__E_OrderItem__c ItemObj : orderItemLst)
            {
                MaporderItemLst.put(ItemObj.Id,ItemObj);
                lstUserId.add(ItemObj.ccrz__Order__r.OwnerId);
            }
            
            Map<Id,User> userMap = new Map<Id,User>();
            if(lstUserId.size() > 0)
            {
                userMap.putAll([Select Id,ContactId from User where Id IN: lstUserId]);
            }
            
            for(Id itemId : sendMailForOrderItemReturnReject)
            {
                if(MaporderItemLst.containsKey(itemId))
                {
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    
                    if(MaporderItemLst.get(itemId).ccrz__Order__r.ccrz__Contact__c != null)
                        message.setTargetObjectId(MaporderItemLst.get(itemId).ccrz__Order__r.ccrz__Contact__c); 
                    else{
                        if(userMap.containsKey(MaporderItemLst.get(itemId).ccrz__Order__r.OwnerId) && userMap.get(MaporderItemLst.get(itemId).ccrz__Order__r.OwnerId).ContactId != null)
                        {
                            message.setTargetObjectId(userMap.get(MaporderItemLst.get(itemId).ccrz__Order__r.OwnerId).ContactId); 
                        }
                    }
                    //message.setSenderDisplayName('Company Support'); 
                    //message.setReplyTo('no-reply@company.com');
                    message.setOrgWideEmailAddressId(owea[0].Id);
                    message.setUseSignature(false); 
                    message.setBccSender(false); 
                    message.setSaveAsActivity(false); 
                    EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CyberSource_Refund_Reject'];
                    message.setTemplateID(emailTemplate.Id); 
                    message.setWhatId(itemId); //This is important for the merge fields in template to work
                    
                    String emails = System.label.dbu_Email_For_return_Rejection;
                    List<String> lstEmails = new List<String>();
                    lstEmails.addAll(emails.split(','));
                    message.toAddresses = lstEmails;
                    messages.add(message);
                }
            }
            if(messages.size() > 0)
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
    
}