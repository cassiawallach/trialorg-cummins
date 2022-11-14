@isTest
public class dbu_GeolocationController_Test {
    @testsetup static void setuptestdata(){

        List<dbu_Store_Location__c> storeList = new List<dbu_Store_Location__c>();
        dbu_Store_Location__c testStoreLoc = dbu_FactoryDataTest.createStoreLocation();
        testStoreLoc.dbu_Geo_Location__Latitude__s = 12.996;
        testStoreLoc.dbu_Geo_Location__Longitude__s = 77.598;
        testStoreLoc.dbu_State__c = 'NY';
        testStoreLoc.dbu_Country__c = 'Canada';
        testStoreLoc.dbu_Location_Status__c = 'Released';

        storeList.add(testStoreLoc);

        dbu_Store_Location__c testStoreLocBlocked = dbu_FactoryDataTest.createStoreLocation();
        testStoreLocBlocked.dbu_Geo_Location__Latitude__s = 12.996;
        testStoreLocBlocked.dbu_Geo_Location__Longitude__s = 77.598;
        testStoreLocBlocked.dbu_State__c = 'NY';
        testStoreLocBlocked.dbu_Country__c = 'Canada';
        testStoreLocBlocked.dbu_Location_Status__c = 'Blocked';

        storeList.add(testStoreLocBlocked);

        insert storeList;
        
    }
    @isTest public static void getStoreLocation(){
        string address = '4420 Fairfax Dr #500, Arlington, VA 22203, United States';
        
        List<dbu_Store_Location__c> storeLoc = [SELECT Id, Name,dbu_Business_Hours__c,dbu_City__c,dbu_Country__c,
                                          dbu_Geo_Location__c,dbu_Geo_Location__longitude__s,
                                          dbu_Geo_Location__Latitude__s,dbu_Phone__c,dbu_StoreCode__c,
                                          dbu_Street__c,dbu_State__c,dbu_ZipCode__c FROM dbu_Store_Location__c where dbu_Country__c = 'Canada'
                                         and dbu_State__c = 'NY'];
        dbu_GeolocationController.retriveAccs(storeLoc[0].dbu_State__c,12.9716, 77.5946);
        dbu_GeolocationController.retriveAccs(storeLoc[1].dbu_State__c,12.9716, 77.5946);
        dbu_GeolocationController.retriveAccs('',12.9716, 77.5946);
        dbu_GeolocationController.retriveAccsZipCode('22203',12.9716, 77.5946);        
        
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        //testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
        objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        objAddress.ccrz__AddressSecondline__c = '';
        objAddress.ccrz__City__c = 'Columbus';
        objAddress.ccrz__CompanyName__c = 'HCL';
        objAddress.ccrz__Country__c = 'United States';
        objAddress.ccrz__CountryISOCode__c = 'US';
        objAddress.ccrz__FirstName__c = 'Sharad';
        objAddress.ccrz__Email__c = 'test@gamil.com';
        objAddress.ccrz__LastName__c = 'Sahu';
        objAddress.ccrz__PostalCode__c = '47201';
        objAddress.ccrz__StateISOCode__c = 'IN';
        objAddress.ccrz__State__c = 'Indiana';
        
        insert objAddress;
        
        // List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        testCart.ccrz__BillTo__c = objAddress.Id;
        testCart.ccrz__ShipTo__c = objAddress.Id;
        testCart.ccrz__TaxAmount__c = 12;
        testCart.ccrz__Account__c=testAccount.Id;
        
        
        testCart.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e681111';
        insert testCart;
        
        //CC Order
        ccrz__E_Order__c ord = new ccrz__E_Order__c ();
        ord.ccrz__Storefront__c = 'CSSNAStore';
        ord.ccrz__Account__c = testAccount.Id;
        ord.ccrz__CurrencyISOCode__c = 'USD';
        ord.ccrz__OriginatedCart__c = testCart.Id;
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
        insert ord;
        
        ccrz__E_OrderItem__c ordItem = new ccrz__E_OrderItem__c();
        ordItem.ccrz__Order__c = ord.id;
        ordItem.ccrz__Price__c = 350;
        ordItem.ccrz__Quantity__c = 3;
        ordItem.ccrz__SubAmount__c = 1050;
        ordItem.ccrz__OrderItemStatus__c = null;
        insert ordItem;
        
        
        dbu_GeolocationController.updateShipTo(true,ord.id);
        dbu_GeolocationController.getShipToStoreAddress(ord.id);
        dbu_GeolocationController.getShipTo(ord.id);
        dbu_GeolocationController.updateShipToStoreAddress(ord.id,address);
        
        
        
        
    }
    
}
//UAT Deployment