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
2.0    Ranadip Jha			 11/12/2020					Return Order Changes
3.0	   Ranadip Jha			 11/10/2021					Inventory Changes

***********************************************************************/

@RestResource(urlMapping='/dbu_Integration_Invoice/*')
global with sharing class dbu_Integration_Invoice {
    @HttpPost
    global static void UpdateInvoice(List<dbu_Integration_Invoice_Request> data) {
        
        Map<String,ccrz__E_Order__c> ordersMap = new Map<String,ccrz__E_Order__c>();
        Map<String,ccrz__E_OrderItem__c> orderItemsMap = new Map<String,ccrz__E_OrderItem__c>();
        Map<String,ccrz__E_Invoice__c> invoiceMap = new Map<String,ccrz__E_Invoice__c>();
        
        Set<String> orderExternalIds = new Set<String>();
        Set<String> orderIds = new Set<String>();
        
        List<ccrz__E_Invoice__c> invoicesToBeUpdated = new List<ccrz__E_Invoice__c>();
        List<ccrz__E_InvoiceItem__c> invoiceItemsToBeUpdated = new List<ccrz__E_InvoiceItem__c>();
        
        // Added by Mukesh Gupta
        List<ccrz__E_OrderItem__c> orderLineItemsList = new List<ccrz__E_OrderItem__c>();
        
        // Inventory Changes
        Map<String,ccrz__E_OrderItem__c> orderLineItemMap = new Map<String,ccrz__E_OrderItem__c>();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        Map<String,String> orderNumberIdMap = new Map<String,String>();
        
        try {
            for (dbu_Integration_Invoice_Request request : data) {
                orderExternalIds.add(request.CCOrderId);
            }
            System.debug('orderExternalIds=>'+ JSON.serialize(orderExternalIds));
            
            List<ccrz__E_Order__c> orderItems = [SELECT Id,CC_Order__c,Name,ccrz__OrderNumber__c,ccrz__ShipMethod__c,dbu_BMS_Tracking_Number__c FROM ccrz__E_Order__c WHERE Name IN:orderExternalIds];
            
            for (ccrz__E_Order__c order : orderItems) {
                orderIds.add(order.Id);
                ordersMap.put(order.Name, order);
            }
            System.debug('orderIds=>'+ JSON.serialize(orderIds));
            System.debug('ordersMap=>'+ JSON.serialize(ordersMap));
            
            List<ccrz__E_OrderItem__c> orderLineItems = [SELECT Id,ccrz__Product__r.dbu_Part_Number__c,dbu_isShipTo__c,ccrz__Order__c  FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c IN:orderIds];
            for (ccrz__E_OrderItem__c orderLineItem : orderLineItems) {
                if(orderLineItem.ccrz__Product__r.dbu_Part_Number__c != NULL){
                    orderItemsMap.put(orderLineItem.ccrz__Product__r.dbu_Part_Number__c, orderLineItem);
                    orderLineItemMap.put(orderLineItem.ccrz__Order__c,orderLineItem);
                }
            }
            System.debug('orderItemsMap=>'+ JSON.serialize(orderItemsMap));
            
            
            for (dbu_Integration_Invoice_Request request : data) {
                ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
                
                ccrz__E_Order__c ol = ordersMap.get(request.CCOrderId);
                
                invoice.ccrz__CCOrder__c = ol.Id;
                invoice.BMS_Invoice_No__c = request.BMSInvoiceNumber;
                System.debug('request.CCOrderShippingTrackingNumber ==========\t'+request.CCOrderShippingTrackingNumber);
                if(ol.CC_Order__c == null){
                    for(ccrz__E_OrderItem__c orderLineItem : orderLineItems){
                        if(orderLineItemMap.containskey(ol.Id) && orderLineItem.dbu_isShipTo__c && (request.CCOrderShippingTrackingNumber == null || request.CCOrderShippingTrackingNumber == '')){
                            throw new dbu_CustomException();
                        }
                    }
                    invoice.dbu_Tracking_Number__c =  request.CCOrderShippingTrackingNumber;
                }else {
                    invoice.dbu_Tracking_Number__c =  request.CCOrderShippingTrackingNumber;
                }
                invoice.BMS_Invoice_No__c = request.BMSInvoiceNumber;
                invoicesToBeUpdated.add(invoice);
            }     
            upsert invoicesToBeUpdated;
            
            List<ccrz__E_Invoice__c> invoiceItems = [SELECT Id,BMS_Invoice_No__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c IN:orderIds];
            
            for (ccrz__E_Invoice__c invoiceItem : invoiceItems) {
                invoiceMap.put(invoiceItem.BMS_Invoice_No__c, invoiceItem);
            }
            
            System.debug('invoicesToBeUpdated=>'+ JSON.serialize(invoicesToBeUpdated));
            // Added by Mukesh Gupta
            Set<Id> orderLineItemIds = new Set<Id>();
            for (dbu_Integration_Invoice_Request request : data) {
                
                ccrz__E_Invoice__c existingInvoice = invoiceMap.get(request.BMSInvoiceNumber);
                ccrz__E_Order__c ol = ordersMap.get(request.CCOrderId);
                
                for(dbu_Integration_InvoiceItem_Request itemRequest:request.CCInvoiceLineItemId){
                    ccrz__E_InvoiceItem__c invoiceItem = new ccrz__E_InvoiceItem__c();
                    //ccrz__E_InvoiceItem__c existingInvoiceItem = invoiceItemsMap.get(itemRequest.CCInvoiceLineItemNumber);
                    
                    invoiceItem.ccrz__Invoice__c = existingInvoice.ID;
                    ccrz__E_OrderItem__c oli = orderItemsMap.get(itemRequest.CCInvoiceLineItemNumber);
                    invoiceItem.ccrz__CCOrderItem__c = oli.Id;
                    invoiceItem.ccrz__CCOrder__c = ol.Id;
                    orderLineItemIds.add(oli.Id); // Added by Mukesh
                    System.debug('request.CCOrderShippingTrackingNumber in invoiceItem ==========\t'+request.CCOrderShippingTrackingNumber);
                    //invoiceItem.dbu_Tracking_Number__c = Decimal.valueof(request.CCOrderShippingTrackingNumber);
                    invoiceItemsToBeUpdated.add(invoiceItem);
                    //System.debug('invoiceItemsToBeUpdated=>'+ JSON.serialize(invoiceItemsToBeUpdated));
                    if(orderItemsMap.containskey(itemRequest.CCInvoiceLineItemNumber)){
                        if(oli.dbu_isShipTo__c){
                            orderNumberIdMap.put(ol.Name,request.CCOrderShippingTrackingNumber);
                        }
                    }
                    
                }
            }
            
            system.debug('orderNumberIdMap ' + orderNumberIdMap);
            system.debug('orderNumberIdMap size ' + orderNumberIdMap.size());
            for(String orderName : orderNumberIdMap.keyset()){
                if(ordersMap.containsKey(orderName)){
                    ccrz__E_Order__c ol = ordersMap.get(orderName);
                    if(ol.dbu_BMS_Tracking_Number__c == null || ol.dbu_BMS_Tracking_Number__c == ''){
                        ol.dbu_BMS_Tracking_Number__c = orderNumberIdMap.get(orderName);
                    }else {
                        ol.dbu_BMS_Tracking_Number__c = ol.dbu_BMS_Tracking_Number__c + ',' + orderNumberIdMap.get(orderName);
                    }
                   orderList.add(ol);
                }
            }
            if(!orderList.isEmpty()){
            update orderList;
            }
            
            
            //System.debug('invoicesToBeUpdated=>'+ JSON.serialize(invoicesToBeUpdated));
            System.debug('invoiceItemsToBeUpdated=>'+ JSON.serialize(invoiceItemsToBeUpdated));
            
            //upsert invoicesToBeUpdated;
            upsert invoiceItemsToBeUpdated;
            System.debug('Invoices created successfully');
            
            // Added by Mukesh 
            for(ccrz__E_OrderItem__c orderItem : [SELECT Id,dbu_Invoice_Generated__c FROM ccrz__E_OrderItem__c WHERE Id IN : orderLineItemIds]){
                orderItem.dbu_Invoice_Generated__c = True;
                orderLineItemsList.add(orderItem);
                break;
            }
            if(orderLineItemsList.size() > 0){
                update orderLineItemsList;
            }
            // added by Ranadip
            Map<String,String> mapOfOrderObj = new Map<String,String>();
            Map<String,ccrz__E_Invoice__c> mapOfInvoice = new Map<String,ccrz__E_Invoice__c>();
            List<ccrz__E_Invoice__c> listOfInvoiceToUpdate = new List<ccrz__E_Invoice__c>();
            List<ccrz__E_InvoiceItem__c> listOfInvoiceItemToUpdate = new List<ccrz__E_InvoiceItem__c>();
            Map<String,List<ccrz__E_OrderItem__c>> clOrderItemMap = new Map<String,List<ccrz__E_OrderItem__c>>();
            List<String> clOrderIds = new List<String>();
            List<String> orInvoiceIds = new List<String>();
            List<String> orOrderIds = new List<String>();
            if(orderItems != null){
                for(ccrz__E_Order__c orderObj : orderItems){
                    if(orderObj.CC_Order__c != null){
                        mapOfOrderObj.put(orderObj.id,orderObj.CC_Order__c);
                        clOrderIds.add(orderObj.id);
                        orOrderIds.add(orderObj.CC_Order__c);
                    }
                }
            }
            System.debug('Clone order ids '+ clOrderIds);
            if(clOrderIds.size() > 0){
                List<ccrz__E_Order__c> listOfOrder = [SELECT Id,CC_Order__c,ccrz__OrderNumber__c,(SELECT Id,ccrz__Order__c,dbu_CC_Order_Item__c FROM ccrz__E_OrderItems__r ) FROM ccrz__E_Order__c WHERE Id IN:clOrderIds];
                for(ccrz__E_Order__c orderObj : listOfOrder){
                    if(mapOfOrderObj.containsKey(orderObj.Id)){
                        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
                        for(ccrz__E_OrderItem__c orderItemObj : orderObj.ccrz__E_OrderItems__r){
                            orderItemList.add(orderItemObj);
                        }
                        clOrderItemMap.put(orderObj.Id,orderItemList);
                    }
                }
                System.debug('Clone Oder List ' + listOfOrder);
                List<ccrz__E_Invoice__c> listOfInvoice = [SELECT Id,ccrz__CCOrder__c,BMS_Invoice_No__c from ccrz__E_Invoice__c WHERE ccrz__CCOrder__c IN: clOrderIds];
                for(ccrz__E_Invoice__c inv : listOfInvoice){
                    if(mapOfOrderObj.containsKey(inv.ccrz__CCOrder__c)){
                        ccrz__E_Invoice__c invoiceObj  = new ccrz__E_Invoice__c();
                        invoiceObj.ccrz__CCOrder__c = mapOfOrderObj.get(inv.ccrz__CCOrder__c);
                        invoiceObj.BMS_Invoice_No__c = inv.BMS_Invoice_No__c;
                        listOfInvoiceToUpdate.add(invoiceObj);
                    }
                    mapOfInvoice.put(inv.ccrz__CCOrder__c,inv);
                }
                System.debug('Clone List of Invoices ' + listOfInvoice);
                insert listOfInvoiceToUpdate;
                
                for(ccrz__E_Invoice__c inv : listOfInvoiceToUpdate){
                    orInvoiceIds.add(inv.id);
                }
                system.debug('orInvoiceIds ' + orInvoiceIds);
                List<ccrz__E_Invoice__c> orListOfInvoice = [SELECT Id,ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE Id IN:orInvoiceIds limit 1];
                
                //List<ccrz__E_InvoiceItem__c> orListOfInvoiceItem = [SELECT Id,ccrz__Invoice__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,dbu_Tracking_Number__c FROM ccrz__E_InvoiceItem__c WHERE ccrz__CCOrder__c IN:orOrderIds];
                system.debug('orListOfInvoice ' + orListOfInvoice);
                List<ccrz__E_InvoiceItem__c> listOfInvoiceItem = [SELECT Id,ccrz__Invoice__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,dbu_Tracking_Number__c FROM ccrz__E_InvoiceItem__c WHERE ccrz__CCOrder__c IN:clOrderIds];
                for(ccrz__E_InvoiceItem__c invItem : listOfInvoiceItem){
                    if(mapOfOrderObj.containsKey(invItem.ccrz__CCOrder__c) && mapOfInvoice.containsKey(invItem.ccrz__CCOrder__c) && clOrderItemMap.containsKey(invItem.ccrz__CCOrder__c)){
                        ccrz__E_InvoiceItem__c invItemObj = new ccrz__E_InvoiceItem__c();
                        List<ccrz__E_OrderItem__c> listOfOrderItem = new List<ccrz__E_OrderItem__c>();
                        listOfOrderItem = clOrderItemMap.get(invItem.ccrz__CCOrder__c);
                        for(ccrz__E_OrderItem__c orderItem : listOfOrderItem){
                            if(invItem.ccrz__CCOrderItem__c == orderItem.Id){
                                invItemObj.ccrz__CCOrderItem__c = orderItem.dbu_CC_Order_Item__c;
                            }
                        }
                        ccrz__E_Invoice__c invObj = mapOfInvoice.get(invItem.ccrz__CCOrder__c);
                        
                        for(ccrz__E_Invoice__c orInv : orListOfInvoice){
                            if(orInv.ccrz__CCOrder__c == mapOfOrderObj.get(invItem.ccrz__CCOrder__c)  ){
                                //if(orInv.Id != invItemObj.ccrz__Invoice__c){
                                invItemObj.ccrz__Invoice__c = orInv.Id;
                                // }
                            }
                        }
                        
                        invItemObj.ccrz__CCOrder__c = mapOfOrderObj.get(invItem.ccrz__CCOrder__c);
                        //invItemObj.dbu_Tracking_Number__c = invItem.dbu_Tracking_Number__c;
                        listOfInvoiceItemToUpdate.add(invItemObj);
                        
                    }
                }
                System.debug('clone List of InvoiceItem ' + listOfInvoiceItemToUpdate);
                insert listOfInvoiceItemToUpdate;
            }
            dbu_RestResponseHelper.SetRestResponse(200,'OK','Invoice updated successfully');
            //dbu_Integration_Error_Log.createErrorLog(200,'Invoice updated successfully','','Invoice Service','Success');
            dbu_Integration_Error_Log.createErrorLog(200,'',JSON.serialize(data),'Invoice updated successfully','Invoice Service','Success');
            
            // end here  
        } 
        catch(System.StringException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Invalid input');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Invoice Service','Exception');
        }
        catch(System.QueryException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Failed to process data');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Invoice Service','Exception');
        }
        catch(dbu_CustomException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Tracking number is mandatory');
            dbu_Integration_Error_Log.createErrorLog(400,e.getMessage(),JSON.serialize(data),'','Invoice Service','Exception');
        }
        catch(Exception e){ //something else happened
            dbu_RestResponseHelper.SetRestResponse(500,'BAD_REQUEST',e.getMessage());
            dbu_Integration_Error_Log.createErrorLog(500,e.getMessage(),JSON.serialize(data),'','Invoice Service','Exception');
        }
    }
}