@isTest
public class dbu_CalculateDates_Test {
    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'America/Panama';
    private static string EMAIL_ENCODING 		=	'ISO-8859-1';
    private static string LOCALE				=	'English(United States)';
    private static string LANGUAGE				=	'English';
    private static string BILLING_COUNTRY		=	'United States';
	private static string EMAIL					=	'testuser@gmail.com';    
    private static string COMPANY_NAME			=	'test user company';   
    private static string PHONE					=	'83689376493';   
    private static string STATUS				=	'Active';
    private static string FIRSTNAME				=	'Test';
    private static string LASTNAME				=	'Customer';
    private static string NICKNAME				=	'NickCustomer';
    private static string EMAIL_ENCODING_USER	=	'UTF-8';
    private static string USERNAME              =   '38788ullmann@cmiuser.com.fulluat'; 
    private static Date START_DATE				=	Date.parse('6/20/2019');
    private static Date END_DATE				=	Date.parse('12/31/2099');
    
    private static string JSONISED_RESPONSE = '[{"Inventory":{"items":{"item":[{"availableQuantity": "0", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "IRD"},{"availableQuantity": "270", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "DRD"},{"availableQuantity": "130", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "PRD"},{"availableQuantity": "142", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "ARD"},{"availableQuantity": "244", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "HRD"},{"availableQuantity": "15", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "K6"},{"availableQuantity": "356", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "X5"},{"availableQuantity": "34", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "N8"},{"availableQuantity": "0", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "A1"},{"availableQuantity": "121", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "E4"},{"availableQuantity": "100", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "N9"},{"availableQuantity": "34", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "Y9"}]}}}]';

