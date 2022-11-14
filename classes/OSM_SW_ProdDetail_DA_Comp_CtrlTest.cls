@isTest(SeeAllData=true)
public class OSM_SW_ProdDetail_DA_Comp_CtrlTest {
    /*
    static testMethod void testOSM_SW_ProdDetail_DA_Comp_Ctrl(){
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
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
        List<Account> listAccount = TestingUtils.createAccount(1, 'TestAccountMoulika', listAccountGrp[0].Id, objUser.Id,true) ;
        
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
        List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(5,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsCombined, true);
        TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsBase, true);
        TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsPlus , true);
        TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsPro, true);
        
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
            
               
            // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = lstECart[0].Id;
            objRemoteClass.portalUserId = ObjUser.Id;
            objRemoteClass.userLocale = 'en_US';
            objRemoteClass.currentPageName = 'ccrz__ProductDetails';
            objRemoteClass.userIsoCode = 'USD';
            //submitQuote string
            String json=        '{'+
                '"subcQty":"1",'+
                '"unitPrice":1,'+
                '"billingFreq":"dfg",'+
                '"selectedProdSku":"1",'+
                '"plan":"1",'+
                '"rfqDescription":"1",'+
                '"subProdTermId":"1",'+
                '"parentId":"1"'+
                '}';
        
            // Pass current page paramenters
            PageReference pageRef = Page.ccrz__ProductDetails;
            pageRef.getParameters().put('sku',String.valueOf(compositeProduct.ccrz__SKU__c));
            Test.setCurrentPage(pageRef);
        
            String skutest = ApexPages.currentPage().getParameters().get('sku');
            System.assert(String.isNotBlank(skutest));
            
            // Call Apex Class
            OSM_SW_ProdDetail_DA_Comp_Ctrl objClass = new OSM_SW_ProdDetail_DA_Comp_Ctrl();
            //OSM_SW_ProdDetail_DA_Comp_Ctrl.fetchProdDetailInfoForDA(objRemoteClass,compositeProduct.id);
            OSM_SW_ProdDetail_DA_Comp_Ctrl.fetchProdDetailInfoForDA(objRemoteClass,objUser.id + '/a2M4C0000008kj9');
            //OSM_SW_ProdDetail_DA_Comp_Ctrl.doSubscription(objRemoteClass,compositeProduct.id);
             OSM_SW_ProdDetail_DA_Comp_Ctrl.submitQuote (objRemoteClass,json);
           
        }
        // Stop Test
        Test.stopTest();
            
    }*/
    
    ccrz__E_Subscription__c subs;
    static testMethod void testProductDetail1(){
    
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '123456-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '130129-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        ccrz__E_Product__c prod=transecRes.objSetupDate.componentList[0];
        Account a =transecRes.objSetupDate.account;
        Contact c=transecRes.objSetupDate.contact;
        Set<String> idSet=new Set<String>();
        idSet.add(prod.id);
              
        System.debug('transecRes: '+transecRes);
                      
         // Create E Cart
        //List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);


        // Creating address
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
            
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        //objRemotCtx.currAccountId = transecRes.objSetupDate.account.id;    
        
        System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
        
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //ccrz.cc_CallContext.currAccountId = transecRes.objSetupDate.account.Id;    
            
            
            Test.StartTest();
            
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl objProdDetail = new OSM_SW_ProdDetail_DA_Comp_Ctrl();
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, transecRes.objSetupDate.objUserID+'/'+transecRes.objSetupDate.compositeProduct.Id );
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl.checkFreeTrial(transecRes.objSetupDate.account.Id, transecRes.objSetupDate.componentList[0].Id, false);
                OSM_SW_ProdDetail_DA_Comp_Ctrl.getFreeTrialObj(transecRes.objSetupDate.componentList[0].Id);
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl.submitFreeTrial(objRemotCtx, '{"maxQuantity":"2","enteredQuantity":"1","freeDays":"2","productId":"'+transecRes.objSetupDate.componentList[0].Id+'"}');
                
