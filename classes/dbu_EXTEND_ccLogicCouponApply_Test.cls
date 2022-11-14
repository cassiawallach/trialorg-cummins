@isTest
public class dbu_EXTEND_ccLogicCouponApply_Test {
	
    @isTest
    static void testmethod1(){
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
        
        System.runAs(admin) { 
        
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        	TestProduct3.dbu_Crate_Engine__c = true;    
        	TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
            TestProductList.add(TestProduct5);
            
            List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
            list<ccrz__E_ProductMedia__c>  ProductsMediaList	 = new list<ccrz__E_ProductMedia__c>();
            list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
            
            Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false);                
            Integer Count = 0;
            for (Database.SaveResult sr : TestProductInsertedList) {            
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    
                    //Setup Product Media 
                    ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Image');
                    ProductsMediaList.add(TestProductMedia1);
                    
                    ccrz__E_ProductMedia__c TestProductMedia2 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Search Image');
                    ProductsMediaList.add(TestProductMedia2);
                    
                    //Setup Product Inventory Item
                    string ProductInventoryItemName =	'ProdInv'+Count;
                    double QuantityAvailable		=	10+Count;
                    string availablemessage 		=	'In stock';
                    string status					=	'In Stock';
                    ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                    ProductsINvlist.add(TestProdInventory);
                    
                    string PricelistitemName = 'PricelistItem'+Count;
                    double OriginalPrice	 = 100+Count;
                    double discountAmt 		 = 15+Count;
                    double Price 			 = OriginalPrice - discountAmt;                
                    
                    //Setup PriceListItem for the product
                    ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, sr.getId(), TestPricelist.id);                
                    ProductPriceListItems.add(TestPriceListItem);
                    
                    
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            //insert pricelist items
            insert ProductPriceListItems;
            
            //insert product medias
            insert ProductsMediaList;
            
            //insert Product inventory 
            insert ProductsINvlist;

			ccrz__E_Product__c couponProduct = dbu_FactoryDataTest.createProduct('Couponproduct', false, false, false , false );            
            couponProduct.ccrz__ProductType__c  = 'Coupon';
            insert couponProduct;
            
            //create a coupon 
            ccrz__E_Coupon__c CARTCOUPON = new ccrz__E_Coupon__c();
            CARTCOUPON.ccrz__CouponName__c = 'copon for cart';
            CARTCOUPON.ccrz__CouponCode__c = 'T90MBT';
            CARTCOUPON.ccrz__CouponType__c = 'Absolute';
            CARTCOUPON.OSM_Coupon_Discount_Target_Type__c = 'MSRP';
           	CARTCOUPON.ccrz__DiscountAmount__c = 10.00;
            CARTCOUPON.ccrz__MaxUse__c = 20000;
            CARTCOUPON.ccrz__Storefront__c = 'CSSNAStore';
            CARTCOUPON.ccrz__DiscountType__c = 'Absolute';
            CARTCOUPON.ccrz__RuleType__c = 'CartTotal';
            CARTCOUPON.ccrz__TotalUsed__c = 0;
            CARTCOUPON.ccrz__StartDate__c = date.parse('9/1/2020');
            CARTCOUPON.ccrz__EndDate__c = date.parse('9/1/2099');  
            CARTCOUPON.ccrz__CartTotalAmount__c = 50;
            insert CARTCOUPON;            
            

            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();  
            
            //ccrz__E_Cart__c		 cartItem					=	dbu_FactoryDataTest.createCart('MyCart', 'Cart', admin.id, con.id, acc.id, true);
            ccrz__E_Cart__c	cartItem						=	new ccrz__E_Cart__c();
            cartItem.ccrz__Name__c							=	'MyCart';
            cartItem.ccrz__CartType__c						=	'Cart';
            cartItem.ccrz__CurrencyISOCode__c				=	'USD';
            cartItem.ccrz__ActiveCart__c					=	true;
            cartItem.ccrz__Storefront__c					=	'CSSNAStore';
            cartItem.ccrz__CartStatus__c					=	'Open';                                             
            insert cartItem;
            
            //Insert cartcoupon record
            ccrz__E_CartCoupon__c currenctCartCoupon = new ccrz__E_CartCoupon__c();
            currenctCartCoupon.ccrz__Cart__c = cartItem.id;
            currenctCartCoupon.ccrz__Coupon__c = CARTCOUPON.id;
            currenctCartCoupon.ccrz__Enabled__c = false;
            insert currenctCartCoupon;
            
            
            
            double Qcounter = 1;    
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(cartItem.id, 300, Qcounter, PrcLn.ccrz__Product__c);
                crtline.ccrz__PricingType__c = 'auto';      
                crtline.ccrz__SubAmount__c = 300*Qcounter;
                Qcounter = Qcounter + 1;
                crtLinesList.add(crtline);
            }
           
            
            ccrz__E_CartItem__c couponcartitem = new ccrz__E_CartItem__c();
            couponcartitem.ccrz__Cart__c = cartItem.id;
            couponcartitem.ccrz__Coupon__c = CARTCOUPON.id;
            couponcartitem.ccrz__ProductType__c = 'Coupon';
            couponcartitem.ccrz__StoreID__c = 'CSSNAStore';
            couponcartitem.ccrz__cartItemType__c = 'Coupon';
            couponcartitem.ccrz__Price__c = -10;
            couponcartitem.ccrz__Quantity__c = 1;
            couponcartitem.ccrz__Product__c = couponProduct.id;
            couponcartitem.ccrz__SubAmount__c	= -10*1;
            couponcartitem.CurrencyIsoCode = 'USD';
            //insert couponcartitem;
            
