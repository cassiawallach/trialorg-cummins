/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-20-2022
 * @last modified by  : Ramesh
 * 
**/
@isTest

public class dbu_ReturnCCOrderApiUtil_Test 
{
    public static testMethod void returnCCOrderApiUtilTest(){
         // deployment Comments
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount; 
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Product_Code__c='CECO';
        insert createProduct;
        
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='Canada';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Ship To Address';
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__OriginatedCart__c = createCart.Id;
        createOrder.ccrz__PaymentMethod__c='credit card';
       // createOrder.dbu_Days_Since_Order_Date__c = 50;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OriginalQuantity__c=1;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Dropoff_Location__c='623 5th Ave 19th floor, New York, NY 10022, United States';
        createOrderItem.dbu_Return_Amount__c=20.22;
        createOrderItem.dbu_Return_Tax__c=3.12;
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<Object> orderData = new List<Object>();
        
        dbu_ReturnCCOrderApiUtil.returnOrderItemsWrp returnOItem = new dbu_ReturnCCOrderApiUtil.returnOrderItemsWrp();
        //returnOItem.URI='https://cssna-parts.gdc-rad.com/4955229.png';
        
       ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = false;
        orderItemObj.dbu_Return_Amount__c=20.22;
        orderItemObj.dbu_Return_Tax__c=3.12;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        insert orderItemObj;
        
        String urlParam ='https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/OderItems?orderid='+createOrder.Id;
        dbu_ReturnCCOrderApiUtil.getUserInfo();
        dbu_ReturnCCOrderApiUtil.returnOrderItemDetails(urlParam);
        dbu_ReturnCCOrderApiUtil.callReturnOrderAPI(createOrder.Id,listOrderItemIds);
        dbu_ReturnCCOrderApiUtil.checkingGenuineProduct(createOrder.Id);
        dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(createOrder.Id,listOrderItemIds,'submit');
        dbu_ReturnCCOrderApiUtil.partialReturnOrder(orderData,'Testing Returns','$223.22',createOrder.Id,'EN');
        dbu_ReturnCCOrderApiUtil.returnOrderItemsLocation(urlParam);
    }
    public static testMethod void callReturnOrderAPITest(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        //createAccount.BillingCountry = 'Canada';
        insert createAccount;//Added code with labels to replace special characters
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Has_Core_Charge__c=True;
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr1.ccrz__Country__c='US';
        createContactAddr1.ccrz__PostalCode__c='10022';
        insert createContactAddr1;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr1.Id;
        insert createCart;
        
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        //createContactAddr.ccrz__Country__c='CA';
        //createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.Id,createContactAddr.id);
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__ShipAmount__c=5.0;
        createOrder.ccrz__TaxAmount__c=1.0;
        createOrder.ccrz__ShipMethod__c='Pick Up';
        createOrder.ccrz__PaymentMethod__c='credit card';
        insert createOrder;
        
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        //transactionPayment.Name = 'Name';
        transactionPayment.ccrz__AccountNumber__c = '1411111111111111';
        transactionPayment.ccrz__TransactionType__c = 'visa';
        transactionPayment.ccrz__PaymentType__c = 'credit card';
        transactionPayment.ccrz__CCOrder__c = createOrder.Id;
        insert transactionPayment;
        
        
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__Price__c=0.00;
        createOrderItem.ccrz__AbsoluteDiscount__c=10.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.dbu_Return_Amount__c=20.22;
        createOrderItem.dbu_Return_Tax__c=3.12;
        createOrderItem.dbu_isShipTo__c = true;
        insert createOrderItem;
        
        CC_Tax__c tax = createTax(createOrderItem.Id);
        insert tax;
        
        List<Object> orderData = new List<Object>();
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_Return_Amount__c=20.22;
        orderItemObj.dbu_Return_Tax__c=3.12;
        orderItemObj.dbu_isShipTo__c = true;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        
        insert orderItemObj;
        CC_Tax__c tax1 = createTax(orderItemObj.Id);
        insert tax1;
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Return Initiated';
        orderItemObj1.ccrz__Order__c = createOrder.Id;
        orderItemObj1.ccrz__Product__c = createProduct.Id;
        orderItemObj1.dbu_Selected_Return_Items__c = True;
        orderItemObj1.dbu_Return_Amount__c=20.22;
        orderItemObj1.dbu_Return_Tax__c=3.12;
        orderItemObj1.dbu_isShipTo__c = true;
        insert orderItemObj1;
        CC_Tax__c tax2 = createTax(orderItemObj1.Id);
        insert tax2;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(orderItemObj.id);
        String urlParam ='https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/OderItems?orderid='+createOrder.Id;
        dbu_ReturnCCOrderApiUtil.returnOrderItemDetails(urlParam);
        dbu_ReturnCCOrderApiUtil.callReturnOrderAPI(createOrder.Id,listOrderItemIds);
        dbu_ReturnCCOrderApiUtil.checkingGenuineProduct(createOrder.Id);
        dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(createOrder.Id,listOrderItemIds,'submit');
    }
    public static testMethod void returnCCOrderApiUtilTest1(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Product_Code__c='CECO';
        insert createProduct; 
        
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='Canada';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;//Added Replace dbu_special_characters for User Input
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Pick Up';
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__OriginatedCart__c = createCart.Id;
        createOrder.ccrz__PaymentMethod__c='PayPal';
       // createOrder.dbu_Days_Since_Order_Date__c = 50;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OriginalQuantity__c=1;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Return_Amount__c=20.22;
        createOrderItem.dbu_Return_Tax__c=3.12;
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<Object> orderData = new List<Object>();
        
        dbu_ReturnCCOrderApiUtil.returnOrderItemsWrp returnOItem = new dbu_ReturnCCOrderApiUtil.returnOrderItemsWrp();
        //returnOItem.URI='https://cssna-parts.gdc-rad.com/4955229.png';
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = False;
        orderItemObj.dbu_Return_Amount__c=20.22;
        orderItemObj.dbu_Return_Tax__c=3.12;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        
        insert orderItemObj;
        String urlParam ='https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/OderItems?orderid='+createOrder.Id;
        dbu_ReturnCCOrderApiUtil.getUserInfo();
        dbu_ReturnCCOrderApiUtil.returnOrderItemDetails(urlParam);
        dbu_ReturnCCOrderApiUtil.callReturnOrderAPI(createOrder.Id,listOrderItemIds);
        dbu_ReturnCCOrderApiUtil.checkingGenuineProduct(createOrder.Id);
        dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(createOrder.Id,listOrderItemIds,'submit');
        dbu_ReturnCCOrderApiUtil.partialReturnOrder(orderData,'Testing Returns','$223.22',createOrder.Id,'EN');
    }
    public static testMethod void callReturnOrderAPITest1(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        //createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Has_Core_Charge__c=True;
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr1.ccrz__Country__c='US';
        createContactAddr1.ccrz__PostalCode__c='10022';
        insert createContactAddr1;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr1.Id;
        insert createCart;
        
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        //createContactAddr.ccrz__Country__c='CA';
        //createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.Id,createContactAddr.id);
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__ShipAmount__c=5.0;
        createOrder.ccrz__TaxAmount__c=1.0;
        createOrder.ccrz__ShipMethod__c='Ship To Address';
        createOrder.ccrz__PaymentMethod__c='PayPal';//Added code with labels to replace special characters
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__Price__c=0.00;
        createOrderItem.ccrz__AbsoluteDiscount__c=10.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.dbu_Return_Amount__c=20.22;
        createOrderItem.dbu_Return_Tax__c=3.12;
        insert createOrderItem;
        List<Object> orderData = new List<Object>();
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_Return_Amount__c=20.22;
        orderItemObj.dbu_Return_Tax__c=3.12;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        
        insert orderItemObj;
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Return Initiated';
        orderItemObj1.ccrz__Order__c = createOrder.Id;
        orderItemObj1.ccrz__Product__c = createProduct.Id;
        orderItemObj1.dbu_Selected_Return_Items__c = True;
        orderItemObj1.dbu_Return_Amount__c=20.22;
        orderItemObj1.dbu_Return_Tax__c=3.12;
        insert orderItemObj1;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(orderItemObj.id);
        String urlParam ='https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/OderItems?orderid='+createOrder.Id;
        dbu_ReturnCCOrderApiUtil.returnOrderItemDetails(urlParam);
        dbu_ReturnCCOrderApiUtil.callReturnOrderAPI(createOrder.Id,listOrderItemIds);
        dbu_ReturnCCOrderApiUtil.checkingGenuineProduct(createOrder.Id);
        dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(createOrder.Id,listOrderItemIds,'submit');
    }
    public static CC_Tax__c createTax(String orderItemId){
        CC_Tax__c tax = new CC_Tax__c();
        tax.dbu_Is_Shipping_Tax__c = false;
        //tax.JurisdictionId__c = 
        tax.JurisdictionValue__c = '2398';
        tax.Situs__c = 'DESTINATION';
        tax.Taxable__c = '348.0';
        tax.ImpositionTypeId__c = '1';
        tax.EffectiveRate__c = '0.06';
        tax.ImpositionId__c = '1';
        tax.ImpositionTypevalue__c = 'General Sales and Use Tax';
        tax.JurisdictionLevel__c = 'STATE';
        tax.TaxCollectedFromParty__c = 'BUYER';
        tax.TaxResult__c = 'TAXABLE';
        tax.TaxType__c = 'SELLER_USE';
        tax.ImpositionValue__c = 'Sales and Use Tax';
        tax.CalculatedTax__c = '20.88';
        tax.CC_Order_Item__c = orderItemId;
        //tax.CC_Order_Item__r.ccrz__OrderItemId__c 
        return tax;
        
    }
}//Prod deployment 23-09-2022