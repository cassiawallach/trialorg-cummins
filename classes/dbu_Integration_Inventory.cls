/**********************************************************************
Name: dbu_Integration_Parts
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    REST API Service to import bulk data from Parts.Cummins.Com 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         11/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/

@RestResource(urlMapping='/DBU_Integration_Inventory/*')
global with sharing class dbu_Integration_Inventory {
    @HttpPost
    global static void InsertInventory(List<dbu_Integration_Inventory_Request> data) 
    {
        System.debug('data>>> ' + JSON.serialize(data));
        List<ccrz__E_ProductInventoryItem__c> productInventoriesTobeAdded = new List<ccrz__E_ProductInventoryItem__c>();
        List<ccrz__E_Product__c> products = new List<ccrz__E_Product__c>();
        List<ccrz__E_ProductInventoryItem__c> inventoryItems = new List<ccrz__E_ProductInventoryItem__c>();
        //List<dbu_InventoryLocationCodeCountryMapping__c> locationCodeCountryMapping = dbu_InventoryLocationCodeCountryMapping__c.getall().values();

        Set<String> productSkus = new Set<String>();
        Set<String> productIds = new Set<String>();

        Map<String,ccrz__E_Product__c> existingProductsMap = new Map<String,ccrz__E_Product__c>();
        Map<String,ccrz__E_ProductInventoryItem__c> existingInventoriesMap = new Map<String,ccrz__E_ProductInventoryItem__c>();
       // Map<String,String> locationCodeCurrencyMap = new Map<String,String>();

        try {
            // for (dbu_InventoryLocationCodeCountryMapping__c item : locationCodeCountryMapping) {
            //     String currencyCode = 'USD';
            //     if(item.Country__c == 'Canada')
            //     {
            //         String currencyCode = 'CAD';
            //     }
            //     locationCodeCurrencyMap.put(item.Location_Code__c,currencyCode);
            // }
            // System.debug('locationCodeCurrencyMap>>> ' +locationCodeCurrencyMap);

            for(dbu_Integration_Inventory_Request item:data)
            {
                productSkus.add(item.SKU);
            }
            System.debug('productSkus>>> ' + productSkus);

            // products = [SELECT Id,ccrz__SKU__c,dbu_Part_Number__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN :productSkus];
            products = [SELECT Id,dbu_Part_Number__c FROM ccrz__E_Product__c WHERE dbu_Part_Number__c IN :productSkus];
            System.debug('products>>> ' + products);
            for(ccrz__E_Product__c item:products)
            {
                productIds.add(item.Id);
                // existingProductsMap.put(item.ccrz__SKU__c,item);
                existingProductsMap.put(item.dbu_Part_Number__c,item);
            }
            System.debug('existingProductsMap>>> ' + existingProductsMap);
            // inventoryItems = [SELECT Id,ccrz__ProductItem__c,ccrz__ProductItem__r.ccrz__SKU__c, Name,ccrz__InventoryLocationCode__c FROM ccrz__E_ProductInventoryItem__c WHERE ccrz__ProductItem__c IN :productIds];
            inventoryItems = [SELECT Id,ccrz__ProductItem__c,ccrz__ProductItem__r.dbu_Part_Number__c, Name,ccrz__InventoryLocationCode__c FROM ccrz__E_ProductInventoryItem__c WHERE ccrz__ProductItem__c IN :productIds];
            
            for (ccrz__E_ProductInventoryItem__c inventoryItem : inventoryItems) {

                System.debug('ccrz__ProductItem__r.ccrz__SKU__c>>> ' + inventoryItem.ccrz__ProductItem__r.dbu_Part_Number__c);
                // existingInventoriesMap.put(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c + '-'+inventoryItem.ccrz__InventoryLocationCode__c,inventoryItem);
                existingInventoriesMap.put(inventoryItem.ccrz__ProductItem__r.dbu_Part_Number__c + '-'+inventoryItem.ccrz__InventoryLocationCode__c,inventoryItem);
            }
            System.debug('existingInventoriesMap>>> ' + existingInventoriesMap);
            for(dbu_Integration_Inventory_Request item:data)
            {
                // ccrz__E_ProductInventoryItem__c inventory = PopulateInventory(item,existingProductsMap,existingInventoriesMap,locationCodeCurrencyMap);
                ccrz__E_ProductInventoryItem__c inventory = PopulateInventory(item,existingProductsMap,existingInventoriesMap);
                System.debug('inventory>> ' +inventory);
                productInventoriesTobeAdded.add(inventory);
            }

            if(!productInventoriesTobeAdded.isEmpty())
            {
                upsert productInventoriesTobeAdded;
                System.debug('inventory data insert successfull');
            }
            else {
                System.debug('No inventory item to be added');
            }
        } 
        catch(System.StringException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Invalid input');
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Inventory Service','Exception');
        }
        catch(System.QueryException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Failed to process data');
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Inventory Service','Exception');
        }
        catch(Exception e){ //something else happened
            dbu_RestResponseHelper.SetRestResponse(500,'BAD_REQUEST',e.getMessage());
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Inventory Service','Exception');
        }
        dbu_RestResponseHelper.SetRestResponse(200,'OK','Data inserted successfully');
        dbu_Integration_Error_Log.createErrorLog(200,'',JSON.serialize(data),'Data inserted successfully','Inventory Service','Success');
    }
    private static ccrz__E_ProductInventoryItem__c PopulateInventory(dbu_Integration_Inventory_Request item,
                                                                    Map<String,ccrz__E_Product__c> existingProductsMap,
                                                                    Map<String,ccrz__E_ProductInventoryItem__c> existingInventoriesMap)
    {
        System.debug('item>> ' +item);
        ccrz__E_Product__c matchedProduct = existingProductsMap.get(item.SKU);
        //System.debug('matchedProduct>> ' +matchedProduct);
        ccrz__E_ProductInventoryItem__c inventory = new ccrz__E_ProductInventoryItem__c();
        ccrz__E_ProductInventoryItem__c existingInventory = existingInventoriesMap.get(item.SKU+'-'+item.InventoryLocationCode);
        
        if(existingInventory != null)
        {
            inventory = existingInventory;
        }
        
        inventory.Name = matchedProduct.dbu_Part_Number__c +'-'+item.InventoryLocationCode;
        inventory.ccrz__ProductItem__c = matchedProduct.Id;
        inventory.ccrz__InventoryLocationCode__c = item.InventoryLocationCode ;
        if(item.QtyAvailable == null){
            inventory.ccrz__QtyAvailable__c = 0;
        }
        else{
            inventory.ccrz__QtyAvailable__c = item.QtyAvailable;
        }
        if(inventory.ccrz__QtyAvailable__c > 0){
            inventory.ccrz__Status__c ='In Stock';
        }
        else{
            inventory.ccrz__Status__c ='Out of Stock';
        }
        
        inventory.CurrencyIsoCode = getCurrency(item.DistributorCode);

        System.debug('inventory>> ' +inventory);
        return inventory;
    }

    private static String getCurrency(String distributorCode)
    {
        if(distributorCode == '56330' || distributorCode == '56270')
            return 'CAD';
        else
            return 'USD';
    }
}