            crtLinesList.add(couponcartitem);
            insert crtLinesList;       
            list<ccrz__E_CartItem__c> crtlist = new list<ccrz__E_CartItem__c>();
            

            ccrz__E_Cart__c currentcartdet = [select id,ccrz__TotalAmount__c from ccrz__E_Cart__c where id =: cartItem.id];
			system.debug('currentcartdet /> ' + currentcartdet);

        Map<string,object> inputmap = new Map<string,object>();
          inputmap.put('cartId', cartItem.id);  
           inputmap.put('ccApiCouponCode', 'T90MBT');  
           inputmap.put('abosolute coupon success', false);  
            inputmap.put('success', true);
           
            Test.startTest();
                	dbu_EXTEND_ccLogicCouponApply li = new dbu_EXTEND_ccLogicCouponApply();
            li.performDML(inputmap);
            li.prepReturn(inputmap);
            test.stopTest(); 
            
            
        }        
        
        
    }

    @isTest
    static void testmethod2(){
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
        
        System.runAs(admin) { 
        
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        	TestProduct3.dbu_Crate_Engine__c = true;    
        	TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
            TestProductList.add(TestProduct5);
            
            List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
            list<ccrz__E_ProductMedia__c>  ProductsMediaList	 = new list<ccrz__E_ProductMedia__c>();
            list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
            
            Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false);                
            Integer Count = 0;
            for (Database.SaveResult sr : TestProductInsertedList) {            
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    
                    //Setup Product Media 
                    ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Image');
                    ProductsMediaList.add(TestProductMedia1);
                    
                    ccrz__E_ProductMedia__c TestProductMedia2 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Search Image');
                    ProductsMediaList.add(TestProductMedia2);
                    
                    //Setup Product Inventory Item
                    string ProductInventoryItemName =	'ProdInv'+Count;
                    double QuantityAvailable		=	10+Count;
                    string availablemessage 		=	'In stock';
                    string status					=	'In Stock';
                    ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                    ProductsINvlist.add(TestProdInventory);
                    
                    string PricelistitemName = 'PricelistItem'+Count;
                    double OriginalPrice	 = 100+Count;
                    double discountAmt 		 = 15+Count;
                    double Price 			 = OriginalPrice - discountAmt;                
                    
                    //Setup PriceListItem for the product
                    ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, sr.getId(), TestPricelist.id);                
                    ProductPriceListItems.add(TestPriceListItem);
                    
                    
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            //insert pricelist items
            insert ProductPriceListItems;
            
            //insert product medias
            insert ProductsMediaList;
            
            //insert Product inventory 
            insert ProductsINvlist;

			ccrz__E_Product__c couponProduct = dbu_FactoryDataTest.createProduct('Couponproduct', false, false, false , false );            
            couponProduct.ccrz__ProductType__c  = 'Coupon';
            insert couponProduct;
            
            //create a coupon 
            ccrz__E_Coupon__c CARTCOUPON = new ccrz__E_Coupon__c();
            CARTCOUPON.ccrz__CouponName__c = 'copon for cart';
            CARTCOUPON.ccrz__CouponCode__c = 'T90MBT';
            CARTCOUPON.ccrz__CouponType__c = 'Absolute';
            CARTCOUPON.OSM_Coupon_Discount_Target_Type__c = 'MSRP';
           	CARTCOUPON.ccrz__DiscountAmount__c = 700.00;
            CARTCOUPON.ccrz__MaxUse__c = 20000;
            CARTCOUPON.ccrz__Storefront__c = 'CSSNAStore';
            CARTCOUPON.ccrz__DiscountType__c = 'Absolute';
            CARTCOUPON.ccrz__RuleType__c = 'CartTotal';
            CARTCOUPON.ccrz__TotalUsed__c = 0;
            CARTCOUPON.ccrz__StartDate__c = date.parse('9/1/2020');
            CARTCOUPON.ccrz__EndDate__c = date.parse('9/1/2099');  
            CARTCOUPON.ccrz__CartTotalAmount__c = 50;
            insert CARTCOUPON;            
            

            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();  
            
            //ccrz__E_Cart__c		 cartItem					=	dbu_FactoryDataTest.createCart('MyCart', 'Cart', admin.id, con.id, acc.id, true);
            ccrz__E_Cart__c	cartItem						=	new ccrz__E_Cart__c();
            cartItem.ccrz__Name__c							=	'MyCart';
            cartItem.ccrz__CartType__c						=	'Cart';
            cartItem.ccrz__CurrencyISOCode__c				=	'USD';
            cartItem.ccrz__ActiveCart__c					=	true;
            cartItem.ccrz__Storefront__c					=	'CSSNAStore';
            cartItem.ccrz__CartStatus__c					=	'Open';                                             
            insert cartItem;
            
            //Insert cartcoupon record
            ccrz__E_CartCoupon__c currenctCartCoupon = new ccrz__E_CartCoupon__c();
            currenctCartCoupon.ccrz__Cart__c = cartItem.id;
            currenctCartCoupon.ccrz__Coupon__c = CARTCOUPON.id;
            currenctCartCoupon.ccrz__Enabled__c = false;
            insert currenctCartCoupon;
            
            
            
            double Qcounter = 0;    
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(cartItem.id, 20, Qcounter, PrcLn.ccrz__Product__c);
                crtline.ccrz__PricingType__c = 'auto';              
                Qcounter = Qcounter + 1;
                crtLinesList.add(crtline);
            }
           
            
            ccrz__E_CartItem__c couponcartitem = new ccrz__E_CartItem__c();
            couponcartitem.ccrz__Cart__c = cartItem.id;
            couponcartitem.ccrz__Coupon__c = CARTCOUPON.id;
            couponcartitem.ccrz__ProductType__c = 'Coupon';
            couponcartitem.ccrz__StoreID__c = 'CSSNAStore';
            couponcartitem.ccrz__cartItemType__c = 'Coupon';
            couponcartitem.ccrz__Price__c = -700;
            couponcartitem.ccrz__Quantity__c = 1;
            couponcartitem.ccrz__Product__c = couponProduct.id;
            couponcartitem.CurrencyIsoCode = 'USD';
            //insert couponcartitem;
            
            crtLinesList.add(couponcartitem);
            insert crtLinesList;       
            list<ccrz__E_CartItem__c> crtlist = new list<ccrz__E_CartItem__c>();
            

            


        Map<string,object> inputmap = new Map<string,object>();
          inputmap.put('cartId', cartItem.id);  
           inputmap.put('ccApiCouponCode', 'T90MBT');  
           inputmap.put('abosolute coupon success', false);  
            inputmap.put('success', true);
           
            Test.startTest();
            dbu_EXTEND_ccLogicCouponApply li = new dbu_EXTEND_ccLogicCouponApply();
            li.performDML(inputmap);
            //li.prepReturn(inputmap);
            test.stopTest(); 
            
            
        }        
        
        
    }    
}