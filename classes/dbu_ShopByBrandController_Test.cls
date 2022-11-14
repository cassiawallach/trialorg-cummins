@isTest
public class dbu_ShopByBrandController_Test {
    // Test method started 2.0
    @isTest static void createTestData() {
       
        ccrz__E_Category__c cateObj = new ccrz__E_Category__c();
        cateObj.Name = 'Cummins';
        cateObj.ccrz__CategoryID__c = '11';
        cateObj.CurrencyIsoCode = 'USD';
        cateObj.Storefront__c = 'CSSNAStore';
        cateObj.ccrz__LongDescRT__c = 'Testing';
		insert cateObj;
        
         ccrz__E_Category__c subCateObj = new ccrz__E_Category__c();
        subCateObj.Name = 'Cummins Genuine Parts';
         subCateObj.ccrz__CategoryID__c = '111';
        subCateObj.CurrencyIsoCode = 'USD';
        subCateObj.Storefront__c = 'CSSNAStore';
        subCateObj.ccrz__LongDescRT__c = 'Testing';
        subCateObj.ccrz__ParentCategory__c = cateObj.Id;
		insert subCateObj;//INC2186060
        
         ccrz__E_Category__c subsubCateObj = new ccrz__E_Category__c();
        subsubCateObj.Name = 'Aftertreatment';
        subsubCateObj.ccrz__CategoryID__c = '1003';
        subsubCateObj.CurrencyIsoCode = 'USD';
        subsubCateObj.Storefront__c = 'CSSNAStore';
        subsubCateObj.ccrz__LongDescRT__c = 'Testing';
        subsubCateObj.ccrz__ParentCategory__c = subCateObj.Id;
		insert subsubCateObj;
        
       ccrz__E_Product__c prodObj =  dbu_FactoryDataTest.createProduct('Cummins Bearing', true, false, false, true);
       prodObj.DBU_Product_Location__c = 'US';
        prodObj.ccrz__Quantityperunit__c = 1;
        prodObj.dbu_Image_Src__c = 'https://www.google.com';
        insert prodObj;
        
        ccrz__E_PriceList__c  priceListObj =  dbu_FactoryDataTest.createPriceList('TestPriceList');
        insert priceListObj;
        
        ccrz__E_PriceListItem__c  priceListItemObj = new ccrz__E_PriceListItem__c();
        priceListItemObj.ccrz__Price__c = 100.00;
        priceListItemObj.dbu_Original_Price__c = 150.00;
        priceListItemObj.CurrencyIsoCode = 'USD';
        priceListItemObj.ccrz__Pricelist__c = priceListObj.Id;
        priceListItemObj.ccrz__Product__c = prodObj.Id;
        insert priceListItemObj;
        
        ccrz__E_ProductMedia__c prodMediaObj = dbu_FactoryDataTest.createProductMedia(prodObj.Id,'Product Image');
        insert prodMediaObj;
        
        ccrz__E_ProductCategory__c prodCateObj = new ccrz__E_ProductCategory__c();
        prodCateObj.ccrz__Product__c = prodObj.Id;
        prodCateObj.ccrz__Category__c = subsubCateObj.Id;
        insert prodCateObj; 
        
        ccrz__E_ProductInventoryItem__c prodInventoryObj = new ccrz__E_ProductInventoryItem__c();
        prodInventoryObj.ccrz__ProductItem__c = prodObj.Id;
        prodInventoryObj.ccrz__QtyAvailable__c = 2;
        prodInventoryObj.CurrencyIsoCode = 'USD';
        insert prodInventoryObj;
        
        test.startTest();
        dbu_shopByBrandController.getSubCategoryByParentCategoryName('US', 'Cummins');
        
        test.stopTest();
        
    }
}