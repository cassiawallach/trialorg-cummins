/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-22-2022
 * @last modified by  : Devaraj
**/
@isTest
public class ccLogicProductFind_Test {
    

    @testSetup 
    static void SettingUpTestData() {
        
                 
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){           
                     
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            TestPricelist.ccrz__CurrencyISOCode__c = 'USD';
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('am ProductTest 1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
			TestProduct1.DBU_Product_Location__c = 'US';
            TestProduct1.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct1.dbu_Has_Core_Charge__c = false;
            TestProduct1.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('am ProductTest 2', false, false, true, false);
            TestProduct2.DBU_Product_Location__c = 'US';
            TestProduct2.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct2.dbu_Has_Core_Charge__c = false;
            TestProduct2.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('am ProductTest 3', true, false, false, true);
            TestProduct3.DBU_Product_Location__c = 'US';
            TestProduct3.dbu_Crate_Engine__c = true; 
            TestProduct3.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct3.dbu_Has_Core_Charge__c = false;
            TestProduct3.dbu_Has_Core_Child__c=false;
            
            TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('am ProductTest 4', false, true, false, true);
            TestProduct4.DBU_Product_Location__c = 'US';
			TestProduct4.ccrz__Storefront__c = 'CSSNAStore'; 
            TestProduct4.dbu_Has_Core_Charge__c = false;
            TestProduct4.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('Kavkaz 5', false, false, false, true);
            TestProduct5.DBU_Product_Location__c = 'US'; 
            TestProduct5.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct5.dbu_Part_Number__c = '3171713';            
            TestProduct5.dbu_Has_Core_Charge__c = false;
            TestProduct5.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestProduct5);
 
            
            ccrz__E_Product__c TestProduct6 = dbu_FactoryDataTest.createProduct('amt Product', true, true, true, false);
            TestProduct6.DBU_Product_Location__c = 'US';
            TestProduct6.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct6.dbu_Has_Core_Charge__c = false;
            TestProduct6.dbu_Has_Core_Child__c=false;  
            TestProduct6.dbu_Part_Number__c = 'BFT79464646';
            //TestProduct6.dbu_Part_Number__c = '79464646';
            TestProductList.add(TestProduct6);
            
            ccrz__E_Product__c TestProduct7 = dbu_FactoryDataTest.createProduct('Kavkaz 7', false, false, false, true);
            TestProduct7.DBU_Product_Location__c = 'US'; 
            TestProduct7.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct7.dbu_Part_Number__c = '3687580';            
            TestProduct7.dbu_Has_Core_Charge__c = false;
            TestProduct7.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestProduct7);  
            
            ccrz__E_Product__c TestProduct8 = dbu_FactoryDataTest.createProduct('Kavkaz 8', false, false, false, true);
            TestProduct8.DBU_Product_Location__c = 'US'; 
            TestProduct8.ccrz__Storefront__c = 'CSSNAStore';
            TestProduct8.dbu_Part_Number__c = '3687580';            
            TestProduct8.dbu_Has_Core_Charge__c = true;
            TestProduct8.dbu_Has_Core_Child__c=true;            
            TestProductList.add(TestProduct8);

