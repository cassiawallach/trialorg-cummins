@isTest
private class dbu_Integration_Order_Test {
   
    static testMethod void testUpdateOrderStatus(){//updated
        // deployment comment 
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
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Shipped';
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
        orderItemObj1.ccrz__OrderItemStatus__c = 'Available for Pickup';
        orderItemObj1.ccrz__Order__c = orderObj.Id;
        orderItemObj1.ccrz__Product__c = prodObj.Id;
        orderItemObj1.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj1.dbu_isShipTo__c = false;
        insert orderItemObj1;
        
       List<dbu_Integration_OrderItem_Request> orderItemReqList = new  List<dbu_Integration_OrderItem_Request>();
        dbu_Integration_OrderItem_Request orderItemReq = new dbu_Integration_OrderItem_Request();
        orderItemReq.BMSOrderItemId = '1234567';
        orderItemReq.BMSOrderItemStatus = 'Order Submitted';
        orderItemReq.Comment = 'Testing Comment';
        orderItemReqList.add(orderItemReq);
        
        List<dbu_Integration_Order_Request> orderReqList = new List<dbu_Integration_Order_Request>();
        
        dbu_Integration_Order_Request orderReq = new dbu_Integration_Order_Request();
        orderReq.BMSOrderStatus = 'Delivered';
        orderReq.BMSOrderId = orderObj.Id;
        orderReq.CCOrderId = [Select Name from ccrz__E_Order__c where id =: orderObj.Id].Name;
        System.debug('================='+orderItemReq);
        orderReq.OrderItemsStatus = orderItemReqList;
        System.debug('===orderReq.OrderItemsStatus[0]==='+orderReq.OrderItemsStatus[0]);
        orderReqList.add(orderReq);
        System.debug('Json Req--'+orderReqList);
        
        List<dbu_Integration_OrderItem_Request> orderItemReqList1 = new  List<dbu_Integration_OrderItem_Request>();
        dbu_Integration_OrderItem_Request orderItemReq1 = new dbu_Integration_OrderItem_Request();
        orderItemReq1.BMSOrderItemId = '1234567';
        orderItemReq1.BMSOrderItemStatus = 'Return Rejected';
        orderItemReq1.Comment = 'Testing Comment';
        orderItemReqList1.add(orderItemReq1);
        
        List<dbu_Integration_Order_Request> orderReqList1 = new List<dbu_Integration_Order_Request>();
        
        dbu_Integration_Order_Request orderReq1 = new dbu_Integration_Order_Request();
        orderReq1.BMSOrderStatus = 'Return Rejected';
        orderReq1.BMSOrderId = orderObj.Id;
        orderReq1.CCOrderId = [Select Name from ccrz__E_Order__c where id =: orderObj.Id].Name;
 
        orderReq1.OrderItemsStatus = orderItemReqList1;
        orderReqList1.add(orderReq1);

        
        Test.startTest();
        dbu_Integration_Order.UpdateOrderStatus(orderReqList);
        dbu_Integration_Order.UpdateOrderStatus(orderReqList1);
        Test.stopTest();
        
    }
    
