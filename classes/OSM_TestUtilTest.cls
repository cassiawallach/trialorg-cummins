@isTest
private class OSM_TestUtilTest {

    @isTest static void testConstructor() {
        OSM_TestUtil util = new OSM_TestUtil();
        System.assertNotEquals(util, null);
    }

    @isTest static void createAccountGroup_BestPrice(){
        OSM_TestUtil util = new OSM_TestUtil();
        ccrz__E_AccountGroup__c ag = util.createAccountGroup('grp', OSM_TestUtilSettings.PRICE_METHOD_BEST);
        System.assertEquals('Best Price', ag.ccrz__PriceListSelectionMethod__c);
    }

    @isTest static void createAccountGroup_Sequence(){
        OSM_TestUtil util = new OSM_TestUtil();
        ccrz__E_AccountGroup__c ag = util.createAccountGroup('grp', OSM_TestUtilSettings.PRICE_METHOD_SEQUENCE);
        System.assertEquals('Sequence Order', ag.ccrz__PriceListSelectionMethod__c);
    }
            
    @isTest static void createAccountGroup_null(){
        OSM_TestUtil util = new OSM_TestUtil();
        ccrz__E_AccountGroup__c ag = util.createAccountGroup('grp', null);
        System.assertEquals('Best Price', ag.ccrz__PriceListSelectionMethod__c);
    }

    @isTest static void createAccount(){
        OSM_TestUtil util = new OSM_TestUtil();
        ccrz__E_AccountGroup__c ag = util.createAccountGroup('grp', OSM_TestUtilSettings.PRICE_METHOD_BEST);
        insert ag;
        Account act = util.createAccount(ag);
        System.assertEquals(ag.Id, act.ccrz__E_AccountGroup__c);
    }   

    @isTest static void createPriceList(){
        OSM_TestUtil util = new OSM_TestUtil();
        String storefront = util.STOREFRONT;
        String priceListName = 'MyPriceList';
        ccrz__E_PriceList__c pl = util.createPriceList(priceListName, storefront);
        System.assertEquals(priceListName, pl.Name);
        System.assertEquals(storefront, pl.ccrz__Storefront__c);
        System.assertEquals(true, pl.ccrz__Enabled__c);
    }   

    @isTest static void createAccountGroupPriceList(){
        OSM_TestUtil util = new OSM_TestUtil();
        String storefront = util.STOREFRONT;
        String priceListName = 'MyPriceList';

        ccrz__E_AccountGroup__c ag = util.createAccountGroup('grp', null);
        insert ag;
        ccrz__E_PriceList__c pl = util.createPriceList(priceListName, storefront);
        insert pl;
        ccrz__E_AccountGroupPriceList__c agpl = util.createAccountGroupPriceList(ag, pl);
        System.assertEquals(ag.Id, agpl.ccrz__AccountGroup__c);
        System.assertEquals(pl.Id, agpl.ccrz__Pricelist__c);
        System.assertEquals(true, agpl.ccrz__Enable__c);
    }

    @isTest static void createOrder(){
        OSM_TestUtil util = new OSM_TestUtil();
        Map<String, Object> configData = util.initData();

        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)configData.get('cart');
        Account userAccount = (Account)configData.get('userAccount');
        Contact userContact = (Contact)configData.get('userContact');
        ccrz__E_ContactAddr__c shippingAddr = (ccrz__E_ContactAddr__c)configData.get('shippingContactAddress');
        ccrz__E_ContactAddr__c billingAddr = (ccrz__E_ContactAddr__c)configData.get('billingContactAddress');
        User portalUser = (User)configData.get('portalUser');

        ccrz__E_Order__c theOrder = util.createOrder(cart.Id, userAccount.Id, userContact.Id, portalUser.Id, shippingAddr.Id, billingAddr.Id);

        System.assertEquals(theOrder.ccrz__OriginatedCart__c, cart.Id);
        System.assertEquals(theOrder.ccrz__Account__c, userAccount.Id);
        System.assertEquals(theOrder.ccrz__Contact__c, userContact.Id);
        System.assertEquals(theOrder.OwnerId, portalUser.Id);
        System.assertEquals(theOrder.ccrz__ShipTo__c, shippingAddr.Id);
        System.assertEquals(theOrder.ccrz__BillTo__c, billingAddr.Id);
    }

    @isTest static void createTransactionPayment(){
        OSM_TestUtil util = new OSM_TestUtil();
        Map<String, Object> configData = util.initData();

        User u = (User)configData.get('portalUser');
        ccrz__E_Order__c theOrder = (ccrz__E_Order__c)configData.get('order');

        ccrz__E_TransactionPayment__c tp = util.createTransactionPayment(theOrder.Id, u.Id);
        System.assertEquals(tp.ccrz__CCOrder__c, theOrder.Id);
        System.assertEquals(tp.ccrz__TransactionPaymentId__c, u.Id);
    }   

    @isTest static void initData() {
        OSM_TestUtil util = new OSM_TestUtil();
        Map<String, Object> configData = util.initData();
        System.assertNotEquals(null, configData);
    }       
}