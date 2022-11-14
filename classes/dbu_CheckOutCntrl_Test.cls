@isTest
public class dbu_CheckOutCntrl_Test {
	//commment
    private static string ACCOUNT_REGION     =  'US and Canada';
    private static string TIMEZONE         =  '(GMT-05:00) Eastern Standard Time (America/Panama)';
    private static string EMAIL_ENCODING     =  'General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
    private static string LOCALE        =  'English(United States)';
    private static string LANGUAGE        =  'English';
    private static string BILLING_COUNTRY    =  'United States';
  private static string EMAIL          =  'testuser@gmail.com';    
    private static string COMPANY_NAME      =  'test user company';   
    private static string PHONE          =  '83689376493';   
    private static string STATUS        =  'Active';
    private static string FIRSTNAME        =  'Test';
    private static string LASTNAME        =  'Customer';
    private static string NICKNAME        =  'NickCustomer';
    private static string EMAIL_ENCODING_USER  =  'Unicode (UTF-8)';
    private static string USERNAME              =   'testuserkaazzanrussia@gmail.com';           
    
    @testsetup static void setuptestdata(){

        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
        
        System.runAs(admin) {  
            
            //Get RecordTypeID 
            Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
            //Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            
            //Get Profile Id - IAM User
            Id profileId = [Select Id From Profile Where Name='IAM User'].id;
        
            //Setup Account for Logged In user
            Account acc               =  dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
            insert acc;

            //Setup Contact for Logged In user - without Wishlist
            //Contact con                =  dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
          //con.Username__c              =  UserInfo.getUserName();
            //insert con; 
            
            
          String orgId = UserInfo.getOrganizationId();  
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
          //con.Username__c              =  uniqueName + '@test' + orgId + '.org';
            
          Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;            
          
            
            //Setup user for Logged In user
            //user usr                =  dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
          //usr.Username              =  'asayishq26@hapsburg.us';
          //usr.ContactId              =  null;
            //insert usr;
        

      

      //Setup PriceList 
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
          TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
          TestProduct3.dbu_Crate_Engine__c = true;    
          TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
            TestProductList.add(TestProduct5);
            
            List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
            list<ccrz__E_ProductMedia__c>  ProductsMediaList   = new list<ccrz__E_ProductMedia__c>();
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
                    string ProductInventoryItemName =  'ProdInv'+Count;
                    double QuantityAvailable    =  10+Count;
                    string availablemessage     =  'In stock';
                    string status          =  'In Stock';
                    ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                    ProductsINvlist.add(TestProdInventory);
                    
                    string PricelistitemName = 'PricelistItem'+Count;
                    double OriginalPrice   = 100+Count;
                    double discountAmt      = 15+Count;
                    double Price        = OriginalPrice - discountAmt;                
                    
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


            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();              

            ccrz__E_ContactAddr__c shipadd      =  dbu_FactoryDataTest.createContactAddress('12/plot 3', 'barrio estate', 'TX', '4535343', 'United States', 'Texas');
            shipadd.dbu_Contact__c          =  con.id;
            insert shipadd;

            ccrz__E_ContactAddr__c billadd      =  dbu_FactoryDataTest.createContactAddress('12/plot 1', 'barrio estate', 'TX', '4535343', 'United States', 'Texas');
            billadd.dbu_Contact__c          =  con.id;
            insert billadd;            
            
            ccrz__E_Cart__c CARTItem        =  dbu_FactoryDataTest.createCart('MyCart', 'Cart', admin.id, con.id, acc.id, true);
            CARTItem.ccrz__ShipTo__c        =  shipadd.id;
            CARTItem.ccrz__BillTo__c        =  billadd.id;
            CARTItem.dbu_Pick_Up_From_Store__c = null;
            insert CARTItem;

            ccrz__E_Cart__c CARTItem2        =  dbu_FactoryDataTest.createCart('MyCart2', 'Cart', admin.id, con.id, acc.id, true);
            CARTItem2.ccrz__BillTo__c        =  billadd.id;
            CARTItem2.dbu_Pick_Up_From_Store__c = shipadd.id;
            insert CARTItem2;            
           
            double Qcounter = 0;
            string CurrentProductID;
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                CurrentProductID = string.valueof(PrcLn.ccrz__Product__c);
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(CARTItem.id, (double)PrcLn.ccrz__Price__c, Qcounter, PrcLn.ccrz__Product__c);
                Qcounter = Qcounter + 1;
                crtline.dbu_isShipTo__c = true;
                crtLinesList.add(crtline);
            }            
            
            insert crtLinesList;    

            
        }    
    }
    
    @isTest public static void testmethodnewing(){
        contact cont = [select id from contact where firstname =: FIRSTNAME and lastname =: LASTNAME];        
        ccrz__E_Cart__c CURCART = [select id from ccrz__E_Cart__c where ccrz__Name__c = 'MyCart'];
        system.debug('Karlowitz > ' + CURCART);
            
        test.startTest();
                    
            dbu_CheckOutCntrl.insertPickUpStoreDataInCCObj('US',CURCART.id ,'Ship To' ,'hudson islands',
                                                   'sleepy hollow','73742 felt street','washington',
                                                    '737429','USA','1-938-73748'
                                                    );
        test.stoptest();
    }
    
    @isTest public static void testmethd(){
        string add1  =  '12/plot 3';
        string add2    =  'barrio estate';
        string state  =  'TX';
        string zip     =  '4535343';
        string country   =  'United States';
        string city    =  'Texas';
        
        ccrz__E_ContactAddr__c shipad = [select id from ccrz__E_ContactAddr__c where ccrz__AddressFirstline__c = '12/plot 3'];
        ccrz__E_ContactAddr__c billpad = [select id from ccrz__E_ContactAddr__c where ccrz__AddressFirstline__c = '12/plot 1'];
        ccrz__E_Cart__c carta = [select id from ccrz__E_Cart__c where ccrz__Name__c = 'MyCart'];
        contact cont = [select id from contact where firstname =: FIRSTNAME and lastname =: LASTNAME];
        
        Test.startTest();
        
        String shippingadd = dbu_CheckOutCntrl.insertShippingInfo(add1, add2, state, zip, country, city, 'FN','LN');
        
        String Billingadd = dbu_CheckOutCntrl.insertBillingInfo(add1, add2, state, zip, country, city);
        
        //String firstnme, string lstnme, string email, string phn, string cmnyname, string finalShipAddressId, string finalBillingAddressId, string cartID
        dbu_CheckOutCntrl.insertUserInfo(FIRSTNAME, LASTNAME, EMAIL, PHONE, COMPANY_NAME, shipad.id, billpad.id, carta.id);
        
        list<ccrz__E_Cart__c> shpToData = dbu_CheckOutCntrl.getShiptoBilltoData((string)carta.id);
        
        decimal shipAmtUpdate =  dbu_CheckOutCntrl.updateShippingAmountOnCart(true, (string)carta.id , 'Albama');
        
        dbu_CheckOutCntrl.updateCCAddress((string)shipad.id ,'Afrika Korps','Billing','Erwin',
                                               'Rommel','erwinrommel@whermacht.de','873783389','Tripoli','Libya',
                                               'Berlin','Bavaria','8377439','Germany',true,'DesertFox');        
        
        
        Map<string,object> CntAddMap = new Map<string,object>{
              'cmnynameNew'   => 'FGOC',
                'contactIdNew'   => cont.ID,
                'addTypeNew'    => 'Billing',
                'firstnameNew'  => 'Miguel felix',
                'lastnameNew'  =>  'Gallardo',
                'add1New'    =>  'Sinaloa la cathedral',  
                'add2New'    =>  'policia municipal',
                'cityNew'    =>  'Guadalajara',
                'stateNew'    =>  'Jalisco',
                'zipNew'    =>   '389379',
                'cntryNew'    =>  'Mexico',
                'defaultedAddressNew'  => 'true'
        };
            
        Map<string,object> storeAddressJsonMap = new Map<string,object>{
              'pickupstorename'   => 'Cummins Sales & Service - Anchorage',
                'cityPickup'   => 'Anchorage',
                'streetPickup'    => '2618 Commercial Avenue',
                'statePickup'  => 'Alaska',
                'zipPickup'  =>  '99501',
                'cntryPickup'    =>  'U.S.A',  
                'businessHrs'    =>  '8:00 AM - 5:00 PM YST',
                'storeLocCode'    =>  '06',
                'timeZone'    =>  'YST',
                'zone'    =>   'MDC',
                'cartId'    =>  carta.Id,
                'cartItemId'  => '',
                'isShipTo'  => false,
                'productId'  => '',
                'storeId'  => '' 
        };
            
    
        

       
            dbu_CheckOutCntrl.addCCContactAddress(JSON.serialize(new List<Map<string,object>>{CntAddMap}));
          
          dbu_CheckOutCntrl.deleteContactAdd(billpad.id);
          
          dbu_CheckOutCntrl.updateDefaultAddressData(cont.id ,(string)shipad.id ,'Shipping Comments');
        
        dbu_CheckOutCntrl.insertPickUpStoreDataInCCObj((string)carta.id ,'Pickup','ichabod crane',
                                                    'hudson islands','sleepy hollow','washington',
                                                    '73742','USA','1-938-73748',
                                                    'yes pickup');
          
          dbu_CheckOutCntrl.insertUpdatePickUpStoreDataInCCObj(JSON.serialize(storeAddressJsonMap));
            
          ccrz__E_Cart__c cartb = [select id from ccrz__E_Cart__c where ccrz__Name__c = 'MyCart2'];

          dbu_CheckOutCntrl.insertUpdatePickUpStoreDataInCCObj(JSON.serialize(storeAddressJsonMap));
          storeAddressJsonMap.remove('cartId');
          storeAddressJsonMap.put('cartId',cartb.Id);
          dbu_CheckOutCntrl.insertUpdatePickUpStoreDataInCCObj(JSON.serialize(storeAddressJsonMap));
         
        
            dbu_CheckOutCntrl.getProductRelatedSpecWeight('cartId');
        
        Test.stopTest();
    }
    
}