    static testMethod void testUpdateOrderStatus2(){
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

        ccrz__E_Order__c obj22 = new ccrz__E_Order__c();
        obj22.dbu_Is_Cloned__c = true;
        obj22.ccrz__PaymentMethod__c = 'PayPal';
        obj22.ccrz__Contact__c = contactObj.Id;
        //obj = createOrder.clone(false,false,false,false);
        insert obj22;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'invoiced';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'Mukesh';
        orderObj.ccrz__BuyerLastName__c = 'Gupta';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '9999911111';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.CC_Order__c  = obj22.Id;
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'invoiced';
        orderItemObj.ccrz__Order__c = obj22.Id;
        orderItemObj.ccrz__Product__c = prodObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj.dbu_isShipTo__c = true;
        insert orderItemObj;
        
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Open';
        orderItemObj1.ccrz__Order__c = orderObj.Id;
        orderItemObj1.ccrz__Product__c = prodObj.Id;
        orderItemObj1.dbu_CC_Order_Item__c = orderItemObj.Id;
        orderItemObj1.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj1.dbu_isShipTo__c = false;
        insert orderItemObj1;
        
        
        ccrz__E_Order__c ordeObj1 = new ccrz__E_Order__c();
        ordeObj1 = [Select id ,ccrz__OrderNumber__c from ccrz__E_Order__c where id=:orderObj.Id ];
        
        System.debug(ordeObj1);
        dbu_Integration_Order_Request objReq = new dbu_Integration_Order_Request();
        objReq.CCOrderId = [Select Name from ccrz__E_Order__c where id =: ordeObj1.Id].Name;
        objReq.BMSOrderStatus = 'Return Rejected';
        objReq.OrderItemsStatus = new List<dbu_Integration_OrderItem_Request>();

        dbu_Integration_OrderItem_Request obj = new dbu_Integration_OrderItem_Request();
        obj.BMSOrderItemId = '1234567';
        obj.BMSOrderItemStatus = 'Return Rejected';
        obj.Comment = 'Return Rejected';
        objReq.OrderItemsStatus.add(obj);
        System.debug(objReq);
        



        List<dbu_Integration_Order_Request> ttt = new List<dbu_Integration_Order_Request>();
        ttt.add(objReq);
        
        

        
        Test.startTest();
        dbu_Integration_Order.UpdateOrderStatus(ttt);
        List<Id> lstId = new List<Id>();
        lstId.add(orderItemObj.Id);
        dbu_Integration_Order.sendMail(lstId);
        Test.stopTest();
        
    }
    
    static testMethod void testUpdateOrderStatus3(){
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

        ccrz__E_Order__c obj22 = new ccrz__E_Order__c();
        obj22.dbu_Is_Cloned__c = true;
        obj22.ccrz__PaymentMethod__c = 'PayPal';
        obj22.ccrz__Contact__c = contactObj.Id;
        //obj = createOrder.clone(false,false,false,false);
        insert obj22;
        
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
        orderObj.CC_Order__c  = obj22.Id;
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Order Submitted';
        orderItemObj.ccrz__Order__c = obj22.Id;
        orderItemObj.ccrz__Product__c = prodObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj.dbu_isShipTo__c = true;
        insert orderItemObj;
        
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Return Rejected';
        orderItemObj1.ccrz__Order__c = orderObj.Id;
        orderItemObj1.ccrz__Product__c = prodObj.Id;
        orderItemObj1.dbu_CC_Order_Item__c = orderItemObj.Id;
        orderItemObj1.ccrz__OrderItemId__c = cartItemObj.Id;
        orderItemObj1.dbu_isShipTo__c = false;
        insert orderItemObj1;
        
        
        ccrz__E_Order__c ordeObj1 = new ccrz__E_Order__c();
        ordeObj1 = [Select id ,ccrz__OrderNumber__c from ccrz__E_Order__c where id=:orderObj.Id ];
        
        System.debug(ordeObj1);
        dbu_Integration_Order_Request objReq = new dbu_Integration_Order_Request();
        objReq.CCOrderId = [Select Name from ccrz__E_Order__c where id =: ordeObj1.Id].Name;
        objReq.BMSOrderStatus = 'invoiced';
        objReq.OrderItemsStatus = new List<dbu_Integration_OrderItem_Request>();

        dbu_Integration_OrderItem_Request obj = new dbu_Integration_OrderItem_Request();
        obj.BMSOrderItemId = '1234567';
        obj.BMSOrderItemStatus = 'invoiced';
        obj.Comment = 'Return Rejected';
        objReq.OrderItemsStatus.add(obj);
        System.debug(objReq);
        



        List<dbu_Integration_Order_Request> ttt = new List<dbu_Integration_Order_Request>();
        ttt.add(objReq);
        
        

        
        Test.startTest();
        dbu_Integration_Order.UpdateOrderStatus(ttt);
        List<Id> lstId = new List<Id>();
        lstId.add(orderItemObj.Id);
        dbu_Integration_Order.sendMail(lstId);
        Test.stopTest();
        
    }


}