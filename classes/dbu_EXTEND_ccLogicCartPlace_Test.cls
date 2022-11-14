@isTest
public class dbu_EXTEND_ccLogicCartPlace_Test {
	
    @isTest static void testmethod1(){
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;        
        
        System.runAs(admin){
        
        //user u = [select id,Contactid from User where Email = 'xyztestuser@gmail.com'];
        //contact cnts = [select id,accountid from contact where id =: u.Contactid];;
   
        ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
        insert TestPricelist;            
            
        ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
        TestProduct1.DBU_Product_Location__c = 'CA';
        TestProduct1.dbu_Crate_Engine__c = true;
        insert TestProduct1;
            
        ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(TestProduct1.id, 'Product Image');
        insert TestProductMedia1;

        string PricelistitemName = 'PricelistItem';            
        double OriginalPrice	 = 100;
        double discountAmt 		 = 15;            
        double Price 			 = OriginalPrice - discountAmt;
            
		ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, TestProduct1.id, TestPricelist.id);                
		insert TestPriceListItem;		            
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'CAD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c					=	u.id;
        //currcart.ccrz__Contact__c				=	cnts.id;
        //currcart.ccrz__Account__c				=	cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	'CA';
        insert currcart; 
            
        ccrz__E_CartItem__c cartline  = dbu_FactoryDataTest.createCartItem(currcart.id, 99, 2, TestProduct1.id);  
        cartline.Vertex_tax__c = 8;
        insert cartline;            
            
            
        ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
        objOrder.ccrz__OriginatedCart__c = currcart.id;
        objOrder.ccrz__PaymentMethod__c = 'CARD';
        objOrder.ccrz__Storefront__c = 'CSSNAStore';
        objOrder.ccrz__Name__c = 'MINE ORDER';
        objOrder.ccrz__OrderStatus__c = 'Order Submitted';
        objOrder.CurrencyIsoCode = 'CAD';
        insert objOrder;
            
            ccrz__E_OrderItem__c objorderline = new ccrz__E_OrderItem__c();
            objorderline.ccrz__Order__c = objOrder.id;
            objorderline.ccrz__Price__c = 99;
            objorderline.ccrz__Quantity__c = 2; 
            objorderline.ccrz__SubAmount__c = 99*2;
            objorderline.ccrz__Product__c = TestProduct1.id;
            objorderline.ccrz__RequestDate__c  = date.parse('2/2/1999');
            objorderline.ccrz__PricingType__c  = 'auto';
            objorderline.ccrz__ProductType__c  = 'Product';
            objorderline.ccrz__OrderLineType__c = 'Major';
            objorderline.ccrz__StoreId__c  = 'CSSNAStore';
            objorderline.ccrz__ItemStatus__c = 'Available';
            objorderline.ccrz__OriginalQuantity__c = 2;
            objorderline.ccrz__OriginalItemPrice__c = 99;
            objorderline.ccrz__UnitOfMeasure__c = 'Each';
            insert objorderline;
            
            
            
        ccrz__E_Invoice__c OBJINVOICE = new ccrz__E_Invoice__c();
        OBJINVOICE.ccrz__CCOrder__c = objOrder.id;
        insert OBJINVOICE;        
        
        ccrz__E_TransactionPayment__c trasPayment = new ccrz__E_TransactionPayment__c(); 
        trasPayment.ccrz__CCOrder__c = objOrder.id;
        trasPayment.ccrz__AccountNumber__c = 'ARMY GROUP VISTULA 1945';
        trasPayment.ccrz__AccountType__c = 'PANZER GROUPE';
        trasPayment.ccrz__Amount__c = 8833;
        trasPayment.ccrz__RequestAmount__c = 10000; 
        trasPayment.ccrz__CurrencyISOCode__c = 'CAD';
        trasPayment.ccrz__TransactionType__c = 'CARD';
        trasPayment.ccrz__VerificationCode__c = '5678596054DHJF';
        trasPayment.ccrz__TransactionTS__c = Date.parse('11/11/2020');
        trasPayment.ccrz__Storefront__c = 'CSSNAStore';
        trasPayment.ccrz__ExpirationMonth__c = 12;
        trasPayment.ccrz__ExpirationYear__c = 2021;
        trasPayment.ccrz__PaymentType__c = 'Debit Card';
        trasPayment.ccrz__SubAccountNumber__c = '2345678654';
        trasPayment.ccrz__Token__c	= '348759607';
        trasPayment.ccrz__TransactionCode__c = 'udv8883835899459';
        trasPayment.ccrz__TransactionPaymentId__c = '7ksdv9884398vsn349t';
        trasPayment.ccrz__TransactionSubcode__c = 'svnis4857wwyeur';
        trasPayment.ccrz__Comments__c  ='OPERATION BARBAROSSA';
        insert trasPayment;
        
        
        
        Map<string,object> InputDATA = new Map<string,object>();
        ccrz__E_TransactionPayment__c transPay= [select id,ccrz__CurrencyISOCode__c from ccrz__E_TransactionPayment__c where id =: trasPayment.id];
        Map<string,ccrz__E_TransactionPayment__c> innerMap = new  Map<string,ccrz__E_TransactionPayment__c>();
        innerMap.put('transactionCreated', transPay);
        string orderid = (string)objOrder.id;
        InputDATA.put('orderId', orderid);
        
        InputDATA.put('transactionResult',innerMap );
        ccrz.cc_hk_Payment.TransactionPaymentParams instance = new ccrz.cc_hk_Payment.TransactionPaymentParams();
        instance.transactionType = 'Visa';
        instance.accountNumber = 'xxxxxxxxxxxx1111';
        InputDATA.put('ctTransPayData',instance );    
            
        Test.startTest();
        dbu_EXTEND_ccLogicCartPlace LogicWLCreate = new dbu_EXTEND_ccLogicCartPlace();        
        LogicWLCreate.placeOrder(InputDATA);
        Test.stopTest();            
            
        }        
        

        
    }
    
}