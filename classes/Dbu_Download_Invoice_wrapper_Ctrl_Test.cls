@isTest
public class Dbu_Download_Invoice_wrapper_Ctrl_Test 
{
    public static List<dbu_WrapperInvoiceDetails> InvoiceDetailsWrapper;

    public static testMethod void Invoicewrapper(){
        //Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        //insert createAccount;
        //Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        //insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        
        //Creating second product
        /*ccrz__E_Product__c prodObj12 = new ccrz__E_Product__c();
        prodObj12.Name = 'Test SARCOPHAGUS CONTAINMENT VIKA';
        prodObj12.ccrz__SKU__c = 'K1234563247';
        prodObj12.ccrz__Quantityperunit__c = 1.00;
        prodObj12.ccrz__ProductType__c = 'Product';
        prodObj12.ccrz__UnitOfMeasure__c = 'Each';
        prodObj12.ccrz__ProductIndexStatus__c = 'Not Current';
        prodObj12.ccrz__Storefront__c = 'CSSNAStore';
        prodObj12.ccrz__ProductStatus__c = 'Released';
        prodObj12.Group_Name__c = 'Ecom';
        prodObj12.dbu_Product_Status__c = 'In Stock';
        prodObj12.ccrz__InventoryType__c = 'STANDARD';
        insert prodObj12;*/
        
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;        
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr.id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;

        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(null,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        createOrder.ccrz__ShipMethod__c = 'Ship To Address';
        createOrder.ccrz__TaxAmount__c = 5.40;
        insert createOrder;
            
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.Vertex_Tax__c = 1;
        createOrderItem.ccrz__Price__c = 1;
        createOrderItem.ccrz__Quantity__c = 1;
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = createOrder.Id;
        //invoice.ccrz__Contact__c = createContact.Id;
        invoice.ccrz__User__c = UserInfo.getUserId();
        //invoice.ccrz__BillTo__c = createAccount.Id;
        //invoice.ccrz__SoldTo__c = createAccount.Id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 500;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'CSSNAStore';
        
        insert invoice;
        
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 500;
        invoiceItem_Item.ccrz__Invoice__c = invoice.Id;
        invoiceItem_Item.ccrz__CCOrderItem__c = createOrderItem.Id;
        invoiceItem_Item.ccrz__CCOrder__c = createOrder.Id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
        
        System.currentPageReference().getParameters().put('orderId', createOrder.Id);
        Dbu_Download_Invoice_wrapper_Ctrl  obj = new Dbu_Download_Invoice_wrapper_Ctrl();//updated
    }
    
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    public static testMethod void Invoicewrapper2(){
        //Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
       // Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
       // Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
       // insert createAccount;
       // Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        //insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
       
        
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;  
        

        ccrz__E_Cart__c createCart2 = dbu_TestDataCreationUtility.createCart();
        createCart2.ccrz__ShipTo__c = createContactAddr.id;
        insert createCart2;
        
        ccrz__E_CartItem__c createCartItem2= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart2.Id);
        insert createCartItem2; 
        
        ccrz__E_CartItem__c createCartItem3= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart2.Id);
        insert createCartItem3; 
        
