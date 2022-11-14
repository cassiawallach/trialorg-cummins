//Test Class for the class OSM_SW_ProdDetailUtils_Ctrl Added for 1236
//MP-135 -Test Class Update - 18-11-2021
//MP-337 -Test Class Update - 19-11-2021
//MP-401 Updated By Singaiah 14-12-2021
//MP-476 Updated By Singaiah 4-1-2022
//MP-430 Updated By Swetha 13-1-2022
////MP-531 Updated By Swetha 13-1-2022
//MP-714 Updated by Karthik Golakaram 03-25-2022
//Update
//Update
//Update
/****************************************************/
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish        16/11/2021        MP-337
 2.0        Sangeeta      27/01/2022        Class Update for MP-573
 3.0        Singaiah      05/04/2022        Class Update for MP-661
 */
@isTest
public class OSM_SW_ProdDetailUtils_Ctrl_Test {
   
    static testMethod void testOSM_SW_ProdDetailUtils_Ctrl(){
    
    TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
           
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        //transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        /*Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);*/
        User adminUser = TestingUtils.ADMIN_USER;
        
        
        System.runAs(adminUser){
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
            // Query Profile Id
            List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
            
            // Create User
            User objUser = TestingUtils.ADMIN_USER;
            
                        
            //Create Account Group
            List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(5, 'TestAccntGrp', 'Best Price', true);
            
            //Create Account
            List<Account> listAccount = TestingUtils.createAccount(1, 'TestAccountMoulika', listAccountGrp[0].Id, adminUser.Id, true) ;
            
            Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';         
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.BMS_Customer_ID__c  = '12345';
        testAccount.CSS_DistributorCode__c  = '12345';
        testAccount.BMS_Customer_ID_Junction__c = '12345';
        insert testAccount;
        
            //Create Contact
           /* List<Contact> listContact  = new List<Contact>{transecRes.objSetupDate.contact};
            if(listObjProfile.size() > 0){
                //objUser = TestingUtils.createPortalUser('TestUserDA',listObjProfile[0].Id, true);  
            }else{
                listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
                if(listObjProfile.size() > 0){
                    //objUser = TestingUtils.createPortalUser('TestUserDA',listObjProfile[0].Id, true); 
                }
            }*/ 
           
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
            
            // set of string with all product ids
            set<string> productIds = new set<string>();
            for(ccrz__E_Product__c popSet : lstComponentProductsCombined){
                productIds.add(popSet.id);
            }                                      
            //Create CC Composite Product
            List<ccrz__E_CompositeProduct__c> listCcCompositeProducts = TestingUtils.createCcCompProducts(compositeProduct.Id, lstComponentProductsCombined, true);
            
            // Create E SubProdTerm for composite product
            List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
            lstESubProdTerm.addAll(TestingUtils.createSubProdTerm(1, 'TestSubProdTermComposite', compositeProduct.Id, '*', true));
            
            // Create PriceList
            List<ccrz__E_PriceList__c> lstPriceList = TestingUtils.createPriceList(5, 'TestPriceList', 'SoftwareStore', true, 'USD', true);
            
            //Create Price List Item
            List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(5,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsCombined, true);
            TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsBase, true);
            TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsPlus , true);
            TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsPro, true);
            
            //Create Account Group PriceList
            List<ccrz__E_AccountGroupPriceList__c> lstAccGrpPriceList = TestingUtils.createAccGrpPriceList(5, listAccountGrp, lstPriceList, true, 500, true);
            
            // Create E Cart
            List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true, testaccount.id);
            
            // Create E CartItem
            List<ccrz__E_CartItem__c> lstECartItem = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart[0].Id, 'Cart', 1, compositeProduct.id, lstESubProdTerm[0].Id, 10, true);
            
            // Create CC Spec
            List<ccrz__E_Spec__c> lstCcSpec = TestingUtils.createCcSpecs(1, 'CompositeProductSpec', true);
            
            // Create CC Product Spec
            List<ccrz__E_ProductSpec__c> lstCcProdSpec = TestingUtils.createCcProductSpecs(1, compositeProduct.Id, lstCcSpec, true);
            
            List<String> listProdId = new List<String>();
            listProdId.add(compositeProduct.Id);
            List<String> listSubProdTermId = new List<String>();
            listSubProdTermId.add(lstESubProdTerm[0].Id);
            String id1=lstECart[0].Id;
           
            //Start Test    
            Test.startTest();
            OSM_SW_ProdDetailUtils_Ctrl.getCcrzEProductSpecs(listProdId); 
            OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(listProdId);
            OSM_SW_ProdDetailUtils_Ctrl.getEProduct(String.valueOf(compositeProduct.ccrz__SKU__c));
            OSM_SW_ProdDetailUtils_Ctrl.getEProductOnId(listProdId[0]);
            OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(listSubProdTermId);
            OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(String.valueOf(lstESubProdTerm[0].Id));
            OSM_SW_ProdDetailUtils_Ctrl.getSubProdTerms(listProdId);
            OSM_SW_ProdDetailUtils_Ctrl.getCartItems(lstECart[0].Id, compositeProduct.ccrz__SKU__c);
            OSM_SW_ProdDetailUtils_Ctrl.getCartItems(lstECart[0].Id, compositeProduct.ccrz__SKU__c, 200);
            OSM_SW_ProdDetailUtils_Ctrl.getUserDetail(String.valueOf(objUser.Id));
            OSM_SW_ProdDetailUtils_Ctrl.getRelatedProd(listProdId[0],'Competitive');
            OSM_SW_ProdDetailUtils_Ctrl.getActiveSubscription(listProdId[0], 'Software',String.valueOf(objUser.Id));
            OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(String.valueOf(objUser.Id), 'Software', productIds, 'Requested');
            OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(String.valueOf(objUser.Id), 'Software', productIds);
            OSM_SW_ProdDetailUtils_Ctrl.getAccount(listAccount[0].id);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem('SoftwareStore',listAccount[0].id);
            OSM_SW_ProdDetailUtils_Ctrl.getUsersCart(lstECart[0].ccrz__EncryptedId__c);
            //OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItem(id1,id1,productIds,'Software Store',listContact[0].id);
            //OSM_SW_ProdDetailUtils_Ctrl.getUserDetailbyContact(listContact[0].id);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(listAccount[0].id,'Software Store');
            OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(listAccount[0].id,'Software Store');
            //Stop Test
            Test.stopTest();
        }
    }
    
    static testMethod void testOSM_SW_ProdDetailUtils_Ctrl2(){
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
                                transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            
            List<String> lstId = new List<Id>();
            for(ccrz__E_SubProdTerm__c objSup : transecRes.objSetupDate.subProdTermList)
                lstId.add(objSup.Id);
            OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(lstId,'SoftwareStore');
            Set<String> prodId = new Set<String>();
            for(ccrz__E_Product__c obj : transecRes.objSetupDate.componentList)
            prodId.add(obj.Id);
            
            Set<String> statusSet = new Set<String>();
            statusSet.add('Active');
            OSM_SW_ProdDetailUtils_Ctrl.getAccountProductsQuotes(transecRes.objSetupDate.account.Id,'SoftwareStore',prodId, statusSet);
            
            Set<String> ownerLst = new Set<String>();
            ownerLst.add(transecRes.objSetupDate.objUserID);
            
            Set<String> accountSet = new Set<String>();
            accountSet.add(transecRes.objSetupDate.account.Id);
            
            OSM_SW_ProdDetailUtils_Ctrl.getAccountsQuote(accountSet,statusSet,ownerLst);
            
            
            OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuotes(transecRes.objSetupDate.account.Id,'SoftwareStore',prodId,statusSet);
            
            OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(prodId,'SoftwareStore',transecRes.objSetupDate.account.Id);
            OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct('SoftwareStore',transecRes.objSetupDate.account.Id);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountsMap(accountSet);
            
            Set<String> storeIds = new Set<String>();
            storeIds.add('SoftwareStore');
            
            Set<String> cartItemId = new Set<String>();
            cartItemId.add(transecRes.cartItem.Id);
            
            OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem(accountSet, storeIds, cartItemId);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(transecRes.objSetupDate.account.Id, 'SoftwareStore');
            OSM_SW_ProdDetailUtils_Ctrl.getAccountProductFreeTrialSubscription(transecRes.objSetupDate.account.Id, prodId, 'SoftwareStore');
            OSM_SW_ProdDetailUtils_Ctrl.getAccountProductSubsWithFreeTrial(transecRes.objSetupDate.account.Id, prodId, 'SoftwareStore');
            
            
            List<String> subSet = new List<String>();
            subSet.add(transecRes.subscription.Id);
            
            List<String> orderItmIds = new List<String>();
            orderItmIds.add(transecRes.orderItem.Id);
            
            Set<String> orderIds = new Set<String>();
            orderIds.add(transecRes.order.Id);
            
            
            OSM_SW_ProdDetailUtils_Ctrl.getSubscriptions(subSet);
            OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionsOnOrderItems(subSet);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountPaymentTransactionDetails(transecRes.objSetupDate.account.Id);
            OSM_SW_ProdDetailUtils_Ctrl.getOrderPaymentTransactionDetails(orderIds);
            OSM_SW_ProdDetailUtils_Ctrl.getOrderItems(orderItmIds);
            
            OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuote(transecRes.objSetupDate.account.Id,'SoftwareStore',prodId,statusSet);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(accountSet,storeIds);
            OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(transecRes.objSetupDate.account.Id,prodId,'SoftwareStore');
            
            
        }
    }
}