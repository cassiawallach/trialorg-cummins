@isTest
private class OSM_SW_Cart_Wishlist_Comp_CtrlTest{

    static testMethod void testfetchWishListItems_Success()
    {
        TestDataRes testDataRes = setUpData();
         
        // Start Test
        Test.StartTest();
        
            // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
            OSM_SW_Cart_Wishlist_Comp_Ctrl.fetchWishListItems(objRemoteClass);
        
        Test.stopTest();
    }
    
    static testMethod void testfetchWishListItems_Failure()
    {
        TestDataRes testDataRes = setUpData();
        
        // Start Test
        Test.StartTest();
        
        // Create RemoteActionContext Class Data
        ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
        objRemoteClass.storefront = 'SoftwareStore';
        objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
        objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
        objRemoteClass.userLocale = 'en_US';
        
        ID cartId = testDataRes.lstECart2[0].Id;
        
        ccrz__E_Cart__c cart = [Select id from ccrz__E_Cart__c where id=:cartId];
        cart.ccrz__Storefront__c = 'TestStorefront';
        update cart;
        
        OSM_SW_Cart_Wishlist_Comp_Ctrl.fetchWishListItems(objRemoteClass);
        
        Test.stopTest();
    }
    
    static testMethod void testHandleMovetoCart_Failure()
    {
        TestDataRes testDataRes = setUpData();
        
        Test.StartTest();
        
        // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
        ID cartId = testDataRes.lstECart2[0].Id;
        
        ccrz__E_Cart__c cart = [Select id from ccrz__E_Cart__c where id=:cartId];
        cart.ccrz__CartType__c = 'Cart';
        cart.ccrz__ActiveCart__c = true;
        cart.ccrz__CartStatus__c='Open';
        cart.ccrz__User__c = testDataRes.loggedInUser.Id;
        cart.ccrz__Storefront__c='TestSoftwareStore';
        
        update cart;
        
        OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass,testDataRes.ECartItem_1[0].Id);
        //OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass,cart.id);  
        
