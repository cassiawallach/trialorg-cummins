@isTest
public class dbu_ReviewOrder_Test 
{
    public static testMethod void fetchOrderDetailsTest(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.ccrz__BillTo__c=createContactAddr1.id;
        createCart.ccrz__ShipTo__c=createContactAddr.id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        
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
        ccrz.cc_CallContext.currAccountId = createAccount.id;
        ccrz.cc_CallContext.userCurrency = 'USD';
        ccrz.cc_CallContext.effAccountId = createAccount.id;
        ccrz.cc_CallContext.currCartId = createCart.id;
        ccrz.cc_CallContext.userLocale    = 'en_US';
        ccrz.cc_CallContext.currContact= createContact;
        ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
        ccrz.cc_CallContext.initRemoteContext(ctx);
        dbu_ReviewOrder.fetchOrderDetails(createCart.id);
        dbu_ReviewOrder.fetchPickUpData(createCart.id);
    }
}
//UAT Deployment