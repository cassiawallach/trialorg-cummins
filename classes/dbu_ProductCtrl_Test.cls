/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-16-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_ProductCtrl_Test {
    
    
    
    private static string FIRSTNAME             =   'Test';
    private static string LASTNAME              =   'Customer';
    private static string PRODGROUPNAME         =   'Ecom';
    @testsetup static void setuptestdata(){
        
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;  

        System.runAs(admin){  
            
        //Get RecordTypeID 
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //Get Profile Id - IAM User
        Id profileId = [Select Id From Profile Where Name='IAM User'].id;
        
        //Setup Account for Logged In user
        Account acc                             =   dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc;
        
        //Setup Contact for Logged In user - without Wishlist
        //Contact con                               =   dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        //con.Username__c                           =   UserInfo.getUserName();
        //Contact con = new Contact(LastName = LASTNAME, AccountId = acc.id);
        //insert con; 
        
        //Setup PriceList 
        ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
        insert TestPricelist;
        
        //Setup Products
        list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
        ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
        TestProduct1.dbu_Crate_Engine__c = true;
        TestProduct1.Group_Name__c = PRODGROUPNAME;
        TestProductList.add(TestProduct1);
        insert TestProductList;
        }
    }
    
    
    @isTest public static void fetchLstProductsTestmethd(){
        list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE name = 'TestProduct1'];
        string urlVar = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/product?pId='+ProductRet[0].id+'&store=EN';
        string label = 'Emissions Agreement';
        dbu_ProductCtrl.fetchLstProducts(urlVar);
        dbu_ProductCtrl.fetchProductById(urlVar);
        dbu_ProductCtrl.fetchFeaturedLstProducts(urlVar);
        dbu_ProductCtrl.fetchFeaturedLstProducts1(urlVar);
        dbu_ProductCtrl.Checkcreateengine(urlVar);
        dbu_ProductCtrl.getCrateMetaData(urlVar);
        dbu_ProductCtrl.getStatesForCrateEngine(ProductRet[0].id);
        dbu_ProductCtrl.getlongdesc(label);
        dbu_ProductCtrl.getESNPdpPopup();
        dbu_ProductCtrl.fetchReconSupersessionProducts(ProductRet[0].id);
        
        dbu_callCCApi.fetchProductDetails((string)ProductRet[0].id,urlVar);
        
        
        
    }
    @isTest public static void fetchLstProductsTestmethdSearch(){
        list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE name = 'TestProduct1'];
        string searchurlVar = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=engine&store=EN';
        
        dbu_ProductCtrl.fetchLstProducts(searchurlVar);
        
    }
    
    @isTest public static void fetchSpecsByProdIdTestmethd(){
        
        list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE name = 'TestProduct1'];
        set<string> pidSet = new set<string>();
        List<string> pidList = new List<string>();
        string urlVar = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/product?pId='+ProductRet[0].id+'&store=EN';
        string searchvalue = 'test';
        
        pidSet.add(ProductRet[0].id);
        pidList.add(ProductRet[0].id);
        
        ccrz__E_Spec__c objSpec = new ccrz__E_Spec__c();
        objSpec.Name = 'Base Product';
        objSpec.ccrz__Desc__c = 'test';
        objSpec.ccrz__UseForFilter__c = true;
        objSpec.ccrz__DisplayName__c = 'Base Product';
        objSpec.ccrz__FilterType__c = 'Checkbox';
        objSpec.imageText__c = '\\';
        objSpec.ccrz__IsComparable__c = false;
        objSpec.ccrz__IsVisibleInCatalog__c = true;
        objSpec.ccrz__Locale__c = 'en_US';
        objSpec.ccrz__SelectType__c = 'Single';
        objSpec.ccrz__Sequence__c = 1;
        objSpec.ccrz__SpecGroup__c = 'General';
        insert objSpec;
        
        ccrz__E_ProductSpec__c specs = new ccrz__E_ProductSpec__c();
        specs.ccrz__SpecValue__c = '2';
        specs.ccrz__Spec__c = objSpec.id;
        specs.ccrz__Product__c = ProductRet[0].id;
        insert specs;
        
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
        insert subCateObj;
        
         ccrz__E_Category__c subsubCateObj = new ccrz__E_Category__c();
        subsubCateObj.Name = 'Aftertreatment';
        subsubCateObj.ccrz__CategoryID__c = '1003';
        subsubCateObj.CurrencyIsoCode = 'USD';
        subsubCateObj.Storefront__c = 'CSSNAStore';
        subsubCateObj.ccrz__LongDescRT__c = 'Testing';
        subsubCateObj.ccrz__ParentCategory__c = subCateObj.Id;
        insert subsubCateObj;
        
        ccrz__E_ProductCategory__c productcate = new ccrz__E_ProductCategory__c();
        productcate.ccrz__Category__c= subsubCateObj.id;
        productcate.ccrz__Product__c=ProductRet[0].id;
        insert productcate;
        
        dbu_ProductCtrl.fetchSpecsByProdId(urlVar);
        dbu_ProductCtrl.fetchPriceBySearchResult(pidSet);
        dbu_ProductCtrl.fetchmodelSpecsByProdId(urlVar);
        dbu_ProductCtrl.fetchPriceByProdID(urlVar);
        dbu_ProductCtrl.fetchMessageByProdID(urlVar);
        dbu_ProductCtrl.ValidateUserenteredESN('79464646',urlVar);
        dbu_ProductCtrl.fetchKitProductsByProdId(urlVar);
        dbu_ProductCtrl.fetchrelatedproducts(urlVar);
        dbu_ProductCtrl.fetchsimilarproducts(urlVar);
        dbu_ProductCtrl.fetchAttachmentsbyProdId(urlVar);
        dbu_ProductCtrl.getProductRating(urlVar);
        dbu_ProductCtrl.getAllProducts(searchvalue,'us', 0);
        dbu_ProductCtrl.fetchFrequentlyBoughtTogether(urlVar);
        dbu_ProductCtrl.fetchReconSupersessionNumbers(urlVar);
        dbu_ProductCtrl.fetchCategoryBySearchResult(pidSet);
        dbu_ProductCtrl.fetchbrandBySearchResult(pidSet);
        dbu_ProductCtrl.fetchRecentLstProducts(pidList,'US');
        dbu_ProductCtrl.getPromotionProducts(urlVar);
        dbu_ProductCtrl.getProductInventoryDetails(urlVar,'US');
        dbu_ProductCtrl.fetchGenuineCumminsParts('US');
        dbu_ProductCtrl.getProductcode(urlVar);
        dbu_ProductCtrl.fetchCategoryID();
        dbu_ProductCtrl.showwarrenty(urlVar);
        
        
    }
    
    
    
    
    
}
//UAT Deployment