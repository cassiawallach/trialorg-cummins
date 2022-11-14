@isTest
public with sharing class dbu_Integration_Inventory_Test {
     static testMethod void testloginTime() 
    {
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        objProduct.ccrz__SKU__c = '111';
        objProduct.dbu_Part_Number__c = '111';
        objProduct.Name = 'DBU 5566164 BELT,V RIBBED';
        objProduct.ccrz__StartDate__c = Date.parse('11/23/2020');
        objProduct.ccrz__EndDate__c = Date.parse('11/23/2030');
        Insert objProduct;
        
        ccrz__E_ProductInventoryItem__c objcProductInventoryItem = new ccrz__E_ProductInventoryItem__c();
        objcProductInventoryItem.Name = 'DBU 5566164 BELT,V RIBBED Inventory';
        objcProductInventoryItem.ccrz__InventoryLocationCode__c = 'IRD';
        objcProductInventoryItem.ccrz__QtyAvailable__c = 3.0;
        objcProductInventoryItem.CurrencyIsoCode = 'USD';
        objcProductInventoryItem.ccrz__ProductItem__c = objProduct.Id;
        Insert objcProductInventoryItem; 
        
        ccrz__E_ProductInventoryItem__c objcProductInventoryItem1 = new ccrz__E_ProductInventoryItem__c();
        objcProductInventoryItem1.Name = 'DBU 5566164 BELT,V RIBBED Inventory1';
        objcProductInventoryItem1.ccrz__InventoryLocationCode__c = 'LRD';
        objcProductInventoryItem1.ccrz__QtyAvailable__c = 3.0;
        objcProductInventoryItem1.CurrencyIsoCode = 'USD';
        objcProductInventoryItem1.ccrz__ProductItem__c = objProduct.Id;
        Insert objcProductInventoryItem1; 
        
        
        
        List<dbu_Integration_Inventory_Request> lstIntegrationInventoryRequestData = new List<dbu_Integration_Inventory_Request>();
        dbu_Integration_Inventory_Request objIntegrationInventoryRequestData = new dbu_Integration_Inventory_Request();
        
        objIntegrationInventoryRequestData.SKU = '111';
        objIntegrationInventoryRequestData.InventoryLocationCode = 'IRD';
        objIntegrationInventoryRequestData.QtyAvailable = 5.0;
        objIntegrationInventoryRequestData.DistributorCode = '02850';
        
        lstIntegrationInventoryRequestData.add(objIntegrationInventoryRequestData); 
        
        dbu_Integration_Inventory_Request objIntegrationInventoryRequestData1 = new dbu_Integration_Inventory_Request();
        
        objIntegrationInventoryRequestData1.SKU = '111';
        objIntegrationInventoryRequestData1.InventoryLocationCode = 'LRD';
        objIntegrationInventoryRequestData1.QtyAvailable = 5.0;
        objIntegrationInventoryRequestData1.DistributorCode = '02850';
        
        lstIntegrationInventoryRequestData.add(objIntegrationInventoryRequestData1); 
        
        //Insert objIntegrationInventoryRequestData;
        
        
        
        Test.startTest();
            dbu_Integration_Inventory.InsertInventory(lstIntegrationInventoryRequestData); 
        Test.stopTest(); 
    }  
}