@isTest
public class dbu_homePageCategoryTileCtrl_Test {
    static testMethod void testhomePageCategoryTileCtrl(){ 
        Integer pageNum = 1;
        Integer numberofrecord = 12;
        String sortOptions = 'lower';
        Integer recorsdToSkip = 0;
        List<Id> lstategory = new List<Id>();
        ccrz__E_Category__c objCategoryParent = new ccrz__E_Category__c();
        ccrz__E_Category__c objCategory = new ccrz__E_Category__c();
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        ccrz__E_ProductCategory__c objProductCategory = new ccrz__E_ProductCategory__c();
        ccrz__E_Promo__c objpromotion=new ccrz__E_Promo__c();
        
        //Parent Category
            objCategoryParent.Name = 'testcategoryParent';
        	objCategoryParent.ccrz__CategoryID__c = '2058';
       		objCategoryParent.Storefront__c = 'CSSNAStore';
        	objCategoryParent.ccrz__Sequence__c = 500.0;
        Insert objCategoryParent;
        System.debug('objCategoryParent>>>' + objCategoryParent);
        
        //Category
            objCategory.Name = 'testcategory';
        	objCategory.ccrz__CategoryID__c = '1107';
       		objCategory.Storefront__c = 'CSSNAStore';
        	objCategory.ccrz__Sequence__c = 500.0;
        	objCategory.ccrz__ParentCategory__c = objCategoryParent.Id;
        	objCategory.dbu_isPromotion__c=false;
         Insert objCategory;
         System.debug('objCategory>>>' + objCategory);
        
         //Product
            objProduct.Name = 'Cummins Rectangular Ring Seal 100099';
            objProduct.ccrz__SKU__c = '100099CECO';
            objProduct.ccrz__ProductStatus__c = 'Released';
            objProduct.ccrz__Storefront__c = 'CSSNAStore';
            objProduct.Group_Name__c = 'Ecom';
            objProduct.ccrz__ProductType__c = 'Product';
        	objProduct.DBU_Product_Location__c = 'CA';
            objProduct.ccrz__StartDate__c=system.today();
            objProduct.ccrz__EndDate__c=system.today()+2;
        Insert	objProduct; 
		System.debug('objProduct>>>' + objProduct);
        
        //Price List
            ccrz__E_PriceList__c objccrzEPriceList = dbu_FactoryDataTest.createPriceList('TestPricelistName');
        Insert objccrzEPriceList;
        
        //Price List Item
        	ccrz__E_PriceListItem__c objccrzEPriceListItem = dbu_FactoryDataTest.createPriceListItem ('testPricelistItemName',100, 20,'Absolute',300,objProduct.Id,objccrzEPriceList.Id);
        Insert objccrzEPriceListItem;
        
        //Price List Item
        	ccrz__E_ProductMedia__c objccrzEProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.ID ,'Product Search Image');
        Insert objccrzEProductMedia;
        
        //Product Category
        	objProductCategory.ccrz__Category__c = objCategory.Id;
        	objProductCategory.ccrz__Product__c = objProduct.Id;
        	
        Insert objProductCategory;
        System.debug('objProductCategory>>>' + objProductCategory);
        
        
        //Promotion
        objpromotion.name='Clearance Sale';
        objpromotion.ccrz__Sequence__c=1;
        objpromotion.CurrencyIsoCode='CAD';
        objpromotion.ccrz__StartDate__c=System.today();
        objpromotion.ccrz__EndDate__c=System.today() +2;
        objpromotion.ccrz__StorefrontMS__c='CSSNAStore';
        objpromotion.dbu_store_location__c='EN';
        objpromotion.ccrz__Product__c=objProduct.id;
        objpromotion.ccrz__Enabled__c=TRUE;
        objpromotion.ccrz__Category__c=objCategory.id;
        insert objpromotion;
        
    
        //dbu_SubSubCategoryNamewithCountWrapper Wrapper Class.
            List<dbu_SubSubCategoryNamewithCountWrapper> lstdbu_SubSubCategoryNamewithCountWrapper = new List<dbu_SubSubCategoryNamewithCountWrapper>();
            dbu_SubSubCategoryNamewithCountWrapper objdbuSubSubCategoryNamewithCountWrapper = new dbu_SubSubCategoryNamewithCountWrapper();
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryName = 'testsubsubcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryproductCount = 1; 
                objdbuSubSubCategoryNamewithCountWrapper.categoryName = 'testcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryid = objCategory.Id;
           
