@isTest
public with sharing class dbu_ccApiRelatedProduct_Test {
    
    @isTest
    static void getRelatedProductListTest(){
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        system.debug('AccountRecordType > ' + AccountRecordType);
        
        Account TestAcc = dbu_FactoryDataTest.createIAMAccount('TestACC' , AccountRecordType);
        insert TestAcc;
        
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        objProduct.Name = 'Test Product1';
        objProduct.ccrz__SKU__c = 'Test SKU1';//INC2544526
        objProduct.ccrz__ProductStatus__c = 'Released';
        objProduct.ccrz__Storefront__c = 'CSSNAStore';
        objProduct.Group_Name__c = 'Ecom';
        objProduct.ccrz__ProductType__c = 'Product';
        Insert	objProduct; 
        
        ccrz__E_Product__c objProducts = new ccrz__E_Product__c();
        objProduct.Name = 'Test Product2';
        objProducts.ccrz__SKU__c = 'Test Sku2';
        objProducts.ccrz__ProductStatus__c = 'Released';
        objProducts.ccrz__Storefront__c = 'CSSNAStore';
        objProducts.Group_Name__c = 'Ecom';
        objProducts.ccrz__ProductType__c = 'Product';
        Insert	objProducts; 
        
        ccrz__E_PriceList__c objccrzEPriceLst = dbu_FactoryDataTest.createPriceList('TestPricelistName1');
        Insert objccrzEPriceLst;
        
        ccrz__E_PriceListItem__c objccrzEPriceLstItem = dbu_FactoryDataTest.createPriceListItem ('testPricelistItemName1',100, 20,'Absolute',300,objProducts.Id,objccrzEPriceLst.Id);
        Insert objccrzEPriceLstItem;
        
        ccrz__E_ProductMedia__c objccrzEProductMda = dbu_FactoryDataTest.createProductMedia(objProducts.ID ,'Product Search Image');
        Insert objccrzEProductMda;
     
        //Price List
        // ccrz__E_PriceList__c objccrzEPriceList = dbu_FactoryDataTest.createPriceList('TestPricelistName');
        //Insert objccrzEPriceList;
        
        //Price List Item
        ccrz__E_PriceListItem__c objccrzEPriceListItem = dbu_FactoryDataTest.createPriceListItem ('testPricelistItemName',100, 20,'Absolute',300,objProduct.Id,objccrzEPriceLst.Id);
        Insert objccrzEPriceListItem;
        //Price List Item
        ccrz__E_ProductMedia__c objccrzEProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.ID ,'Product Search Image');
        Insert objccrzEProductMedia;
        
        ccrz__E_RelatedProduct__c relatedProductObj  = new ccrz__E_RelatedProduct__c();
        relatedProductObj.ccrz__RelatedProductType__c = 'CrossSell';
        relatedProductObj.ccrz__EndDate__c = Date.parse('6/20/2099');
        relatedProductObj.ccrz__StartDate__c = Date.parse('12/31/2019');
        relatedProductObj.ccrz__Sequence__c = 600;
        relatedProductObj.ccrz__RelatedProduct__c = objProducts.Id;
        relatedProductObj.ccrz__Product__c = objProduct.Id;
        insert relatedProductObj;
        
        Map<string,object> storefrontsettings = new Map<string,object>
        { 
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => System.Label.dbu_SiteSecureDomainTestclass,
                //'dbuecomdev-cumminscss.cs24.force.com/CSSNAStore',
                
                'E Commerce Type' => 'B2C',
                'Cart From Email' => 'Do Not Use Org Wide Email',
                'Order From Email' => 'Do Not Use Org Wide Email',
                'SEO Title Detail' => 'CloudBurst Direct',
                'SEO Keywords' => 'SEO Keywords',
                'SEO Description' => 'SEO Description',
                'SEO Title Site' => 'B2C Information Technology Sales',
                'SearchRank_ExactProductNum' => 700.0,
                'SearchRank_inDisplayName' => 200.0,
                'SearchRank_inProdNum' => 100.0,
                'SearchRank_ShortDesc' => 50.0,
                'Dev Mode' => true,
                'Allow Anonymous Checkout' => true,
                'Quoting Enabled' => true,
                'Send Confirmation Email' => true,
                'Display Coupon on Cart' => true,
                'Filter Orders Based on Owner' => true                  
                } ;
                    
                    ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'CSSNAStore';
        ccrz.cc_CallContext.currAccountId = TestAcc.id;
        ccrz.cc_CallContext.userCurrency = 'USD';//currencyISOvalue in main class
        ccrz.cc_CallContext.effAccountId = TestAcc.id;
        //ccrz.cc_CallContext.currCartId = cartID;
        ccrz.cc_CallContext.userLocale    = 'en_US';
        //ccrz.cc_CallContext.currContact= cnts;
        ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
        ccrz.cc_CallContext.initRemoteContext(ctx);           
        
        List<String> ids = new list<String>();
        ids.add(objProduct.Id);        
        string urlVar = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/product?pId='+objProduct.id+'&store=EN';
        
        ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
        cart.ccrz__ShipAmount__c = 40.00;
        cart.dbu_Free_Shipping__c = false;
        insert cart;
               
        
        Test.startTest();
        //dbu_ccApiRelatedProduct.getRelatedProductList(urlVar);
        dbu_ccApiRelatedProduct.getRealatedProduct(objProduct.Id);
        dbu_ccApiRelatedProduct.getProducts(ids);
        dbu_ccApiRelatedProduct.getProductPrice(ids);
        dbu_ccApiRelatedProduct.getRelatedProductList(urlVar);
       	dbu_ccApiRelatedProduct.getShippingAmount((String)cart.Id);
        Test.stopTest();
        
    }
}