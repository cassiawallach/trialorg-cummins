/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-21-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_dealsPageController_Test 

{
    @testSetup
	public static void testData()
    {
        ccrz__E_Product__c TestProduct = dbu_FactoryDataTest.createProduct('79464646', true, true, true, false);
        TestProduct.DBU_Product_Location__c = 'US';
        insert TestProduct;
        
        ccrz__E_PriceList__c priceList = dbu_FactoryDataTest.createPriceList('Price List');
        insert priceList;
        
        ccrz__E_PriceListItem__c pli = dbu_FactoryDataTest.createPriceListItem('pli', 100, 10, 'Percentage', 90, TestProduct.id, priceList.id);
        pli.dbu_Discount_Percent__c = 10;
        insert pli;

		ccrz__E_Product__c promotionTestProduct = dbu_FactoryDataTest.createProduct('79464699', true, true, true, false);
        insert promotionTestProduct;		
        
        ccrz__E_Category__c ccParentCategory = new ccrz__E_Category__c();
        ccParentCategory.Name = 'Parent Category';
        ccParentCategory.Storefront__c = 'CSSNAStore';
        ccParentCategory.ccrz__CategoryID__c = '999999';
        ccParentCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        ccParentCategory.ccrz__Sequence__c = 1;
        ccParentCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        ccParentCategory.dbu_Category_Location__c = 'US';
        insert ccParentCategory;
        
        ccrz__E_Category__c ccChildCategory = new ccrz__E_Category__c();
        ccChildCategory.Name = 'Child Category';
        ccChildCategory.Storefront__c = 'CSSNAStore';
        ccChildCategory.ccrz__CategoryID__c = '3444';
        ccChildCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        ccChildCategory.ccrz__Sequence__c = 3;
        ccChildCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        ccChildCategory.ccrz__ParentCategory__c = ccParentCategory.id;
        ccChildCategory.dbu_Category_Location__c = 'US';
        insert ccChildCategory;
        
        ccrz__E_Category__c ccGrandChildCategory = new ccrz__E_Category__c();
        ccGrandChildCategory.Name = 'Grand Child Category';
        ccGrandChildCategory.Storefront__c = 'CSSNAStore';
        ccGrandChildCategory.ccrz__CategoryID__c = '3443';
        ccGrandChildCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        ccGrandChildCategory.ccrz__Sequence__c = 3;
        ccGrandChildCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        ccGrandChildCategory.ccrz__ParentCategory__c = ccChildCategory.id;
        ccGrandChildCategory.dbu_Category_Location__c = 'US';
        insert ccGrandChildCategory;
        
        ccrz__E_ProductCategory__c prodCategory = new ccrz__E_ProductCategory__c();
        prodCategory.ccrz__Product__c = TestProduct.id;
        prodCategory.ccrz__Category__c = ccChildCategory.id;
        prodCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        prodCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        insert prodCategory;
        
        
        ccrz__E_Category__c ccParentPromotionCategory = new ccrz__E_Category__c();
        ccParentPromotionCategory.Name = 'Parent Promotion Category';
        ccParentPromotionCategory.Storefront__c = 'CSSNAStore';
        ccParentPromotionCategory.ccrz__CategoryID__c = '8888888';
        ccParentPromotionCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        ccParentPromotionCategory.ccrz__Sequence__c = 1;
        ccParentPromotionCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        ccParentPromotionCategory.dbu_isPromotion__c = TRUE;
        ccParentPromotionCategory.dbu_Category_Location__c = 'US';       
        insert ccParentPromotionCategory;
        
        ccrz__E_Category__c ccChildPromotionCategory = new ccrz__E_Category__c();
        ccChildPromotionCategory.Name = 'Child Promotion Category';
        ccChildPromotionCategory.Storefront__c = 'CSSNAStore';
        ccChildPromotionCategory.ccrz__CategoryID__c = '7777777';
        ccChildPromotionCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        ccChildPromotionCategory.ccrz__Sequence__c = 1;
        ccChildPromotionCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        ccChildPromotionCategory.dbu_isPromotion__c = TRUE;
        ccChildPromotionCategory.ccrz__ParentCategory__c = ccParentPromotionCategory.id;
        ccChildPromotionCategory.dbu_Category_Location__c = 'US';
        insert ccChildPromotionCategory;
        
        ccrz__E_ProductCategory__c promotionProdCategory = new ccrz__E_ProductCategory__c();
        promotionProdCategory.ccrz__Product__c = promotionTestProduct.id;
        promotionProdCategory.ccrz__Category__c = ccChildPromotionCategory.id;
        promotionProdCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
        promotionProdCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
        insert promotionProdCategory;
        
        ccrz__E_Promo__c promo = new ccrz__E_Promo__c();
        promo.ccrz__Enabled__c = TRUE;
        promo.ccrz__EndDate__c = Date.parse('6/20/2099');
        promo.ccrz__StartDate__c = Date.parse('6/20/2019');
        promo.ccrz__Storefront__c = 'CSSNAStore';
        promo.dbu_store_location__c = 'US';
        promo.ccrz__Product__c = TestProduct.id;
        promo.ccrz__Sequence__c = 1;
        insert promo;
        
    }
    
    @isTest
    public static void testProductCountWhenFilter()
    {
        List<ccrz__E_Category__c> parentCategory = [Select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c = NULL AND dbu_isPromotion__c = FALSE LIMIT 1];
        List<ccrz__E_Category__c> childCategory = [Select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :parentCategory AND dbu_isPromotion__c = FALSE LIMIT 1];
        List<ccrz__E_Category__c> grandChildCategory = [Select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :childCategory AND dbu_isPromotion__c = FALSE LIMIT 1];
               
        List<ccrz__E_Promo__c> promo = [Select id from ccrz__E_Promo__c LIMIT 1];
        List<ccrz__E_Product__c>prodList = [Select id from ccrz__E_Product__c WHERE NAME LIKE '79464646' LIMIT 1];
        List<ccrz__E_PriceListItem__c> pli = [select id from ccrz__E_PriceListItem__c LIMIT 1];
        
        
        List<string>categoryIdList = new List<string>();
        categoryIdList.add(parentCategory[0].id);
        
        dbu_dealsPageController.productCountWhenFilter(JSON.serialize(categoryIdList), 'US');
        dbu_dealsPageController.fetchCategoriesForDealsPage('US');
        dbu_dealsPageController.fetchProductsForClearance('US', 'name');
        dbu_dealsPageController.fetchProductsFromCategoryIds(JSON.serialize(categoryIdList), 'US', 1, 10);
    }
}