                String strTopass = '{"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"'+transecRes.objSetupDate.subProdTermList[0].Id+'","parentId":"'+transecRes.objSetupDate.compositeProduct.Id+'","userId":"'+transecRes.objSetupDate.objUserID+'"}';
                OSM_SW_ProdDetail_DA_Comp_Ctrl.submitQuote(objRemotCtx,strTopass );
                OSM_SW_ProdDetail_DA_Comp_Ctrl.addToCartExternal(objRemotCtx,strTopass );
                
                Set<String> childProdId = new Set<String>();
                childProdId.add(transecRes.objSetupDate.componentList[0].Id);
                
                //OSM_SW_ProdDetail_DA_Comp_Ctrl.getUserCartItem(transecRes.cart.ccrz__EncryptedId__c, transecRes.objSetupDate.compositeProduct.Id,  childProdId, 'SoftwareStore', transecRes.objSetupDate.contact.Id);
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl.createNewCart();
                OSM_SW_ProdDetail_DA_Comp_Ctrl.saveCCPackageInClass(objRemotCtx, '');
                OSM_SW_ProdDetail_DA_Comp_Ctrl.BillingFrequency newObj = new OSM_SW_ProdDetail_DA_Comp_Ctrl.BillingFrequency();
                OSM_SW_ProdDetail_DA_Comp_Ctrl.ProductSpecification test3 = new OSM_SW_ProdDetail_DA_Comp_Ctrl.ProductSpecification();
                OSM_SW_ProdDetail_DA_Comp_Ctrl.MainWrapper test2 = new OSM_SW_ProdDetail_DA_Comp_Ctrl.MainWrapper();
            
            ID p = transecRes.objSetupDate.compositeProduct.Id;
            