            lstdbu_SubSubCategoryNamewithCountWrapper.add(objdbuSubSubCategoryNamewithCountWrapper);

        	lstategory.add(objCategoryParent.Id);
        
         
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
            };
		    ccrz.cc_CallContext.userLocale    = 'en_US';

            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            //ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            //ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale    = 'en_US';
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);           
        
        Test.startTest();  
			dbu_homePageCategoryTileCtrl.getProductBreadCrumb(objCategory.Id);
        	dbu_homePageCategoryTileCtrl.getProductBreadCrumbSubCategory(objCategory.Id);
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('CA');
        	dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryName(objCategory.Name);
        	dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryId(objCategory.Id,'US');
        	dbu_homePageCategoryTileCtrl.getDescriptionBySubCategoryId(objCategory.Id);
            dbu_homePageCategoryTileCtrl.getSubCategoryWithProductByCategoryId(objCategoryParent.Id,'CA');
        	dbu_homePageCategoryTileCtrl.getProductDetailsBySubCategoryId(json.serialize(lstategory), pageNum, numberofrecord,sortOptions,'CA'); 	
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('US');
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('EN');
        Test.stopTest(); 
    }
    static testMethod void testhomePageCategoryTileCtrl1(){ 
        Integer pageNum = 1;
        Integer numberofrecord = 12;
        String sortOptions = 'lower';
        Integer recorsdToSkip = 0;
        List<Id> lstategory = new List<Id>();
        ccrz__E_Category__c objCategoryParent = new ccrz__E_Category__c();
        ccrz__E_Category__c objCategory = new ccrz__E_Category__c();
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        ccrz__E_ProductCategory__c objProductCategory = new ccrz__E_ProductCategory__c();
        
        //Parent Category
            objCategoryParent.Name = 'testcategoryParent';
        	objCategoryParent.ccrz__CategoryID__c = '2058';
       		objCategoryParent.Storefront__c = 'CSSNAStore';
        	objCategoryParent.ccrz__Sequence__c = 500.0;
        Insert objCategoryParent;
        System.debug('objCategoryParent>>>' + objCategoryParent);
        
        //Category
            objCategory.Name = 'testcategory';
        	objCategory.ccrz__CategoryID__c = '1107';
       		objCategory.Storefront__c = 'CSSNAStore';
        	objCategory.ccrz__Sequence__c = 500.0;
        	objCategory.ccrz__ParentCategory__c = objCategoryParent.Id;
         Insert objCategory;
         System.debug('objCategory>>>' + objCategory);
        
         //Product
            objProduct.Name = 'Cummins Rectangular Ring Seal 100099';
            objProduct.ccrz__SKU__c = '100099CECO';
            objProduct.ccrz__ProductStatus__c = 'Released';
            objProduct.ccrz__Storefront__c = 'CSSNAStore';
            objProduct.Group_Name__c = 'Ecom';
            objProduct.ccrz__ProductType__c = 'Product';
        	objProduct.DBU_Product_Location__c = 'CA';
        	//objProduct.Highly_Recommended__c = '5';
        
        Insert	objProduct; 
		System.debug('objProduct>>>' + objProduct);
        
        //Price List
            ccrz__E_PriceList__c objccrzEPriceList = dbu_FactoryDataTest.createPriceList('TestPricelistName');
        Insert objccrzEPriceList;
        
        //Price List Item
        	ccrz__E_PriceListItem__c objccrzEPriceListItem = dbu_FactoryDataTest.createPriceListItem ('testPricelistItemName',100, 20,'Absolute',300,objProduct.Id,objccrzEPriceList.Id);
        Insert objccrzEPriceListItem;
        
        //Price List Item
        	ccrz__E_ProductMedia__c objccrzEProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.ID ,'Product Search Image');
        Insert objccrzEProductMedia;
        
        ccrz__E_PriceList__c objPriceList 			=	new ccrz__E_PriceList__c();
        objPriceList.Name							=	'TestPricelistName1';
        objPriceList.ccrz__Storefront__c			=	'CSSNAStore';
        objPriceList.ccrz__CurrencyISOCode__c		=	'CAD';
        objPriceList.ccrz__Enabled__c				=	true;
        objPriceList.ccrz__CustomerTypeCode__c		=	'General';
        objPriceList.ccrz__StartDate__c				=	system.today();
        objPriceList.ccrz__EndDate__c				=	system.today()+2;
        insert objPriceList;
        
        //Price List Item
       ccrz__E_PriceListItem__c objPriceListItem 	=	new ccrz__E_PriceListItem__c();
        objPriceListItem.ccrz__Pricelist__c			=	objPriceList.id;
        objPriceListItem.ccrz__StartDate__c			=	system.today();
        objPriceListItem.ccrz__EndDate__c   		=	system.today()+2;
        objPriceListItem.dbu_Original_Price__c		=	100;
        objPriceListItem.dbu_Discount_Amount__c		=	20;
        objPriceListItem.dbu_Discount_Type__c		=	'Absolute';
        objPriceListItem.ccrz__Price__c				=	300;
        objPriceListItem.ccrz__Product__c   		=	objProduct.Id;
        objPriceListItem.CurrencyIsoCode            =    'CAD';
        insert objPriceListItem;
        
        //Product Category
        	objProductCategory.ccrz__Category__c = objCategory.Id;
        	objProductCategory.ccrz__Product__c = objProduct.Id;
        	
        Insert objProductCategory;
        System.debug('objProductCategory>>>' + objProductCategory);
    
        //dbu_SubSubCategoryNamewithCountWrapper Wrapper Class.
            List<dbu_SubSubCategoryNamewithCountWrapper> lstdbu_SubSubCategoryNamewithCountWrapper = new List<dbu_SubSubCategoryNamewithCountWrapper>();
            dbu_SubSubCategoryNamewithCountWrapper objdbuSubSubCategoryNamewithCountWrapper = new dbu_SubSubCategoryNamewithCountWrapper();
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryName = 'testsubsubcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryproductCount = 1; 
                objdbuSubSubCategoryNamewithCountWrapper.categoryName = 'testcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryid = objCategory.Id;
           
            lstdbu_SubSubCategoryNamewithCountWrapper.add(objdbuSubSubCategoryNamewithCountWrapper);

        	lstategory.add(objCategoryParent.Id);
        
        	dbu_CountryCurrencyMapping__c cCurr = new dbu_CountryCurrencyMapping__c(Name = 'United States of America', dbuCountryCode__c = 'US', dbuCurrencyCode__c= 'USD');
        	insert cCurr;
        
         
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
            };
		    ccrz.cc_CallContext.userLocale    = 'en_US';

            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            //ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            //ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale    = 'en_US';
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);           
        
        Test.startTest();  
			dbu_homePageCategoryTileCtrl.getProductBreadCrumb(objCategory.Id);
        	dbu_homePageCategoryTileCtrl.getProductBreadCrumbSubCategory(objCategory.Id);
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('CA');
        	dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryName(objCategory.Name);
        	dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryId(objCategory.Id,'US');
        	dbu_homePageCategoryTileCtrl.getDescriptionBySubCategoryId(objCategory.Id);
            dbu_homePageCategoryTileCtrl.getSubCategoryWithProductByCategoryId(objCategoryParent.Id,'CA');
        	dbu_homePageCategoryTileCtrl.getProductDetailsBySubCategoryId(json.serialize(lstategory), pageNum, numberofrecord,sortOptions,'CA'); 	
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('US');
        	dbu_homePageCategoryTileCtrl.getProdCategoryMedia();
        	try{
                dbu_homePageCategoryTileCtrl.getBreadCrumb(objProduct.Id);
                dbu_homePageCategoryTileCtrl.getAllProductDetailsBySubCategoryId(json.serialize(lstategory),sortOptions,'CA');
                ccrz__E_CategoryMedia__c ecImage = new ccrz__E_CategoryMedia__c(ccrz__StaticResourceName__c = 'CumminsParts');
                insert ecImage;
                dbu_homePageCategoryTileCtrl.getProdCategoryMedia();
            }
            catch(Exception e){
            }
        Test.stopTest(); 
    }
    static testMethod void testhomePageCategoryTileCtrl2(){ 
        Integer pageNum = 1;
        Integer numberofrecord = 12;
        String sortOptions = 'lower';
        Integer recorsdToSkip = 0;
        List<Id> lstategory = new List<Id>();
        ccrz__E_Category__c objCategoryParent = new ccrz__E_Category__c();
        ccrz__E_Category__c objCategory = new ccrz__E_Category__c();
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        ccrz__E_ProductCategory__c objProductCategory = new ccrz__E_ProductCategory__c();
        ccrz__E_Promo__c objpromotion=new ccrz__E_Promo__c();
        
        //Parent Category
            objCategoryParent.Name = 'testcategoryParent';
        	objCategoryParent.ccrz__CategoryID__c = '2058';
       		objCategoryParent.Storefront__c = 'CSSNAStore';
        	objCategoryParent.ccrz__Sequence__c = 500.0;
        Insert objCategoryParent;
        System.debug('objCategoryParent>>>' + objCategoryParent);
        
        //Category
            objCategory.Name = 'testcategory';
        	objCategory.ccrz__CategoryID__c = '1107';
       		objCategory.Storefront__c = 'CSSNAStore';
        	objCategory.ccrz__Sequence__c = 500.0;
        	//objCategory.ccrz__ParentCategory__c = objCategoryParent.Id;
        	objCategory.dbu_Category_Location__c='EN';
        	objCategory.dbu_isPromotion__c=false;
         Insert objCategory;
         System.debug('objCategory>>>' + objCategory);
        
         //Product
            objProduct.Name = 'Cummins Rectangular Ring Seal 100099';
            objProduct.ccrz__SKU__c = '100099CECO';
            objProduct.ccrz__ProductStatus__c = 'Released';
            objProduct.ccrz__Storefront__c = 'CSSNAStore';
            objProduct.Group_Name__c = 'Ecom';
            objProduct.ccrz__ProductType__c = 'Product';
        	objProduct.DBU_Product_Location__c = 'CA';
            objProduct.ccrz__StartDate__c=system.today();
            objProduct.ccrz__EndDate__c=system.today()+2;
        Insert	objProduct; 
		System.debug('objProduct>>>' + objProduct);
        
        //Price List
            ccrz__E_PriceList__c objccrzEPriceList = dbu_FactoryDataTest.createPriceList('TestPricelistName');
        Insert objccrzEPriceList;
        
        //Price List Item
        	ccrz__E_PriceListItem__c objccrzEPriceListItem = dbu_FactoryDataTest.createPriceListItem ('testPricelistItemName',100, 20,'Absolute',300,objProduct.Id,objccrzEPriceList.Id);
        Insert objccrzEPriceListItem;
        
        //Price List Item
        	ccrz__E_ProductMedia__c objccrzEProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.ID ,'Product Search Image');
        Insert objccrzEProductMedia;
        
        //Product Category
        	objProductCategory.ccrz__Category__c = objCategory.Id;
        	objProductCategory.ccrz__Product__c = objProduct.Id;
        	
        Insert objProductCategory;
        System.debug('objProductCategory>>>' + objProductCategory);
        
        
        //Promotion
        objpromotion.name='Clearance Sale';
        objpromotion.ccrz__Sequence__c=1;
        objpromotion.CurrencyIsoCode='CAD';
        objpromotion.ccrz__StartDate__c=System.today();
        objpromotion.ccrz__EndDate__c=System.today() +2;
        objpromotion.ccrz__StorefrontMS__c='CSSNAStore';
        objpromotion.dbu_store_location__c='EN';
        objpromotion.ccrz__Product__c=objProduct.id;
        objpromotion.ccrz__Enabled__c=TRUE;
        objpromotion.ccrz__Category__c=objCategory.id;
        insert objpromotion;
        
    
        //dbu_SubSubCategoryNamewithCountWrapper Wrapper Class.
            List<dbu_SubSubCategoryNamewithCountWrapper> lstdbu_SubSubCategoryNamewithCountWrapper = new List<dbu_SubSubCategoryNamewithCountWrapper>();
            dbu_SubSubCategoryNamewithCountWrapper objdbuSubSubCategoryNamewithCountWrapper = new dbu_SubSubCategoryNamewithCountWrapper();
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryName = 'testsubsubcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryproductCount = 1; 
                objdbuSubSubCategoryNamewithCountWrapper.categoryName = 'testcategoryName';
                objdbuSubSubCategoryNamewithCountWrapper.subsubcategoryid = objCategory.Id;
           
            lstdbu_SubSubCategoryNamewithCountWrapper.add(objdbuSubSubCategoryNamewithCountWrapper);

        	lstategory.add(objCategoryParent.Id);
        
         
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
            };
		    ccrz.cc_CallContext.userLocale    = 'en_US';

            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            //ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            //ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale    = 'en_US';
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);           
        
        Test.startTest();  
			
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('US');
            dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails('EN');
        Test.stopTest(); 
    }
}