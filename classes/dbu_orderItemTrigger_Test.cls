@isTest
public class dbu_orderItemTrigger_Test {
     @testSetup static void setup()
    {
         Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        ccrz__E_Product__c prodObj = new ccrz__E_Product__c();
        prodObj.Name = 'Test DBU 3684450PUMP,WATER';
        prodObj.ccrz__SKU__c = '1234567';
        prodObj.ccrz__Quantityperunit__c = 1.00;
        prodObj.ccrz__ProductType__c = 'Product';
        prodObj.ccrz__UnitOfMeasure__c = 'Each';
        prodObj.ccrz__ProductIndexStatus__c = 'Not Current';
        prodObj.ccrz__Storefront__c = 'CSSNAStore';
        prodObj.ccrz__ProductStatus__c = 'Released';
        prodObj.Group_Name__c = 'Ecom';
        prodObj.dbu_Product_Status__c = 'In Stock';
        prodObj.ccrz__InventoryType__c = 'STANDARD';
        prodObj.dbu_Part_Number__c = '1234567';
        insert prodObj;
        
        ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
        cartObj.ccrz__Name__c = 'My Cart';
        cartObj.ccrz__CartType__c = 'Cart';
        cartObj.ccrz__CurrencyISOCode__c = 'USD';
        cartObj.ccrz__ShipMethod__c = 'Ship to address';
        cartObj.ccrz__Storefront__c = 'CSSNAStore';
        cartObj.ccrz__CartStatus__c = 'Closed';
        cartObj.ccrz__BuyerFirstName__c = 'Mukesh';
        cartObj.ccrz__BuyerLastName__c = 'Gupta';
        cartObj.ccrz__BuyerEmail__c = 'test@test.com';
        cartObj.ccrz__BuyerPhone__c = '9999911111';
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = new ccrz__E_CartItem__c();
        cartItemObj.ccrz__Price__c = 10.00;
        cartItemObj.ccrz__Quantity__c = 5;
        cartItemObj.ccrz__SubAmount__c = 50.00;
        cartItemObj.ccrz__cartItemType__c = 'Major';
        cartItemObj.ccrz__StoreID__c = 'CSSNAStore';
        cartItemObj.ccrz__ProductType__c = 'Product';
        cartItemObj.ccrz__Product__c = prodObj.Id;
        cartItemObj.ccrz__Cart__c = cartObj.Id;
        insert cartItemObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Mukesh';
        contactObj.LastName = 'Gupta';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'mukesh@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;

        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Order Submitted';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'Mukesh';
        orderObj.ccrz__BuyerLastName__c = 'Gupta';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '9999911111';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.dbu_Is_Cloned__c=TRUE;
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Approved';
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = prodObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj.dbu_isShipTo__c = true;
        insert orderItemObj;
        
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Order Submitted';
        orderItemObj1.ccrz__Order__c = orderObj.Id;
        orderItemObj1.ccrz__Product__c = prodObj.Id;
        orderItemObj1.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj1.dbu_isShipTo__c = false;
        insert orderItemObj1;
        
        ccrz__E_OrderItem__c orderItemObj2 = new ccrz__E_OrderItem__c();
        orderItemObj2.ccrz__Price__c = 10.00;
        orderItemObj2.ccrz__Quantity__c = 5;
        orderItemObj2.ccrz__SubAmount__c = 50.00;
        orderItemObj2.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj2.ccrz__OrderItemStatus__c = 'Refunded';
        orderItemObj2.ccrz__Order__c = orderObj.Id;
        orderItemObj2.ccrz__Product__c = prodObj.Id;
        orderItemObj2.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj2.dbu_isShipTo__c = false;
        insert orderItemObj2;
        
    }
    
    static testMethod void testTrigger(){
        
        ccrz__E_OrderItem__c orderitem=new ccrz__E_OrderItem__c();
        
        orderitem=[select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__OrderItemStatus__c='Order Submitted'];
        
        orderitem.ccrz__OrderItemStatus__c='Return Approved';
        update orderitem;
        
        ccrz__E_OrderItem__c orderitem1=new ccrz__E_OrderItem__c();
        
        orderitem1=[select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__OrderItemStatus__c='Refunded'];
        
        orderitem1.ccrz__OrderItemStatus__c='Return Approved';
        update orderitem1;
       
        
     
        
      
    }

}