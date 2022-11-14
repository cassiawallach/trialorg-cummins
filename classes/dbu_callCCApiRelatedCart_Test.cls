/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-16-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//upadted
@isTest
public class dbu_callCCApiRelatedCart_Test {
    
    @testSetup static void testSetup() {
        
        ccrz__E_PriceList__c objTestPriceList = dbu_FactoryDataTest.createPriceList('Test Price List');
        insert objTestPriceList;
        Account objAcc = new Account(Name = 'Test Acc', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		 insert objAcc;
        ccrz__E_ContactAddr__c objShipTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
			insert objShipTo;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        //ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__ShipTo__c = objShipTo.Id);
        	//insert objCart;
        
        //ccrz__E_Product__c objProduct = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdef-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2019,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product', ccrz__ProductStatus__c = 'Released');
        //insert objProduct;
        
        ccrz__E_Product__c objProduct = dbu_FactoryDataTest.createProduct('TestProduct', false, false, true, false);
        objProduct.dbu_Has_Core_Charge__c = true;
        //TestProductList.add(TestProduct2);
        insert objProduct;                
        
        ccrz__E_ProductMedia__c objProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.Id, 'Product Search Image');
        insert objProductMedia;
        
        ccrz__E_PriceListItem__c objPriceListItem = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct.Id, objTestPriceList.Id);
 		insert objPriceListItem;
		
        ccrz__E_ProductInventoryItem__c objProdInv = dbu_FactoryDataTest.createProductInventoryItem('Test Env', objProduct.Id, 10, 'Test', 'In Stock');
        insert objProdInv;
        //ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            //insert objccCartItem;
        //ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product child', ccrz__SKU__c = 'Abcdeef-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2019,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product', ccrz__ProductStatus__c = 'Released');
        //insert objProduct1;
        
        ccrz__E_Product__c objProduct1 = dbu_FactoryDataTest.createProduct('TestProductchild', false, false, true, false);
        objProduct1.dbu_Has_Core_Charge__c = true;
        //TestProductList.add(TestProduct2);
        insert objProduct1; 
        

        ccrz__E_ProductMedia__c objProductMedia1 = dbu_FactoryDataTest.createProductMedia(objProduct1.id, 'Product Image');
        //ProductsMediaList.add(TestProductMedia1);        
        insert objProductMedia1;
        
        ccrz__E_PriceListItem__c objPriceListItem1 = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct1.Id, objTestPriceList.Id);
        insert objPriceListItem1;
        
        ccrz__E_RelatedProduct__c objRelatedProduct = dbu_FactoryDataTest.createRelatedProduct(objProduct1.id, objProduct.Id, 'Core Charge'); 
        insert objRelatedProduct;
	}
    
    static testMethod void unitTest() {
        Account acc = [select Id from Account where name = 'Test Acc' Limit 1];
        System.debug('acc========'+acc);
        Map<string,object> storefrontsettings = new Map<string,object>{
                'Name' => 'CSSNAStore',
                 'Customer Portal Acct Group Name' => 'PortalAccount',
                    'Root Category ID' => '999999',
                    'Customer Portal Account Name' => 'PortalAccount',
                    'Salesforce Server URL' => 'http://sfserverurl',
                    'Site Secure Domain' => System.Label.dbu_SiteSecureDomainTestclass,
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
                    };
                  
           ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale    = 'en_US';
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Product__c getobjProduct = [select id from ccrz__E_Product__c where name = 'TestProduct' limit 1];
        dbu_callCCApiRelatedCart.getProductList(new List<String>{getobjProduct.Id});
        dbu_callCCApiRelatedCart.getProductMap(new List<String>{getobjProduct.Id},'USD');
    }
    
}