        Test.stopTest();
    }
    
    static testMethod void testHandleMovetoCart_Success()
    {
        TestDataRes testDataRes = setUpData();
        
        Test.StartTest();
        
        // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
        ID cartId = testDataRes.lstECart2[0].Id;
        
        ccrz__E_Cart__c cart = [Select id from ccrz__E_Cart__c where id=:cartId];
        cart.ccrz__CartType__c = 'Cart';
        cart.ccrz__ActiveCart__c = true;
        cart.ccrz__CartStatus__c='Open';
        cart.ccrz__User__c = testDataRes.loggedInUser.Id;
        cart.ccrz__Storefront__c='SoftwareStore';
        
        update cart;
        
        OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass,testDataRes.ECartItem_1[0].Id);
        
        Test.stopTest();
    }
    
    static testMethod void testHandleMoveToWishlist_Success()
    {
        TestDataRes testDataRes = setUpData();
         
        // Start Test
        Test.StartTest();
        
        // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
        OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMoveToWishlist(objRemoteClass, testDataRes.ECartItem_1[0].Id);
        
        // Stop Test
        Test.StopTest();
    }
    
    static testMethod void testHandleMoveToWishlist_Failure()
    {
        TestDataRes testDataRes = setUpData();
         
        // Start Test
        Test.StartTest();
        
        // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
        OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMoveToWishlist(objRemoteClass, testDataRes.lstECart2[0].Id);
        
        // Stop Test
        Test.StopTest();
    }
    
    
    static testMethod void testfetchWishListItems(){
        
        TestDataRes testDataRes = setUpData();
         
        // Start Test
        Test.StartTest();
        
            // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testDataRes.lstECart2[0].Id;
            objRemoteClass.portalUserId = testDataRes.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            // Call Apex Class Methods
           // OSM_SW_Cart_Wishlist_Comp_Ctrl.fetchWishListItems(objRemoteClass);
            OSM_SW_Cart_Wishlist_Comp_Ctrl.handleDeleteWLItem(objRemoteClass, testDataRes.ECartItem_1[0].Id);
            OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMoveToWishlist(objRemoteClass, testDataRes.ECartItem_1[0].Id);
            OSM_SW_Cart_Wishlist_Comp_Ctrl.createNewCart();
            OSM_SW_Cart_Wishlist_Comp_Ctrl.createNewWishlist();
           // OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass,testDataRes.ECartItem_1[0].Id);
        
        // Stop Test
        Test.StopTest();
        
    }
    static testMethod void testhandleMovetoCart(){
        
        // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];
        
        // Create E Cart
        List<ccrz__E_Cart__c> lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', loggedInUser.Id, true, 'Open', true);
        
        // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);
        
        // Create E SubProdTerm
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
            List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
            lstESubProdTerm.addAll(lstprodterm);
        }
        
        // Create E CartItem
        List<ccrz__E_CartItem__c> ECartItem_1 = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart2[0].Id, 'Cart', 1, lstEProduct[0].Id, lstESubProdTerm[2].Id, 500, true);
        //List<ccrz__E_CartItem__c> ECartItem_2 = TestingUtils.createCartItem(1, 'CMIMarketplace', lstECart2[0].Id, 'Cart', 1, lstEProduct[1].Id, lstESubProdTerm[2].Id, 500, true);
        
        // Start Test
        Test.startTest();
            
            // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = lstECart2[0].Id;
            objRemoteClass.portalUserId = loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
        
            // Call Apex Class Methods
            //OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass, ECartItem_1[0].Id);
            OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMoveToWishlist(objRemoteClass, ECartItem_1[0].Id);
            OSM_SW_Cart_Wishlist_Comp_Ctrl.createNewCart();
            OSM_SW_Cart_Wishlist_Comp_Ctrl.createNewWishlist();
            //OSM_SW_Cart_Wishlist_Comp_Ctrl.handleMovetoCart(objRemoteClass,ECartItem_1[0].Id);
        // Stop Test
        Test.stopTest();
    }
    
    public static TestDataRes setUpData()
    {
        // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];
        // Query Profile Id
        List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
        
        // Create User
        User objUser;
        if(listObjProfile.size() > 0){
            objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true);  
        }else{
            listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true); 
            }
        } 
        
        //Create Account Group
        List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(5, 'TestAccntGrp', 'Best Price', true);
        
        //Create Account
        List<Account> listAccount = TestingUtils.createAccount(5, 'TestAccountMoulika', listAccountGrp[0].Id, objUser.Id, true) ;
        
        //Create Contact
        List<Contact> listContact  = TestingUtils.createContact(1, listAccount[0].Id, objUser.Id, true);
        
        // Create E Cart
        List<ccrz__E_Cart__c> lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Wishlist', loggedInUser.Id, true, 'Open', true);
        
        // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);
        
        // Create E SubProdTerm
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
            List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
            lstESubProdTerm.addAll(lstprodterm);
        }
        
        // Create E CartItem
        List<ccrz__E_CartItem__c> ECartItem_1 = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart2[0].Id, 'Cart', 1, lstEProduct[0].Id, lstESubProdTerm[2].Id, 500, true);
        
        TestDataRes testDataRes = new TestDataRes();
        
        testDataRes.loggedInUser = loggedInUser;
        testDataRes.objUser = objUser;
        testDataRes.listAccountGrp = listAccountGrp;
        testDataRes.listContact = listContact;
        testDataRes.lstECart2 = lstECart2;
        testDataRes.lstEProduct = lstEProduct;
        testDataRes.lstESubProdTerm = lstESubProdTerm;
        testDataRes.ECartItem_1 = ECartItem_1;
        
        return testDataRes;
    }
    
    public class TestDataRes
    {
        User loggedInUser;
        User objUser;
        List<ccrz__E_AccountGroup__c> listAccountGrp;
        List<Contact> listContact;
        List<ccrz__E_Cart__c> lstECart2;
        List<ccrz__E_Product__c> lstEProduct;
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm;
        List<ccrz__E_CartItem__c> ECartItem_1;
    }    
}