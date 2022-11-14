/**

* @description : Test class for dbu_discountPriceUpdate.cls

* @author : Yash Sethi

* @group :

* @last modified on : 07-22-2022

* @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc

**/

@isTest
public class dbu_discountPriceUpdate_Test 
{
	@testSetup
    public static void testData()
    {
        ccrz__E_PriceList__c priceList = dbu_FactoryDataTest.createPriceList('Demo Price List');
        insert priceList;
        
        ccrz__E_Product__c lstEProduct = dbu_FactoryDataTest.createProduct('Demo Product', False, False, False, False);
        insert lstEProduct;
        
        ccrz__E_PriceListItem__c priceListItem = dbu_FactoryDataTest.createPriceListItem('Demo price list item', 100, 50, 'Percentage', 50, lstEProduct.id, priceList.id);
        insert priceListItem;
        
        ccrz__E_PriceList__c priceList2 = dbu_FactoryDataTest.createPriceList('Demo Price List CAD');
        priceList2.ccrz__CurrencyISOCode__c = 'CAD';
        insert priceList2;
        
        ccrz__E_Product__c lstEProduct2 = dbu_FactoryDataTest.createProduct('Demo Product CAD', False, False, False, False);
        insert lstEProduct2;
        
        ccrz__E_PriceListItem__c priceListItem2 = dbu_FactoryDataTest.createPriceListItem('Demo price list item CAD', 80, 50, 'Percentage', 50, lstEProduct2.id, priceList2.id);
        priceListItem2.dbu_Discount_Percent__c = 10;
        priceListItem2.dbu_Original_Price__c = null;
        insert priceListItem2;
    }
    
    @isTest
    public static void updateDiscount()
    {
        List<ccrz__E_PriceList__c> priceList = [Select id, ccrz__Storefront__c from ccrz__E_PriceList__c];
        List<ccrz__E_PriceListItem__c> itemList = [select id, dbu_Discount_Percent__c, dbu_Original_Price__c, ccrz__Price__c, ccrz__Pricelist__c, ccrz__Product__c from ccrz__E_PriceListItem__c WHERE dbu_Original_Price__c = 100  LIMIT 1];
        List<ccrz__E_PriceListItem__c> OriginalPriceChange = [select id, dbu_Discount_Percent__c, dbu_Original_Price__c, ccrz__Price__c, ccrz__Pricelist__c, ccrz__Product__c from ccrz__E_PriceListItem__c LIMIT 1];
        List<ccrz__E_PriceListItem__c> discountChange = [select id, dbu_Discount_Percent__c, dbu_Original_Price__c, ccrz__Price__c, ccrz__Pricelist__c, ccrz__Product__c from ccrz__E_PriceListItem__c LIMIT 1];
        
        List<ccrz__E_PriceListItem__c> itemListCAD = [select id, dbu_Discount_Percent__c, dbu_Original_Price__c, ccrz__Price__c, ccrz__Pricelist__c, ccrz__Product__c from ccrz__E_PriceListItem__c WHERE dbu_Discount_Percent__c = 10 LIMIT 1];
        
        map<id, ccrz__E_PriceListItem__c> oldItemMap = new map<id, ccrz__E_PriceListItem__c>();
        map<id, ccrz__E_PriceListItem__c> oriPriceMap = new map<id, ccrz__E_PriceListItem__c>();
        map<id, ccrz__E_PriceListItem__c> discountChangeMap = new map<id, ccrz__E_PriceListItem__c>();
        
        ccrz__E_PriceListItem__c pr = itemList[0];
        pr.ccrz__Price__c = 200;
        pr.dbu_Original_Price__c = 150;
        pr.dbu_Discount_Percent__c = 10;
        update pr;
        
        pr.dbu_Discount_Percent__c = null;
        update pr;
        
        ccrz__E_PriceListItem__c prCAD = itemListCAD[0];
        prCAD.ccrz__Price__c = 200;
        prCAD.dbu_Original_Price__c = 150;
        prCAD.dbu_Discount_Percent__c = 10;
        update prCAD;
        
        ccrz__E_PriceListItem__c pri = OriginalPriceChange[0];
        pri.dbu_Original_Price__c = 200;
        update pri;
        
        ccrz__E_PriceListItem__c dpri = discountChange[0];
        dpri.dbu_Discount_Percent__c = 20;
        update dpri;
        
        oldItemMap.put(pr.id, pr);
        oriPriceMap.put(pri.id, pri);
        discountChangeMap.put(dpri.id, dpri);
    }
}