    @testSetup 
    static void SettingUpTestData(){   
        string storeCountry = 'US';
        ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
        insert TestPricelist;
        //Setup Products
        list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
        ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
        TestProduct1.DBU_Product_Location__c = storeCountry;
        TestProduct1.dbu_Crate_Engine__c = true;
        TestProduct1.dbu_Available_to_ship__c = true;
        TestProduct1.dbu_Pick_Up_Only__c = false;                
        TestProductList.add(TestProduct1);
        
        ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
        TestProduct2.DBU_Product_Location__c = storeCountry;
        TestProduct2.dbu_Available_to_ship__c = true;
        TestProduct2.dbu_Pick_Up_Only__c = false;
        TestProductList.add(TestProduct2);
        
        ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        TestProduct3.DBU_Product_Location__c = storeCountry;
        TestProduct3.dbu_Available_to_ship__c = true;
        TestProduct3.dbu_Pick_Up_Only__c = false;                
        TestProductList.add(TestProduct3);
        
        ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
        TestProduct4.DBU_Product_Location__c = storeCountry;
        TestProduct4.dbu_Has_Core_Charge__c = true;
        TestProduct4.dbu_Available_to_ship__c = false;
        TestProduct4.dbu_Pick_Up_Only__c = true;                
        TestProductList.add(TestProduct4);
        
        ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
        TestProduct5.DBU_Product_Location__c = storeCountry;
        TestProduct5.dbu_Available_to_ship__c = false;
        TestProduct5.dbu_Pick_Up_Only__c = true;                
        TestProductList.add(TestProduct5);


        List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
        list<ccrz__E_ProductMedia__c>  ProductsMediaList	 = new list<ccrz__E_ProductMedia__c>();
        list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
        
        Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false);                
        Integer Count = 0;
        for (Database.SaveResult sr : TestProductInsertedList) {            
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                
                //Setup Product Media 
                ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Image');
                ProductsMediaList.add(TestProductMedia1);
                
                ccrz__E_ProductMedia__c TestProductMedia2 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Search Image');
                ProductsMediaList.add(TestProductMedia2);
                
                //Setup Product Inventory Item
                string ProductInventoryItemName =	'ProdInv'+Count;
                double QuantityAvailable		=	10+Count;
                string availablemessage 		=	'In stock';
                string status					=	'In Stock';
                ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                ProductsINvlist.add(TestProdInventory);
                
                string PricelistitemName = 'PricelistItem'+Count;
                double OriginalPrice	 = 100+Count;
                double discountAmt 		 = 15+Count;
                double Price 			 = OriginalPrice - discountAmt;                
                
                //Setup PriceListItem for the product
                ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, sr.getId(), TestPricelist.id);                
                ProductPriceListItems.add(TestPriceListItem);
                
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }

        //insert pricelist items
        insert ProductPriceListItems;
        
        //insert product medias
        insert ProductsMediaList;
        
        //insert Product inventory 
        insert ProductsINvlist;
        //Setup addresses
        list<ccrz__E_ContactAddr__c> addressList = new list<ccrz__E_ContactAddr__c>();
       
        
        ccrz__E_ContactAddr__c shipToaddress = new ccrz__E_ContactAddr__c ();
        shipToaddress.ccrz__FirstName__c = 'ITZHAK';
        shipToaddress.ccrz__LastName__c = 'STEIN';
        shipToaddress.ccrz__AddressFirstline__c = 'GOLDA MEIR STREET';
        shipToaddress.ccrz__City__c = 'ASHDOD';
        shipToaddress.ccrz__State__c = 'GOLAN HEIGHTS';
        shipToaddress.ccrz__Country__c = 'ISRAEL';
        shipToaddress.ccrz__PostalCode__c = '90001';
        shipToaddress.CurrencyIsoCode = 'USD'; 
        shipToaddress.ccrz__ShippingComments__c = 'shipto';
        addressList.add(shipToaddress);
        
        ccrz__E_ContactAddr__c BillingAddress = new ccrz__E_ContactAddr__c ();
        BillingAddress.ccrz__FirstName__c = 'MOTTA';
        BillingAddress.ccrz__LastName__c = 'GUR';                    
        BillingAddress.ccrz__AddressFirstline__c = 'GOLDA MEIR STREET';
        BillingAddress.ccrz__City__c = 'ASHDOD';
        BillingAddress.ccrz__State__c = 'GOLAN HEIGHTS';
        BillingAddress.ccrz__Country__c = 'ISRAEL';
        BillingAddress.ccrz__PostalCode__c = '90001';
        BillingAddress.CurrencyIsoCode = 'USD';  
        BillingAddress.ccrz__ShippingComments__c = 'billto';
        addressList.add(BillingAddress);

		insert addressList;
    }
    @isTest
    static void testmethod1(){
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Fairbanks';
        pickupaddress.ccrz__State__c = 'Alaska';
        pickupaddress.ccrz__Country__c = 'U.S.A';
        pickupaddress.ccrz__PostalCode__c = '90001';
        pickupaddress.CurrencyIsoCode = 'USD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'MDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'USD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'US';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'DRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        
        
        Datetime now = Datetime.now();
        string presentday = now.format('E');
        datetime ordereddate;
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sun'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sun'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList = new dbu_HolidaysList__c();
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        objdbuHolidaysList.dbu_Country__c	 = 'US';
        insert objdbuHolidaysList;
        
        //Call estimatedPickUpDateCalculate method
        Test.startTest();
            dbu_CalculateDates.estimatedPickUpDateCalculate(objdbu_CartItemWrapper,lstInventoryWrapper,currcart);
        	
        	now = Datetime.now();
            presentday = now.format('E');
             
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Sat'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Sat'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            }
        
            //dbu_CalculateDates.holidayCalulator(null,null,(datetime.now()).addDays(34),'US', null, 'In-Stock');
            
        	dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'US', null, 'In-Stock', null);
        	dbu_CalculateDates.FetchEstimatedDelivery();
        
			now = Datetime.now();
            presentday = now.format('E');
        
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Wed'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Wed'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            } 
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        update objdbuHolidaysList;
        dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'US', null, 'In-Stock', null);
        Test.stopTest(); 
    }
    
    @isTest
    static void testmethod2(){
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Calgary';
        pickupaddress.ccrz__State__c = 'Alberta';
        pickupaddress.ccrz__Country__c = 'Canada';
        pickupaddress.ccrz__PostalCode__c = 'T2B 3H6';
        pickupaddress.CurrencyIsoCode = 'CAD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'MDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'CAD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'CA';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'DRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        
        
        Datetime now = Datetime.now();
        string presentday = now.format('E');
        datetime ordereddate;
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sun'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sun'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList = new dbu_HolidaysList__c();
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        objdbuHolidaysList.dbu_Country__c	 = 'CA';
        objdbuHolidaysList.dbu_ProvincesIncluded__c = 'All';
        //objdbuHolidaysList.dbu_ProvincesExcluded__c
        insert objdbuHolidaysList;
        
        //Call estimatedPickUpDateCalculate method
        Test.startTest();
            dbu_CalculateDates.estimatedPickUpDateCalculate(objdbu_CartItemWrapper,lstInventoryWrapper,currcart);
        	
        	now = Datetime.now();
            presentday = now.format('E');
             
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Sat'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Sat'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            }
        
        	dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'CA', 'Alberta', 'In-Stock', null);
            objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        	update objdbuHolidaysList;
        	dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'CA', 'Alberta', 'In-Stock', null);
        
        
        
			now = Datetime.now();
            presentday = now.format('E');
        
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Wed'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Wed'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            } 
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'CA', 'Alberta', 'In-Stock', null);
        update objdbuHolidaysList;
        dbu_CalculateDates.holidayCalulator(null,null, ordereddate, 'CA', 'Alberta', 'In-Stock', null);
        Test.stopTest(); 
    }     
    
    
    @isTest
    static void testmethod3(){
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Fairbanks';
        pickupaddress.ccrz__State__c = 'Alaska';
        pickupaddress.ccrz__Country__c = 'U.S.A';
        pickupaddress.ccrz__PostalCode__c = '90001';
        pickupaddress.CurrencyIsoCode = 'USD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'MDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'USD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'US';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'IRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        
        
        Datetime now = Datetime.now();
        string presentday = now.format('E');
        datetime ordereddate;
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sun'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sun'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList = new dbu_HolidaysList__c();
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        objdbuHolidaysList.dbu_Country__c	 = 'US';
        insert objdbuHolidaysList;
        
        //Call estimatedPickUpDateCalculate method
        Test.startTest();
            dbu_CalculateDates.estimatedPickUpDateCalculate(objdbu_CartItemWrapper,lstInventoryWrapper,currcart);
        	
        	now = Datetime.now();
            presentday = now.format('E');
             
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Sat'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Sat'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            }
        
            //dbu_CalculateDates.holidayCalulator(null,null,(datetime.now()).addDays(34),'US', null, 'In-Stock');
            date startdate = (ordereddate.addDays(7)).date();
            date enddate = (ordereddate.addDays(10)).date();
        
        
        	dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'US', null, 'Out of Stock', 'MDC'); 
        
         //For Holiday
            dbu_HolidaysList__c objdbuHolidays = new dbu_HolidaysList__c();
            objdbuHolidays.dbu_holidayDate__c = ordereddate.date();
            objdbuHolidays.dbu_Country__c	 = 'US';
            insert objdbuHolidays;
        
        //For Holiday
            dbu_HolidaysList__c objdbuHolidays1 = new dbu_HolidaysList__c();
            objdbuHolidays1.dbu_holidayDate__c = enddate;
            objdbuHolidays1.dbu_Country__c	 = 'US';
            insert objdbuHolidays1;
        
        
        //For Holiday
            dbu_HolidaysList__c objdbuHolidays2 = new dbu_HolidaysList__c();
            objdbuHolidays2.dbu_holidayDate__c = enddate + 1;
            objdbuHolidays2.dbu_Country__c	 = 'US';
            insert objdbuHolidays2;
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'US', null, 'Out of Stock', 'MDC'); 
			now = Datetime.now();
            presentday = now.format('E');
        
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Wed'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        now = now.addDays(i);
                        system.debug('now > ' + now);
                        if(now.format('E') == 'Wed'){
                            ordereddate = now;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            } 
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'US', null, 'Out of Stock','MDC');  
       
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date();
        update objdbuHolidaysList;
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
       	dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'US', null, 'Out of Stock','MDC');  
        
        Test.stopTest(); 
    }
    
        @isTest
    static void testmethod4(){
        Test.startTest();
            List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
            //SHIP
            ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
            system.debug('ProductRet1 > ' + ProductRet1);
            ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
            system.debug('Priceline1 > ' + Priceline1);           
            
            //PICKUP
            ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
            system.debug('ProductRet2 > ' + ProductRet2);
            ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
            system.debug('Priceline2 > ' + Priceline2);          
            
            list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
            contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
            string billto;
            string shipto;
            string pickup;
            
            ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
            pickupaddress.ccrz__FirstName__c = 'AMICAM';
            pickupaddress.ccrz__LastName__c = 'YEHUD';
            pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
            pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
            pickupaddress.ccrz__City__c = 'Fairbanks';
            pickupaddress.ccrz__State__c = 'Alaska';
            pickupaddress.ccrz__Country__c = 'U.S.A';
            pickupaddress.ccrz__PostalCode__c = '90001';
            pickupaddress.CurrencyIsoCode = 'USD';
            pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
            pickupaddress.dbu_zone__c = 'MDC';
            pickupaddress.dbu_TimeZone__c = 'YST';
            pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
            pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
            insert pickupaddress;
                
            if(contactaddresslist.size() > 0){
                for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                    if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                        billto = eachaddress.id;    
                    }
                    
                    if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                        shipto = eachaddress.id;
                    }
                    
                    
                }            
            }
            
            pickup = pickupaddress.id;
            
            ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
            currcart.ccrz__Name__c					=	'MyCart';
            currcart.ccrz__CartType__c				=	'Cart';
            currcart.ccrz__CurrencyISOCode__c		=	'USD';
            currcart.ccrz__ActiveCart__c			=	true;
            currcart.ccrz__Storefront__c			=	'CSSNAStore';
            currcart.ccrz__CartStatus__c			=	'Open';  
            //currcart.ccrz__User__c				=    u.id;
            //currcart.ccrz__Contact__c				=	 cnts.id;
            //currcart.ccrz__Account__c				=	 cnts.accountid;  
            currcart.dbu_Cart_StoreCountry__c		=	 'US';
            currcart.ccrz__BillTo__c				=	 billto;
            currcart.ccrz__ShipTo__c				=	 shipto;
            currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
            currcart.dbu_StoreCode__c 				=    'IRD';
            insert currcart;
            currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
            
            list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
            ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
            shipcartline.dbu_isShipTo__c = true;
            shipcartline.dbu_Estimated_Delivery__c = '';
            shipcartline.dbu_Estimated_PickUp__c = '';
            insert shipcartline;
            
            
            ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
            pickcartline.dbu_isShipTo__c = false;
            pickcartline.dbu_Estimated_Delivery__c = '';
            pickcartline.dbu_Estimated_PickUp__c = '';
            insert pickcartline;
            
            
            dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
            objdbu_CartItemWrapper.cartItem = pickcartline;
            
            
            Datetime now = Datetime.now();
            string presentday = now.format('E');
            datetime ordereddate;
            system.debug('ordereddate > ' + ordereddate);
            if(presentday == 'Fri'){
                ordereddate = now;
                system.debug('ordereddate match > ' + ordereddate);
            }else{
                boolean breakloop = false;
                for(integer i=1; i<20 ; i++){
                    if(breakloop == false){
                        date datenow = now.date() + i;
                        system.debug('datenow > ' + datenow);
                        Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                        system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                        if(currentstackdatedt.format('E') == 'Fri'){
                            ordereddate = currentstackdatedt;
                            system.debug('ordereddate final set > ' + ordereddate);
                            breakloop = true;
                        }           
                    }
                }
            }

            system.debug('ordereddate final set333 > ' + ordereddate);
            date startdate = (ordereddate.addDays(7)).date();
            date enddate = (ordereddate.addDays(10)).date();
            
            //For Holiday1
            dbu_HolidaysList__c objdbuHolidaysList1 = new dbu_HolidaysList__c();
            objdbuHolidaysList1.dbu_holidayDate__c = enddate;
            objdbuHolidaysList1.dbu_Country__c	 = 'US';
            insert objdbuHolidaysList1;
            
            //For Holiday2
            dbu_HolidaysList__c objdbuHolidaysList2 = new dbu_HolidaysList__c();
            objdbuHolidaysList2.dbu_holidayDate__c = enddate + 1;
            objdbuHolidaysList2.dbu_Country__c	 = 'US';
            insert objdbuHolidaysList2;
            
            //For Holiday3
            dbu_HolidaysList__c objdbuHolidaysList3 = new dbu_HolidaysList__c();
            objdbuHolidaysList3.dbu_holidayDate__c = startdate + 1;
            objdbuHolidaysList3.dbu_Country__c	 = 'US';
            insert objdbuHolidaysList3;
            
    
            list<date> lstcurrentholiday = new list<date>();
            lstcurrentholiday.add(enddate);
        	lstcurrentholiday.add(enddate + 1);
      
            dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'US', null, 'Out of Stock', 'MDC'); 
            //dbu_CalculateDates.calulateHolidayafterEndDate(enddate,1, 'US','', lstcurrentholiday);
		Test.stopTest(); 
    }
    
    
    @isTest
    static void testmethod5(){
         Test.startTest();
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Fairbanks';
        pickupaddress.ccrz__State__c = 'Alaska';
        pickupaddress.ccrz__Country__c = 'U.S.A';
        pickupaddress.ccrz__PostalCode__c = '90001';
        pickupaddress.CurrencyIsoCode = 'USD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'MDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'USD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'US';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'DRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 500, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        dbu_CalculateDates.estimatedPickUpDateCalculate(objdbu_CartItemWrapper,lstInventoryWrapper,currcart);
        Test.stopTest(); 
    }
    
        @isTest
    static void testmethod6(){
         Test.startTest();
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Calgary';
        pickupaddress.ccrz__State__c = 'Alberta';
        pickupaddress.ccrz__Country__c = 'Canada';
        pickupaddress.ccrz__PostalCode__c = '90001';
        pickupaddress.CurrencyIsoCode = 'CAD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'RDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'CAD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'CA';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'IRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        
        Datetime now = Datetime.now();
        string presentday = now.format('E');
        datetime ordereddate;
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Fri'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Fri'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }           
       
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList = new dbu_HolidaysList__c();
        objdbuHolidaysList.dbu_holidayDate__c = ordereddate.date() - 2;
        objdbuHolidaysList.dbu_Country__c	 = 'CA';
        objdbuHolidaysList.dbu_ProvincesIncluded__c = 'All';
        //objdbuHolidaysList.dbu_ProvincesExcluded__c
        insert objdbuHolidaysList;
        
 		dbu_CalculateDates.estimatedPickUpDateCalculate(objdbu_CartItemWrapper,lstInventoryWrapper,currcart);
        dbu_CalculateDates.calculatepickupdate('Out of Stock', 'RDC',  'Fairbanks', 'Alaska', 'US');
        
        date startdate = (ordereddate.addDays(7)).date();
        date enddate = (ordereddate.addDays(10)).date();
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock',null);
        
        now = Datetime.now();
        presentday = now.format('E'); 
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sat'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sat'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
        
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList1 = new dbu_HolidaysList__c();
        objdbuHolidaysList1.dbu_holidayDate__c = startdate;
        objdbuHolidaysList1.dbu_Country__c	 = 'CA';
        objdbuHolidaysList1.dbu_ProvincesIncluded__c = 'All';
        //objdbuHolidaysList.dbu_ProvincesExcluded__c
        insert objdbuHolidaysList1;
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList2 = new dbu_HolidaysList__c();
        objdbuHolidaysList2.dbu_holidayDate__c = enddate - 1;
        objdbuHolidaysList2.dbu_Country__c	 = 'CA';
        objdbuHolidaysList2.dbu_ProvincesIncluded__c = 'All';
        //objdbuHolidaysList.dbu_ProvincesExcluded__c
        insert objdbuHolidaysList2; 
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock', null);
        
        
        now = Datetime.now();
        presentday = now.format('E'); 
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sun'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sun'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
        
        objdbuHolidaysList1.dbu_holidayDate__c = startdate;
        update objdbuHolidaysList1;
        
        objdbuHolidaysList2.dbu_holidayDate__c = enddate - 1;
        update objdbuHolidaysList2;
        
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock', null);
        
        
        now = Datetime.now();
        presentday = now.format('E'); 
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sat'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sat'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
        
        objdbuHolidaysList1.dbu_holidayDate__c = startdate;
        objdbuHolidaysList1.dbu_ProvincesExcluded__c = 'Alberta';
        update objdbuHolidaysList1;
        
        objdbuHolidaysList2.dbu_holidayDate__c = enddate - 1;
        objdbuHolidaysList2.dbu_ProvincesExcluded__c = 'Alberta';
        update objdbuHolidaysList2;
        
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock', null);
        
        
		now = Datetime.now();
        presentday = now.format('E'); 
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Sun'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Sun'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        startdate = (ordereddate.addDays(7)).date();
        enddate = (ordereddate.addDays(10)).date();
        
        objdbuHolidaysList1.dbu_holidayDate__c = startdate;
        objdbuHolidaysList1.dbu_ProvincesExcluded__c = 'Alberta';
        update objdbuHolidaysList1;
        
        objdbuHolidaysList2.dbu_holidayDate__c = enddate - 1;
        objdbuHolidaysList2.dbu_ProvincesExcluded__c = 'Alberta';
        update objdbuHolidaysList2;
                
        
        dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock', null);
        
        Test.stopTest(); 
    }
    
        @isTest
    static void testmethod7(){
         Test.startTest();
        List<Dbu_InventoryWrapper> lstInventoryWrapper = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
        pickupaddress.ccrz__FirstName__c = 'AMICAM';
        pickupaddress.ccrz__LastName__c = 'YEHUD';
        pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
        pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
        pickupaddress.ccrz__City__c = 'Calgary';
        pickupaddress.ccrz__State__c = 'Alberta';
        pickupaddress.ccrz__Country__c = 'Canada';
        pickupaddress.ccrz__PostalCode__c = '90001';
        pickupaddress.CurrencyIsoCode = 'CAD';
        pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
        pickupaddress.dbu_zone__c = 'RDC';
        pickupaddress.dbu_TimeZone__c = 'YST';
        pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
        pickupaddress.ccrz__ShippingComments__c = 'pickup'; 
        insert pickupaddress;
            
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                
            }            
        }
        
        pickup = pickupaddress.id;
        
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'CAD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'CSSNAStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        //currcart.ccrz__User__c				=    u.id;
        //currcart.ccrz__Contact__c				=	 cnts.id;
        //currcart.ccrz__Account__c				=	 cnts.accountid;  
        currcart.dbu_Cart_StoreCountry__c		=	 'CA';
        currcart.ccrz__BillTo__c				=	 billto;
        currcart.ccrz__ShipTo__c				=	 shipto;
        currcart.dbu_Pick_Up_From_Store__c		=	 pickup;
        currcart.dbu_StoreCode__c 				=    'IRD';
        insert currcart;
        currcart.dbu_Pick_Up_From_Store__r		=	 pickupaddress;
        
        list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
        shipcartline.dbu_isShipTo__c = true;
        shipcartline.dbu_Estimated_Delivery__c = '';
        shipcartline.dbu_Estimated_PickUp__c = '';
        insert shipcartline;
        
        
        ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        pickcartline.dbu_isShipTo__c = false;
        pickcartline.dbu_Estimated_Delivery__c = '';
        pickcartline.dbu_Estimated_PickUp__c = '';
        insert pickcartline;
        
        
        dbu_CartItemWrapper objdbu_CartItemWrapper = new dbu_CartItemWrapper();
        objdbu_CartItemWrapper.cartItem = pickcartline;
        
        Datetime now = Datetime.now();
        string presentday = now.format('E');
        datetime ordereddate;
        system.debug('ordereddate > ' + ordereddate);
        if(presentday == 'Thu'){
            ordereddate = now;
            system.debug('ordereddate match > ' + ordereddate);
        }else{
            boolean breakloop = false;
            for(integer i=1; i<20 ; i++){
                if(breakloop == false){
                    date datenow = now.date() + i;
                    system.debug('datenow > ' + datenow);
                    Datetime currentstackdatedt = DateTime.newInstance(datenow, Time.newInstance(0, 0, 0, 0));            
                    system.debug('now > ' + currentstackdatedt + ' ui > ' + currentstackdatedt.format('E'));
                    if(currentstackdatedt.format('E') == 'Thu'){
                        ordereddate = currentstackdatedt;
                        system.debug('ordereddate final set > ' + ordereddate);
                        breakloop = true;
                    }           
                }
            }
        }
        
        date startdate = (ordereddate.addDays(7)).date();
        system.debug('startdate > ' + startdate);
        date enddate = (ordereddate.addDays(10)).date();        
        system.debug('enddate > ' + enddate);
        
        //For Holiday
        dbu_HolidaysList__c objdbuHolidaysList = new dbu_HolidaysList__c();
        objdbuHolidaysList.dbu_holidayDate__c = enddate;
        objdbuHolidaysList.dbu_Country__c	 = 'CA';
        objdbuHolidaysList.dbu_ProvincesIncluded__c = 'All';
        objdbuHolidaysList.dbu_ProvincesExcluded__c = 'Quebec';
        insert objdbuHolidaysList;        
        
 		dbu_CalculateDates.holidayCalulator(startdate,enddate, ordereddate, 'CA', 'Alberta', 'Out of Stock',null);        
        
        
        
        Test.stopTest(); 
    }    
    
    @isTest
    static void testmethod8(){
        Test.startTest();
        
        
        dbu_CalculateDates.FetchMonth(1);        
        dbu_CalculateDates.FetchMonth(2);
        dbu_CalculateDates.FetchMonth(3);
        dbu_CalculateDates.FetchMonth(4);
        dbu_CalculateDates.FetchMonth(5);
        dbu_CalculateDates.FetchMonth(6);
        dbu_CalculateDates.FetchMonth(7);
        dbu_CalculateDates.FetchMonth(8);
        dbu_CalculateDates.FetchMonth(9);
        dbu_CalculateDates.FetchMonth(10);
        dbu_CalculateDates.FetchMonth(11);
        dbu_CalculateDates.FetchMonth(12);
        
        Test.stopTest();
    }
}