            ccrz__E_Product__c TestRelatedProduct1 = dbu_FactoryDataTest.createProduct('Kavkaz 8', false, false, false, true);
            TestRelatedProduct1.DBU_Product_Location__c = 'US'; 
            TestRelatedProduct1.ccrz__Storefront__c = 'CSSNAStore';
            TestRelatedProduct1.dbu_Part_Number__c = '3687580';            
            TestRelatedProduct1.dbu_Has_Core_Charge__c = false;
            TestRelatedProduct1.dbu_Has_Core_Child__c=false;            
            TestProductList.add(TestRelatedProduct1);
         
            
            Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false);


            ccrz__E_RelatedProduct__c TestRelatedProduct2 = dbu_FactoryDataTest.createRelatedProduct(TestRelatedProduct1.Id, TestProduct8.Id, 'Core Charge');
            Insert TestRelatedProduct2;
            
            ccrz__E_Category__c ccParentCategory = new ccrz__E_Category__c();
            ccParentCategory.Name = 'Aftertreatment';
            ccParentCategory.Storefront__c = 'CSSNAStore';
            ccParentCategory.ccrz__CategoryID__c = '999999';
            ccParentCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
            ccParentCategory.ccrz__Sequence__c = 1;
            ccParentCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
            insert ccParentCategory;
            
            ccrz__E_Category__c ccChildCategory = new ccrz__E_Category__c();
            ccChildCategory.Name = 'CumminsR2.8TurboDiesel';
            ccChildCategory.Storefront__c = 'CSSNAStore';
            ccChildCategory.ccrz__CategoryID__c = '3444';
            ccChildCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
            ccChildCategory.ccrz__Sequence__c = 3;
            ccChildCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
            ccChildCategory.ccrz__ParentCategory__c = ccParentCategory.id;
            insert ccChildCategory;
            

            
            List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
            list<ccrz__E_ProductMedia__c>  ProductsMediaList     = new list<ccrz__E_ProductMedia__c>();
            list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
            list<ccrz__E_ProductCategory__c> productCategoryList = new list<ccrz__E_ProductCategory__c>();
                           
            Integer Count = 0;
            for (Database.SaveResult sr : TestProductInsertedList) {            
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    
                    //Setup Product Media 
                    ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Image');
                    TestProductMedia1.ccrz__Enabled__c = true;
                    ProductsMediaList.add(TestProductMedia1);
                    
                    ccrz__E_ProductMedia__c TestProductMedia2 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Search Image');                    
                    TestProductMedia2.ccrz__Enabled__c = true;
                    ProductsMediaList.add(TestProductMedia2);
                    
                    //Setup Product Inventory Item
                    string ProductInventoryItemName =   'ProdInv'+Count;
                    double QuantityAvailable        =   10+Count;
                    string availablemessage         =   'In stock';
                    string status                   =   'In Stock';
                    ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                    ProductsINvlist.add(TestProdInventory);
                    
                    string PricelistitemName = 'PricelistItem'+Count;
                    double OriginalPrice     = 100+Count;
                    double discountAmt       = 15+Count;
                    double Price             = OriginalPrice - discountAmt;                
                    
                    //Setup PriceListItem for the product
                    ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, sr.getId(), TestPricelist.id);                
                    ProductPriceListItems.add(TestPriceListItem);
                    
                    ccrz__E_ProductCategory__c prodCategory = new ccrz__E_ProductCategory__c();
                    prodCategory.ccrz__Product__c = sr.getId();
                    prodCategory.ccrz__Category__c = ccChildCategory.id;
                    prodCategory.ccrz__EndDate__c = Date.parse('6/20/2099');
                    prodCategory.ccrz__StartDate__c = Date.parse('6/20/2019');                    
                    productCategoryList.add(prodCategory);
                    
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
            
            //Insert existing part response
			dbu_partsresponse__c existingProductResponse = new dbu_partsresponse__c();
            existingProductResponse.dbu_ESNNumber__c = '85384939';
            existingProductResponse.DBU_Parts_Response_ID__c = '85384939_BFT79464646';
            existingProductResponse.Number_Z__c = 'BFT79464646';

            dbu_partsresponse__c existingProductResponse2 = new dbu_partsresponse__c();
            existingProductResponse2.dbu_ESNNumber__c = '85384955';
            existingProductResponse2.Number_Z__c = 'BFT79464646';
            existingProductResponse2.DBU_Parts_Response_ID__c = '85384955_BFT79464646';
            existingProductResponse2.dbu_VINNumber__c = 'SFD4BZBRDCGXD7208';

            insert new List<dbu_partsresponse__c>{existingProductResponse,existingProductResponse2};
            
            //insert pricelist items
            insert ProductPriceListItems;
            
            //insert product medias
            insert ProductsMediaList;
            
            //insert Product inventory 
            insert ProductsINvlist;
            
            //insert product category
            insert productCategoryList;
                                      
        }
        
    }    
    

    static testMethod void testMethod1() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){         
            
            list<ccrz__E_Product__c>  prod = [Select id from ccrz__E_Product__c where Name like : '%ProductTest%'];
            system.debug('prod >>>>>>> ' + prod);
            list<ccrz__E_ProductCategory__c> prodCate = [Select id from ccrz__E_ProductCategory__c where ccrz__Product__c in : prod ];
            system.debug('prodCate >>>>>>> ' + prodCate);   
    
            test.startTest();                         
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=ProductTest&store=US');
            test.stopTest();        
        }        
    }
    
    static testMethod void testMethod2() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){         
            
            list<ccrz__E_Product__c>  prod = [Select id from ccrz__E_Product__c where Name like : '%ProductTest%'];
            system.debug('prod >>>>>>> ' + prod);
            list<ccrz__E_ProductCategory__c> prodCate = [Select id from ccrz__E_ProductCategory__c where ccrz__Product__c in : prod ];
            system.debug('prodCate >>>>>>> ' + prodCate);   
    
            test.startTest();                         
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=85384939&store=US');
            test.stopTest();        
        }        
    }
    
    static testMethod void testMethod3() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 
        
        System.runAs(admin){         
            
            list<ccrz__E_Product__c>  prod = [Select id from ccrz__E_Product__c where Name like : '%Kavkaz%'];
            system.debug('prod >>>>>>> ' + prod);
            list<ccrz__E_ProductCategory__c> prodCate = [Select id from ccrz__E_ProductCategory__c where ccrz__Product__c in : prod ];
            system.debug('prodCate >>>>>>> ' + prodCate);   
            
            test.startTest();                                     
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=79464646&store=US');
            test.stopTest();        
        }        
    }    
    
    static testMethod void testMethod4() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 
        
        System.runAs(admin){         
            
            list<ccrz__E_Product__c>  prod = [Select id from ccrz__E_Product__c where Name like : '%Kavkaz%'];
            system.debug('prod >>>>>>> ' + prod);
            list<ccrz__E_ProductCategory__c> prodCate = [Select id,ccrz__Category__r.name from ccrz__E_ProductCategory__c where ccrz__Product__c in : prod ];
            
            system.debug('prodCate >>>>>>> ' + prodCate);   
            
            test.startTest();                                     
            ccLogicProductFind.iterateCategoryToList(prodCate);
            
            test.stopTest();        
        }        
    }         
    
    static testMethod void testmethod5(){
        map<string,object> inputdata = new map<string,object>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_ESNSearchCallout';
        conDetails.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/partlists?esn=';
        conDetails.Method_Type__c= 'GET';
        conDetails.grant_type__c= 'application/json';
        insert conDetails;
        system.debug('sleepyhollow');
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_ESNSearch_AccessToken';
        conDetails1.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        conDetails1.Method_Type__c= 'POST';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='122c334d-a6a9-4d7f-bfae-78b78902b04d';
        conDetails1.Passcode__c='69veMf-iaMv-CiDIpkM-X_9-84te5X.-l_';
        insert conDetails1;
        
      
        
        
        test.starttest();
         Test.setMock(HttpCalloutMock.class, new dbu_Integration_ESNSearch_NewMock()); 
        dbu_Integration_ESNSearch.getAccessToken();
        
        
        dbu_Integration_ESNSearch.getEsnResult('79464646');
      
        List<dbu_EsnSearchResponseWrapper.PartLists> partLists = new List<dbu_EsnSearchResponseWrapper.PartLists>();
        system.debug('partLists'+partLists);
        //ccLogicProductFind ccLogic = new ccLogicProductFind();
        //inputdata.put('store', 'US');
        //ccLogic.performProductFind(inputdata);
        test.stopTest();
    }
    
    static testMethod void testmethod6(){
        map<string,object> inputdata = new map<string,object>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_ESNSearchCallout';
        conDetails.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/partlists?esn=';
        conDetails.Method_Type__c= 'GET';
        conDetails.grant_type__c= 'application/json';
        insert conDetails;
        system.debug('sleepyhollow');
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_ESNSearch_AccessToken';
        conDetails1.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        conDetails1.Method_Type__c= 'POST';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='122c334d-a6a9-4d7f-bfae-78b78902b04d';
        conDetails1.Passcode__c='69veMf-iaMv-CiDIpkM-X_9-84te5X.-l_';
        insert conDetails1;
        
		dbu_CountryCurrencyMapping__c cCurr = new dbu_CountryCurrencyMapping__c(Name = 'United States of America', dbuCountryCode__c = 'US', dbuCurrencyCode__c= 'USD');
        insert cCurr;      

        test.starttest();
         Test.setMock(HttpCalloutMock.class, new dbu_Integration_ESNSearch_NewMock()); 
        dbu_Integration_ESNSearch.getAccessToken();
        
        
        dbu_Integration_ESNSearch.getEsnResult('79464646');
      
        List<dbu_EsnSearchResponseWrapper.PartLists> partLists = new List<dbu_EsnSearchResponseWrapper.PartLists>();
        system.debug('partLists'+partLists);
        //ccLogicProductFind ccLogic = new ccLogicProductFind();
        //inputdata.put('store', 'US');
        //ccLogic.performProductFind(inputdata);
        try{
            ccrz__E_Category__c ccChildCategory = [ Select id,Name,Storefront__c,ccrz__CategoryID__c,ccrz__EndDate__c,ccrz__Sequence__c,ccrz__StartDate__c,ccrz__ParentCategory__c from ccrz__E_Category__c where Name = 'CumminsR2.8TurboDiesel'];    
            ccLogicProductFind.retriveParentCategoryNames(new set<String>{ccChildCategory.Id});
            }
        catch(Exception e){}
        try{
            List<ccrz__E_Product__c> cProd = new List<ccrz__E_Product__c>([Select id, Name,OwnerId,ccrz__SKU__c,ccrz__ProductStatus__c,ccrz__ProductType__c,ccrz__StartDate__c,ccrz__ShortDescRT__c,ccrz__UnitOfMeasure__c,ccrz__AvailabilityMessageRT__c,
                              ccrz__EndDate__c,ccrz__AverageRating__c,ccrz__Taxable__c,DBU_Product_Location__c,dbu_Has_Core_Child__c,
                              dbu_Has_Core_Charge__c,createddate,dbu_FullPartNumber__c,dbu_Part_Number__c,ccrz__ShortDesc__c from ccrz__E_Product__c where dbu_Part_Number__c = '3171713']);
            ccLogicProductFind.getProductDetailedInformation_ExistingESN_or_PCCIntegration_Search(new set<String>{cProd[0].Id}, 'US');
        }
        catch(Exception e){}
        test.stopTest();
    }
    // Added by -- Lahari---start
    static testMethod void refinePCCIntegrationSearchResults(){
        dbu_EsnSearchResponseWrapper wrp= new dbu_EsnSearchResponseWrapper();
                List<dbu_EsnSearchResponseWrapper.PartLists> partLists = new List<dbu_EsnSearchResponseWrapper.PartLists>();

        String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        dbu_EsnSearchResponseWrapper.DataArea objDataArea = new dbu_EsnSearchResponseWrapper.DataArea(System.JSON.createParser(json));
        wrp.DataArea=objDataArea;
        wrp.DataArea.PartLists=partLists;
        ccLogicProductFind.refinePCCIntegrationSearchResults(wrp);
    }//Added by -- Lahari---End

    static testMethod void testRefinePCCIntegrationSearchResultsGSN(){
        dbu_GsnSearchResponseWrapper wrp = new dbu_GsnSearchResponseWrapper();
        
        dbu_GsnSearchResponseWrapper.mbom mbom1 = new dbu_GsnSearchResponseWrapper.mbom();
        List<dbu_GsnSearchResponseWrapper.mbom> mbomList = new List<dbu_GsnSearchResponseWrapper.mbom>();

        dbu_GsnSearchResponseWrapper.Groups grp1 = new dbu_GsnSearchResponseWrapper.Groups();
        List<dbu_GsnSearchResponseWrapper.Groups> grp1List = new List<dbu_GsnSearchResponseWrapper.Groups>();
        
        dbu_GsnSearchResponseWrapper.Parts p1 = new dbu_GsnSearchResponseWrapper.Parts();
        List<dbu_GsnSearchResponseWrapper.Parts> p1List = new List<dbu_GsnSearchResponseWrapper.Parts>();

        dbu_GsnSearchResponseWrapper.Data d1 = new dbu_GsnSearchResponseWrapper.Data();

        d1.partNo = 'part123';
        d1.partDesc = 'pard Desc';

        p1.data = d1;
        p1List.add(p1);

        grp1.parts = p1List;
        grp1List.add(grp1);

        mbom1.groups = grp1List;

        mbomList.add(mbom1);

        wrp.mbom = mbomList;
        
        ccLogicProductFind.refinePCCIntegrationSearchResultsGSN(wrp, '6355438844');
        ccLogicProductFind.refineGSNIntegrationSearchResults(wrp);

    }

    static testMethod void testMethod7() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){     
    
            test.startTest();                         
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=SFD4BZBRDCGXD7208&store=US');
            test.stopTest();        
        }        
    }

    
}

//UAT Deployment