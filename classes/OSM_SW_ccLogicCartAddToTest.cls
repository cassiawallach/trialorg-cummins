@isTest
public class OSM_SW_ccLogicCartAddToTest {
	static testMethod void testOSM_SW_ccLogicCartAddTo(){
        
        // Query UserRoleId
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        // Query Profile Id
        List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
        
        // Create User
        User objUser;
        if(listObjProfile.size() > 0){
            objUser = TestingUtils.createPortalUser('TestUserDA',portalRole.Id,/* listContact[0].Id,*/ listObjProfile[0].Id, true);    
        }else{
            listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createPortalUser('TestUserDA',portalRole.Id,/* listContact[0].Id,*/ listObjProfile[0].Id, true);  
            }
        } 
        
        //Create Account Group
        List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(5,'TestDataAccountGroup', 'Best Price', true);
        
        //Create Account
        List<Account> listAccount = TestingUtils.createAccount(1, 'TestAccountData', listAccountGrp[0].Id, objUser.Id, true);
        
        //Create Contact
        List<Contact> listContact  = TestingUtils.createContact(1, listAccount[0].Id, null, true);
        
        //Create single Product to pass as Composite
        ccrz__E_Product__c compositeProduct = TestingUtils.createCompositeProduct('TestCompositeProduct', 'SK100-2', 'DA', 'Aggregated', true);
        
        //Create List of Component Products
        List<ccrz__E_Product__c> lstComponentProductsCombined = new List<ccrz__E_Product__c>();
        List<ccrz__E_Product__c> lstComponentProductsBase = TestingUtils.createCcComponentProducts(2, 'Base', 'Released', 2, 'SK100-3', 'DA', 'Base', true);
        List<ccrz__E_Product__c> lstComponentProductsPlus = TestingUtils.createCcComponentProducts(2, 'Plus', 'Released', 2, 'SK100-4', 'DA', 'Plus', true);
        List<ccrz__E_Product__c> lstComponentProductsPro = TestingUtils.createCcComponentProducts(2, 'Pro', 'Released', 2, 'SK100-5', 'DA', 'Pro', true);
        lstComponentProductsCombined.addAll(lstComponentProductsBase);
        lstComponentProductsCombined.addAll(lstComponentProductsPlus);
        lstComponentProductsCombined.addAll(lstComponentProductsPro);
        
        //Create CC Composite Product
        List<ccrz__E_CompositeProduct__c> listCcCompositeProducts = TestingUtils.createCcCompProducts(compositeProduct.Id, lstComponentProductsCombined, true);
        
        // Create E SubProdTerm for composite product
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        lstESubProdTerm.addAll(TestingUtils.createSubProdTerm(1, 'TestSubProdTermComposite', compositeProduct.Id, '*', true));
        
        // Create PriceList
        List<ccrz__E_PriceList__c> lstPriceList = TestingUtils.createPriceList(5, 'TestPriceList', 'SoftwareStore', true, 'USD', true);
        
        //Create Price List Item
        List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(5, lstESubProdTerm[0].Id,lstPriceList, lstComponentProductsCombined, true);
        
        //Create Account Group PriceList
        List<ccrz__E_AccountGroupPriceList__c> lstAccGrpPriceList = TestingUtils.createAccGrpPriceList(5, listAccountGrp, lstPriceList, true, 500, true);
        
        // Create E Cart
        List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
        
        // Create E CartItem
        List<ccrz__E_CartItem__c> lstECartItem = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart[0].Id, 'Cart', 1, compositeProduct.Id, lstESubProdTerm[0].Id, 500, true);
        
        // Create CC Spec
        List<ccrz__E_Spec__c> lstCcSpec = TestingUtils.createCcSpecs(1, 'CompositeProductSpec', true);
        
        // Create CC Product Spec
        List<ccrz__E_ProductSpec__c> lstCcProdSpec = TestingUtils.createCcProductSpecs(1, compositeProduct.Id, lstCcSpec, true);
        
        // Start Test
        Test.startTest();
            System.runAs(objUser) {
               Map<String,Object> productMap =  new Map<String, Object>{'cartItem' => lstECartItem, 'Wishlist_Record' => lstECartItem[0]};
                // Call Apex Class
                OSM_SW_ccLogicCartAddTo objClass = new OSM_SW_ccLogicCartAddTo();
                objClass.process(productMap);
                objClass.setCartItemFields(productMap);
            }
        // Stop Test
        Test.stopTest();
    }
}