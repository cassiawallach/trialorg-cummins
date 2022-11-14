@isTest
public class dbu_VertexCtrl_Test { 
  public  static testMethod void unitTest() {
         Account objAcc = new Account(Name = 'Test', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		// insert objAccs;
        ccrz__E_ContactAddr__c objShipTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
			insert objShipTo; 
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__ShipTo__c = objShipTo.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product',ccrz__Taxable__c = true, ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
        insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;//CHG0084922
        
        List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;
      Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, null);
        dbu_VertexCtrl.getVertexInvoiceTax(null);
      Test.stopTest();
        //System.assertEquals('','');
    }
    
   public static testMethod void unitTest1() {
         
         Account objAcc = new Account(Name = 'Test1', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		// insert objAcc;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__BillTo__c = objBillTo.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product', ccrz__Taxable__c = true, ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
        insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
        
         List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;

       Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, null);
        dbu_VertexCtrl.getVertexInvoiceTax(null);
       Test.stopTest();
        //System.assertEquals('','');
    }
    
   public static testMethod void unitTest2() {
         Account objAcc = new Account(Name = 'Test2', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		// insert objAcc;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__BillTo__c = objBillTo.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product', ccrz__Taxable__c = true, ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
         insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
        
        dbu_VertexCtrl.getVertexInvoiceTax(null);
        dbu_Addresses objAddresses = new dbu_Addresses();
        dbu_Addresses.Address objAddress = new dbu_Addresses.Address();
        objAddress.address1 = '330 Potrero';
        objAddress.address2 = '330 Potrero';
        objAddress.address3 = '330 Potrero';
        objAddress.city = 'Sunnyvale';
        objAddress.state = 'California';
        objAddress.country = 'United States';
        objAddress.postalCode = '94085';
        objAddresses.billingAddress = objAddress;
        objAddresses.shippingAddress = objAddress;
        
         List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;

       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, objAddresses);
       Test.stopTest();
        //System.assertEquals('','');
    }
    
   public static testMethod void unitTest3() {
         Account objAcc = new Account(Name = 'Test3', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		// insert objAcc;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product', ccrz__Taxable__c = true, ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
        insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
          List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;

       Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, null);
        dbu_VertexCtrl.getVertexInvoiceTax(null);
       Test.stopTest();
        //System.assertEquals('','');
    }
    
   public static testMethod void unitTest4() {
        dbu_Addresses objAddresses = new dbu_Addresses();
        dbu_Addresses.Address objAddress = new dbu_Addresses.Address();
        objAddress.address1 = '330 Potrero';
        objAddress.address2 = '330 Potrero';
        objAddress.address3 = '330 Potrero';
        objAddress.city = 'Sunnyvale';
        objAddress.state = 'California';
        objAddress.country = 'United States';
        objAddress.postalCode = '94085';
        objAddresses.billingAddress = objAddress;
        objAddresses.shippingAddress = objAddress;
       // dbu_Addresses objAdd = new dbu_Addresses();

		//ccrz__E_ContactAddr__c   objAdd = new  ccrz__E_ContactAddr__c();
        
         Account objAcc = new Account(Name = 'Test4', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		// insert objAcc;
        ccrz__E_ContactAddr__c objShipTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
			insert objShipTo;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore',ccrz__ShipMethod__c = 'Ramassage', ccrz__Account__c = objAcc.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product',ccrz__Taxable__c = true, ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
         insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ParentCartItem__c = Null ,Prorated_Price__c = 5.00, ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
         List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;
Test.startTest();
       Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, objAddresses);
        dbu_VertexCtrl.getVertexInvoiceTax(null);
       Test.stopTest();
        //System.assertEquals('','');
    }
    
    
   public static testMethod void unitTest5() {
        dbu_Addresses objAddresses = new dbu_Addresses();
        dbu_Addresses.Address objAddress = new dbu_Addresses.Address();
        objAddress.address1 = '330 Potrero';
        objAddress.address2 = '330 Potrero';
        objAddress.address3 = '330 Potrero';
        objAddress.city = 'Sunnyvale';
        objAddress.state = 'California';
        objAddress.country = 'United States';
        objAddress.postalCode = '94085';
        objAddresses.billingAddress = objAddress;
        objAddresses.shippingAddress = objAddress;
       // dbu_Addresses objAdd = new dbu_Addresses();

		//ccrz__E_ContactAddr__c   objAdd = new  ccrz__E_ContactAddr__c();
        
         Account objAcc = new Account(Name = 'Test5', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
		 //insert objAcc;
        ccrz__E_ContactAddr__c objShipTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
			insert objShipTo;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
	        insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', dbu_Pick_Up_From_Store__c = objBillTo.Id,ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore',ccrz__ShipMethod__c = 'Ramassage', ccrz__Account__c = objAcc.Id);
        	insert objCart;
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(Name = 'Test Product',ccrz__Taxable__c = true,ccrz__SKU__c = 'Abcde-5', ccrz__Storefront__c = 'Storefront',	ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22));
         insert objProduct;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ParentCartItem__c = Null ,Prorated_Price__c = 5.00, ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
          List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        insert lstcus;

       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_VertexCtrl.getVertexQuoteTax(objCart.Id, null);
        dbu_VertexCtrl.getVertexInvoiceTax(null);
       Test.stopTest();
        //System.assertEquals('','');
    }

}