            List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {String.valueOf(transecRes.objSetupDate.compositeProduct.Id)});
   for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) 
   {
     p = compProd.ccrz__Component__c;
       break;
   }
            
            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.Name = 'testjk123spec';
            insert spec;
            
            ccrz__E_ProductSpec__c pspec = new ccrz__E_ProductSpec__c();
            pspec.ccrz__Product__c = p;
            pspec.ccrz__Spec__c = spec.ID;
            insert pspec;
            
                OSM_SW_ProdDetail_DA_Comp_Ctrl.getProductcompleteDetail(transecRes.objSetupDate.compositeProduct.Id,transecRes.objSetupDate.componentList[0].Id,'SoftwareStore',true,true  );
                
                OSM_SW_ProdDetail_DA_Comp_Ctrl.MainWrapper mainWrapperObj=new OSM_SW_ProdDetail_DA_Comp_Ctrl.MainWrapper();
                //OSM_SW_ProdDetail_DA_Comp_Ctrl.getUserCartItem(lstECart[0].id,prod.id, idSet, 'SoftwareStore', c.id);
                
                
            Test.StopTest();
        
        }
        }
        //Product list test data
        public static List < Map < String, Object >> productListTestData(){
        List < Map < String, Object >> prodList=new List < Map < String, Object >>();
        Map < String, Object > prodMap=new Map < String, Object >();
        
        ccrz__E_Product__c prod=new ccrz__E_Product__c();
        prod.name='Connected Advisor';
        prod.ccrz__SKU__c='15458776';
        prod.ccrz__Quantityperunit__c=3343;
        prod.ccrz__StartDate__c=system.today();
        prod.ccrz__EndDate__c=system.today()+1;
        prod.ccrz__ShortDesc__c='testing';

        insert prod;
        
               
        String testData='{EProductMediasS=({attachmentsS=({"sfid":'+prod.id+'}),"enabled":true,"locale":"en_US","mediaType":"Product Search Image","product"='+prod.id+'})}';
        prodMap.put(testData,prod);
        prodList.add(prodMap);
        return prodList;
        }
        
        //Price list test data
        public static Map < String, Object > priceListTestData(){
        Map < String, Object > priceMap=new Map < String, Object >();
        Map < String, Object > pricingMap=new Map < String, Object >();
        Map < String, Object > subProdMap=new Map < String, Object >();

        ccrz__E_Product__c prod=new ccrz__E_Product__c();
        prod.name='Connected Advisor';
        prod.ccrz__SKU__c='16458876';
        prod.ccrz__Quantityperunit__c=3343;
        prod.ccrz__StartDate__c=system.today();
        prod.ccrz__EndDate__c=system.today()+1;
        prod.ccrz__ShortDesc__c='testing';

        insert prod;
        
         ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now()+2;
        insert spt; 

      //  List<ccrz__E_PriceList__c> priceList=TestingUtils.createPriceList(1,'pricetest','SoftwareStore',true,'USD',true);
      ccrz__E_PriceList__c testPriceList=new ccrz__E_PriceList__c();
          //  ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
          testPriceList.Name='testPrice';
//testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
//testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
        testPriceList.ccrz__CurrencyISOCode__c='USD';

        testPriceList.ccrz__Enabled__c=true;

        testPriceList.ccrz__Storefront__c='SoftwareStore';
        insert testPriceList;
        ccrz__E_PriceListItem__c priclelistItem=new ccrz__E_PriceListItem__c();
        //priclelistItem.Name='testPriceListItem';
        priclelistItem.ccrz__SubProdTerm__c=spt.id;
        priclelistItem.ccrz__Product__c=prod.id;
        priclelistItem.ccrz__Pricelist__c=testPriceList.id;
        insert priclelistItem;
        
        
        String priceTestData='{itemType":null, "price":120.00,"priceList":testPriceList.Id, "sfid":prod.id}';
        Map<String,Map<String,Object>> subProductDataOuterMap=new Map<String,Map<String,Object>>();
        Map<String,Object> subProductDataInnerMap1=new Map<String,Map<String,Object>>();
        Map<String,Object> subProductDataInnerMap2=new Map<String,Object>();
        subProductDataInnerMap1.put('price','120.00');
        subProductDataInnerMap1.put('priceList',testPriceList.id);
        subProductDataInnerMap1.put('sfid',priclelistItem.id);
        subProductDataInnerMap2.put('price','120.00');
        subProductDataInnerMap2.put('priceList',testPriceList.id);
        subProductDataInnerMap2.put('sfid',priclelistItem.id);
        subProductDataOuterMap.put('nonRecurringPrice',subProductDataInnerMap1);
        subProductDataOuterMap.put('recurringPrice',subProductDataInnerMap2);
        
        Map<String,Object> subProductData=new Map<string,Object>();
        subProductData.put(spt.id,subProductDataOuterMap);

        //String subProductData='{nonRecurringPrice={"itemType":null,"price":120.00, "priceList":testPriceList.Id, "sfid":prod.id,"upfrontPricePercentage":null},recurringPrice={"itemType":null,"price":120.00,"priceList":testPriceList.Id,"recurringPricePercentage":null,"sfid":prod.id}}';
        //pricingMap.put('productPrice',priceTestData);
        subProdMap.put('subProductTerms',subProductData);
        //priceMap.put('productPrice',pricingMap);
        //priceMap.put('subProductTerms',subProdMap);
        return subProdMap;

        }
        public static Map < Id, ccrz__E_SubProdTerm__c > subProdTermData()
        {
           Map<id,ccrz__E_SubProdTerm__c> prodTermMap=new Map<id,ccrz__E_SubProdTerm__c>();
            ccrz__E_Product__c prod=new ccrz__E_Product__c();
            prod.name='Connected Advisor';
            prod.ccrz__SKU__c='16458876';
            prod.ccrz__Quantityperunit__c=3343;
            prod.ccrz__StartDate__c=system.today();
            prod.ccrz__EndDate__c=system.today()+1;
            prod.ccrz__ShortDesc__c='testing';
           // prod.    
            insert prod;
            
             ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
            spt.Billing_Display_Name__c = 'Monthly';
            spt.ccrz__CCProduct__c = prod.id;
            spt.ccrz__EffectiveEnd__c = system.now();
            spt.ccrz__EffectiveStart__c = system.now()+2;
            spt.ccrz__InstallmentFrequency__c=2;
            spt.ccrz__InstallmentCount__c=3;
            spt.ccrz__OrderFrequency__c=5;
            spt.Billing_Display_Name__c='One';
            spt.ccrz__DisplayName__c='test';

            insert spt; 
            ccrz__E_SubProdTerm__c prodTerm=[select id,ccrz__InstallmentFrequency__c,OSM_Bill_Freq__c,ccrz__DisplayName__c,ccrz__CCProduct__r.ccrz__SKU__c,ccrz__OrderFrequency__c,ccrz__InstallmentCount__c,Billing_Display_Name__c,ccrz__CCProduct__c from ccrz__E_SubProdTerm__c where id=:spt.id ];
            prodTermMap.put(prodTerm.id,prodTerm);
            
            return prodTermMap;
        }
        Public ccrz__E_Subscription__c  getSubscription()
        {
            
                //Account
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
                // JUHI Changes - prevent hard coding of ID
                testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
                testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
                
                //testAccount.RecordTypeId = '0124C000000Cimc';
                //testAccount.OwnerId = '0054C0000016Fe3';
                testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
                testAccount.CMI_CId__c = '390';
                insert testAccount;
                system.debug('testAccount'+testAccount);
                    
                //CC Order
                ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
                o1.ccrz__Storefront__c = 'SoftwareStore';
                o1.ccrz__Account__c = testAccount.Id;
                o1.ccrz__CurrencyISOCode__c = 'USD';
                //ol.ccrz__OrderStatus__c = 'Order Submitted';
                insert o1;
                //AccountId = o1.ccrz__Account__c;
                //MapOrdero.put(o1.id,o1);
                //orderlIst.add(o1);
                //System.debug('---CC Order---'+o1);
                
                /*ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
                o11.ccrz__OrderStatus__c = 'Order Submitted';
                o11.ccrz__OrderDate__c = system.today();
                update o11;
                //MapOrdern.put(o1.id,o1);
                
                //Put CC Order data Into Map
                Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
                cor.put(o1.id,o1); 
                set<id> ke=cor.keyset();*/
                
                //CC Product        
                ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
                parentpro.Name = 'CA Base-DEF';
                parentpro.ccrz__SKU__c = '5678901-DEF';
                parentpro.ccrz__Quantityperunit__c = 1;
                parentpro.Group_Name__c = 'DA';
                parentpro.Product_Class_Code__c = 'SW-Web Access';
                insert parentpro;
                //productIdList.add(parentpro.id);
                //System.debug('---CC Parent Product---'+parentpro);
                
                ccrz__E_Product__c pro = new ccrz__E_Product__c();
                pro.Name = 'CA Base-OHT';
                pro.ccrz__SKU__c = '5678902-OHTTest';
                pro.ccrz__Quantityperunit__c = 1;
                pro.Group_Name__c = 'DA';
                pro.ccrz__ParentProduct__c = parentpro.id;
                pro.Product_Class_Code__c = 'SW-Web Access';
                insert pro;
                //productIdList.add(pro.id);
                //System.debug('---CC Product---'+pro);
                
                //CC OrderItem
                ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
                oi1.ccrz__Price__c = 500;
                oi1.ccrz__OriginalItemPrice__c = 400;
                oi1.ccrz__Quantity__c = 1;
                oi1.ccrz__SubAmount__c = 123;
                oi1.ccrz__Order__c = o1.id;
                oi1.ccrz__Product__c = pro.id;
                oi1.ccrz__Subscription_Auto_Renewal__c = true;
                oi1.ccrz__DisplayProduct__c = pro.id;
                insert oi1;
                //System.debug('---CC OrderItem---'+oi1); 
                
                //CC Subscription
                ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
                Sub.ccrz__Sequence__c=3;
                Sub.ccrz__Storefront__c='SoftwareStore';
                Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
                Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
                Sub.ccrz__SubscriptionStatus__c= 'Active';
                Sub.ccrz__InstallmentLastDate__c=System.now();
                Sub.ccrz__CCOrder__c=o1.Id;
                Sub.ccrz__CCOrderItem__c=oi1.Id;
                Sub.OSM_Free_Trial__c=false;
                Sub.ccrz__SubscriptionProduct__c=pro.Id;
                Sub.ccrz__RecurringPrice__c = 200;
                Sub.ccrz__OrderLastDate__c = System.now() + 10;
                Sub.ccrz__CurrencyISOCode__c = 'USD';
                Sub.ccrz__Quantity__c = 3;
                Sub.ccrz__Account__c = testAccount.id;
                Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
                Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
                Insert Sub;
                
                return sub;                
            }
        
}