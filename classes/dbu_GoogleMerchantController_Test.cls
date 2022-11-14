/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Devaraj
**/
@isTest

private class dbu_GoogleMerchantController_Test {
    
    
    @isTest
    static void setupUsaFeeds(){
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        
        ccrz__E_PriceList__c priceList = dbu_FactoryDataTest.createPriceList('CSSNA USD Pricelist');
        priceList.ccrz__CurrencyISOCode__c = 'USD';
        insert priceList;
        
        Double ORIGINAL_PRICE =3.14159;
        Double DISCOUNT_AMT =1.14159;
        Double PRICE =2.14159;
        
        ccrz__E_PriceListItem__c priceListItem = dbu_FactoryDataTest.createPriceListItem('test',ORIGINAL_PRICE,DISCOUNT_AMT,'Absolute',PRICE,productObj.Id,priceList.Id);
        insert priceListItem;
        
        ccrz__E_ProductMedia__c  media = dbu_FactoryDataTest.createProductMedia(productObj.Id,'Product Image');
        insert media;
        
       // Document docObj = [SELECT Id, FolderId, Folder.Name FROM Document WHERE Folder.Name =: 'Public' LIMIT 1];
        
        Document doc = new Document();
        doc.Name = media.ccrz__URI__c;
        doc.FolderId = [select id from folder where name = 'Public'].id;
        doc.IsPublic = true;
        insert doc;
        
        Double qty = 10.00;
        ccrz__E_ProductInventoryItem__c inv = dbu_FactoryDataTest.createProductInventoryItem('TestInv',productObj.Id,qty,'Testing','In Stock');
        insert inv;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        insert ccSpec;
        
        ccrz__E_ProductSpec__c spec = new ccrz__E_ProductSpec__c();
        spec.ccrz__Spec__c = ccSpec.Id;
        spec.ccrz__Product__c = productObj.Id;
        spec.ccrz__SpecValue__c = '30 Lbs';
        insert spec;
        
        Test.startTest();
        dbu_GoogleMerchantController obj = new dbu_GoogleMerchantController();
        Database.executeBatch(obj);
        Test.stopTest();
        
    }
    
    @isTest
    static void setupCanadaFeeds(){
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;//add core 
        
        ccrz__E_PriceList__c priceList = dbu_FactoryDataTest.createPriceList('CSSNA CAD Pricelist');
        priceList.ccrz__CurrencyISOCode__c = 'CAD';
        insert priceList;
        
        Double ORIGINAL_PRICE =3.14159;
        Double DISCOUNT_AMT =1.14159;
        Double PRICE =2.14159;
        
        ccrz__E_PriceListItem__c priceListItem = dbu_FactoryDataTest.createPriceListItem('test',ORIGINAL_PRICE,DISCOUNT_AMT,'Absolute',PRICE,productObj.Id,priceList.Id);
        insert priceListItem;
        
        ccrz__E_ProductMedia__c  media = dbu_FactoryDataTest.createProductMedia(productObj.Id,'Product Image');
        insert media;
        
        Double qty = 10.00;
        ccrz__E_ProductInventoryItem__c inv = dbu_FactoryDataTest.createProductInventoryItem('TestInv',productObj.Id,qty,'Testing','In Stock');
        insert inv;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        insert ccSpec;
        
        ccrz__E_ProductSpec__c spec = new ccrz__E_ProductSpec__c();
        spec.ccrz__Spec__c = ccSpec.Id;
        spec.ccrz__Product__c = productObj.Id;
        spec.ccrz__SpecValue__c = '30 Lbs';
        insert spec;
        
        Test.startTest();
        dbu_GoogleMerchantController obj = new dbu_GoogleMerchantController();
        Database.executeBatch(obj);
        Test.stopTest();
        
    }

}