        ccrz__E_CartItem__c createCartItem4= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart2.Id);
        insert createCartItem4;          
        
        
        ccrz__E_Order__c createOrder2= dbu_TestDataCreationUtility.createOrder(null,createCart2.Id,createContactAddr.id,createContactAddr1.id);
        createOrder2.ccrz__User__c = UserInfo.getUserId();
        createOrder2.ccrz__ShipMethod__c = null;
        createOrder2.ccrz__TaxAmount__c = 5.40;
        createOrder2.ccrz__CurrencyISOCode__c = 'USD';
        
        insert createOrder2;      
  
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder2.Id,createProduct.Id,createCartItem2.Id);
        createOrderItem.Vertex_Tax__c = 1;
        createOrderItem.ccrz__Price__c = 1;
        createOrderItem.ccrz__Quantity__c = 1;
        createOrderItem.ccrz__OriginalQuantity__c = 5;
        createOrderItem.ccrz__OrderItemStatus__c = 'Return Initiated';
        createOrderItem.dbu_Estimated_Return_Amount__c = 123.45;
        insert createOrderItem;
        
        ccrz__E_OrderItem__c createOrderItem2= dbu_TestDataCreationUtility.createOrderItem(createOrder2.Id,createProduct.Id,createCartItem3.Id);
        createOrderItem2.Vertex_Tax__c = 1;
        createOrderItem2.ccrz__Price__c = 1;
        createOrderItem2.ccrz__Quantity__c = 1;
        createOrderItem2.ccrz__OriginalQuantity__c = 5;
        createOrderItem2.ccrz__OrderItemStatus__c = 'Return Approved';
        insert createOrderItem2;
        
        ccrz__E_OrderItem__c createOrderItem3= dbu_TestDataCreationUtility.createOrderItem(createOrder2.Id,createProduct.Id,createCartItem4.Id);        
        createOrderItem3.Vertex_Tax__c = 1;
        createOrderItem3.ccrz__Price__c = 1;
        createOrderItem3.ccrz__Quantity__c = 1;
        createOrderItem3.ccrz__OriginalQuantity__c = 5;
        createOrderItem3.ccrz__OrderItemStatus__c = 'Refunded';
        insert createOrderItem3;
        
        
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder2.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder2.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = createOrder2.Id;
        //invoice.ccrz__Contact__c = createContact.Id;
        invoice.ccrz__User__c = UserInfo.getUserId();
        //invoice.ccrz__BillTo__c = createAccount.Id;
        //invoice.ccrz__SoldTo__c = createAccount.Id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 500;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'CSSNAStore';
        //invoice.ccrz__E_OrderItem__c = ;
        insert invoice;
        
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 500;
        invoiceItem_Item.ccrz__Invoice__c = invoice.Id;
        invoiceItem_Item.ccrz__CCOrderItem__c = createOrderItem.Id;
        invoiceItem_Item.ccrz__CCOrder__c = createOrder2.Id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        
        insert invoiceItem_Item;
        
        System.currentPageReference().getParameters().put('orderId', createOrder2.Id);
        String urlParam = 'https://cumminscss--dbuecomdev.preview.salesforce-communities.com/CSSNAStore/s/invoice?orderid='+createOrder2.Id;
        //string pageURL =  ApexPages.currentPage().getUrl();
       
        System.debug('urlParamintest' + urlParam);
        

        Map<string,object> storefrontsettings = new Map<string,object>{
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',   
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => 'csodev-cumminscss.cs90.force.com/CSSNAStore',
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
         //ccrz.cc_CallContext.currAccountId = createAccount.id;
         ccrz.cc_CallContext.userCurrency = 'USD';
         //ccrz.cc_CallContext.effAccountId = createAccount.id;
         //ccrz.cc_CallContext.currCartId = cartID;
         ccrz.cc_CallContext.userLocale	= 'en_US';
         //ccrz.cc_CallContext.currContact= createContact;
         ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
         ccrz.cc_CallContext.initRemoteContext(ctx);                      
        
        Test.startTest();
 		Dbu_Download_Invoice_wrapper_Ctrl  obj = new Dbu_Download_Invoice_wrapper_Ctrl();//updated        
       	//Dbu_Download_Invoice_wrapper_Ctrl.viewReturnInvoiceData(urlParam);
        Test.stopTest();
    }
    
     public static testMethod void invoiceData(){
        //Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
       // insert createAccount;
        //Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
       // insert createContact;
        //ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        //insert createProduct;
        
         ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
         insert TestPricelist;         
         
         ccrz__E_Product__c createProduct = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
         createProduct.DBU_Product_Location__c = 'US';
         insert createProduct;
         
         ccrz__E_ProductMedia__c createProductMedia = dbu_FactoryDataTest.createProductMedia(createProduct.id, 'Product Image');
         insert createProductMedia;       
         
         string ProductInventoryItemName =	'ProdInv';
         string PricelistitemName = 'PricelistItem';
         double OriginalPrice	 = 100;
         double discountAmt 	 = 15;
         double Price 			 = OriginalPrice - discountAmt;  
         double QuantityAvailable		=	10;
         string availablemessage 		=	'In stock';
         string status					=	'In Stock';
         ccrz__E_ProductInventoryItem__c createProductInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, createProduct.id, QuantityAvailable, availablemessage, status);
         insert createProductInventory;   
         
         ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, createProduct.id, TestPricelist.id);                
         insert TestPriceListItem;
         
        //ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        //insert createProductMedia;
         
         
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
         
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        //Inserting Main Order & Order lines
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(null,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        //createOrder.ccrz__Account__c = createAccount.Id;
         createOrder.ccrz__ShipMethod__c = null;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);        
        insert createOrderItem;
        
        //Inserting Cloned Order & Order lines 
        ccrz__E_Order__c createOrderCloned = dbu_TestDataCreationUtility.createOrder(null,createCart.Id,createContactAddr.id,createContactAddr1.id); 
        createOrderCloned.CC_Order__c =  createOrder.id;
        createOrderCloned.ccrz__OrderNumber__c = 7982909;
        createOrderCloned.ccrz__OrderStatus__c = 'Return Approved';
        createOrderCloned.ccrz__PaymentMethod__c = 'credit card';
        //createOrderCloned 
        insert createOrderCloned;
        
        ccrz__E_OrderItem__c createOrderItemCloned = dbu_TestDataCreationUtility.createOrderItem(createOrderCloned.Id,createProduct.Id,createCartItem.Id);        
        createOrderItemCloned.ccrz__OrderItemStatus__c = 'Return Approved';
        createOrderItemCloned.ccrz__PricingType__c = 'auto';
         createOrderItemCloned.dbu_Reason_for_Return__c = 'Part damaged in shipping';
         createOrderItemCloned.dbu_Estimated_Return_Amount__c = 136.89;
        insert createOrderItemCloned;         
        
         //----------
         //----------
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        
         ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_TransactionPayment__c createTransPaymentcloned = dbu_TestDataCreationUtility.createTransactionPayment(createOrderCloned.Id);
        insert createTransPaymentcloned;
        

        
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = createOrder.Id;
        //invoice.ccrz__Contact__c = createContact.Id;
        invoice.ccrz__User__c = UserInfo.getUserId();
        //invoice.ccrz__BillTo__c = createAccount.Id;
        //invoice.ccrz__SoldTo__c = createAccount.Id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 500;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'CSSNAStore';
		insert invoice;
         
        ccrz__E_Invoice__c invoiceCloned = new ccrz__E_Invoice__c();
        invoiceCloned.ccrz__CCOrder__c = createOrderCloned.Id;
        //invoiceCloned.ccrz__Contact__c = createContact.Id;
        invoiceCloned.ccrz__User__c = UserInfo.getUserId();
        //invoiceCloned.ccrz__BillTo__c = createAccount.Id;
        //invoiceCloned.ccrz__SoldTo__c = createAccount.Id;
        invoiceCloned.ccrz__CurrencyCode__c = 'USD';
        invoiceCloned.ccrz__DateIssued__c = System.today();
        invoiceCloned.ccrz__DateDue__c = System.today();
        invoiceCloned.ccrz__OriginalAmount__c = 500;
        invoiceCloned.ccrz__RemainingAmount__c = 0.00;
        invoiceCloned.ccrz__Storefront__c = 'CSSNAStore';                 
        insert invoiceCloned;

        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 500;
        invoiceItem_Item.ccrz__Invoice__c = invoice.Id;
        invoiceItem_Item.ccrz__CCOrderItem__c = createOrderItem.Id;
        invoiceItem_Item.ccrz__CCOrder__c = createOrder.Id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;         
         
        ccrz__E_InvoiceItem__c invoiceItem_ItemCloned = new ccrz__E_InvoiceItem__c();
        invoiceItem_ItemCloned.ccrz__OriginalAmount__c = 500;
        invoiceItem_ItemCloned.ccrz__Invoice__c = invoiceCloned.Id;
        invoiceItem_ItemCloned.ccrz__CCOrderItem__c = createOrderItemCloned.Id;
        invoiceItem_ItemCloned.ccrz__CCOrder__c = createOrderCloned.Id;
        invoiceItem_ItemCloned.Quantity__c = 1;
        invoiceItem_ItemCloned.ccrz__Status__c = 'Open';
        invoiceItem_ItemCloned.ccrz__Type__c = 'Item';
        insert invoiceItem_ItemCloned;
        
        Map<string,object> storefrontsettings = new Map<string,object>{
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',   
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => 'csodev-cumminscss.cs90.force.com/CSSNAStore',
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
         //ccrz.cc_CallContext.currAccountId = createAccount.id;
         ccrz.cc_CallContext.userCurrency = 'USD';
         //ccrz.cc_CallContext.effAccountId = createAccount.id;
         //ccrz.cc_CallContext.currCartId = cartID;
         ccrz.cc_CallContext.userLocale	= 'en_US';
         //ccrz.cc_CallContext.currContact= createContact;
         ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
         ccrz.cc_CallContext.initRemoteContext(ctx);                     
     	string param = 'https://test-cumminscss.cs124.force.com/CSSNAStore/s/my-account?orderid='+ createOrder.id +'&store=US';
     	Test.startTest();
         Dbu_Download_Invoice_wrapper_Ctrl.viewReturnInvoiceData(param);
		Test.stopTest();
     }
}
//UAT Deployment