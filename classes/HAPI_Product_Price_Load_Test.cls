@isTest
private class HAPI_Product_Price_Load_Test {

	private static testMethod void HAPI_ProductLoad_ExcelSheetGenerator_Test() {
	    
	    ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        ccrz__E_Category__c cat = new ccrz__E_Category__c();
        cat.Name = 'Test';
        cat.ccrz__CategoryID__c = '501020';
        cat.ccrz__LongDesc__c = 'test';
        insert cat;
        
        ccrz__E_Menu__c menu = new ccrz__E_Menu__c();
        menu.ccrz__Category__c = cat.Id;
        menu.ccrz__DisplayName__c = 'test';
        insert menu;
        
        ccrz__E_MenuItem__c menuItem = new ccrz__E_MenuItem__c();
        menuItem.ccrz__Category__c = cat.Id;
        menuItem.ccrz__Menu__c = menu.Id;
        menuItem.ccrz__Product__c = prod.Id;
        menuItem.ccrz__DisplayName__c = 'test';
        insert menuItem;
        
        ccrz__E_FeaturedProduct__c featProd = new ccrz__E_FeaturedProduct__c();
        featProd.Name = 'test';
        featProd.ccrz__Product__c = prod.Id;
        featProd.CC_Category__c = cat.Id;
        insert featProd;
        
        ccrz__E_FeaturedProduct__c featProd2 = new ccrz__E_FeaturedProduct__c();
        featProd2.Name = 'test2';
        featProd2.ccrz__Product__c = prod.Id;
        featProd2.CC_Category__c = cat.Id;
        insert featProd2;
        
        ccrz__E_CompositeProduct__c compProd = new ccrz__E_CompositeProduct__c();
        compProd.ccrz__Category__c = cat.Id;
        compProd.ccrz__Component__c = prod.Id;
        insert compProd;
        
        ccrz__E_CompositeProduct__c compProd2 = new ccrz__E_CompositeProduct__c();
        compProd2.ccrz__Category__c = cat.Id;
        compProd2.ccrz__Component__c = prod.Id;
        insert compProd2;
        
        ccrz__E_RelatedProduct__c relProd = new ccrz__E_RelatedProduct__c();
        relProd.ccrz__Product__c = prod.Id;
        relProd.ccrz__RelatedProductType__c = 'Competitive';
        insert relProd;
        
        ccrz__E_RelatedProduct__c relProd2 = new ccrz__E_RelatedProduct__c();
        relProd2.ccrz__Product__c = prod.Id;
        relProd2.ccrz__RelatedProductType__c = 'Competitive';
        insert relProd2;
        
        ccrz__E_ProductCategory__c prodCat = new ccrz__E_ProductCategory__c();
        prodCat.ccrz__Category__c = cat.Id;
        prodCat.ccrz__Product__c = prod.Id;
        insert prodCat;
        
        ccrz__E_ProductCategory__c prodCat2 = new ccrz__E_ProductCategory__c();
        prodCat2.ccrz__Category__c = cat.Id;
        prodCat2.ccrz__Product__c = prod.Id;
        insert prodCat2;
        
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
        spec.Name = 'test';
        spec.ccrz__DisplayName__c = 'test';
        insert spec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__Product__c = prod.Id;
        prodSpec.ccrz__Spec__c = spec.Id;
        insert prodSpec;
        
        ccrz__E_ProductSpec__c prodSpec2 = new ccrz__E_ProductSpec__c();
        prodSpec2.ccrz__Product__c = prod.Id;
        prodSpec2.ccrz__Spec__c = spec.Id;
        insert prodSpec2;
        
        Test.startTest();
        
        HAPI_ProductLoad_ExcelSheetGenerator.generateProductLoadExcelSheet('1', 'test@test.com');
            
        Test.stopTest();

	}
	
	private static testMethod void HAPI_RunProductLoader_Ctrl_Test() {
	    
	    Test.startTest();
	    
	    HAPI_RunProductLoader_Ctrl objCtrl = new HAPI_RunProductLoader_Ctrl();
	    objCtrl.version = '1';
	    objCtrl.show();
	    
	    Test.stopTest();
	}
	
	private static testMethod void HAPI_RunPriceLoader_Ctrl_Test() {
	    
	    Test.startTest();
	    
	    HAPI_RunPriceLoader_Ctrl objCtrl = new HAPI_RunPriceLoader_Ctrl();
	    objCtrl.version = '1';
	    objCtrl.show();
	    
	    Test.stopTest();
	}

}