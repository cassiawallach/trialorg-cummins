@isTest
public class dbu_TaxSummaryCtrl_Test {
    @isTest public static void getOderTax (){
        
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        insert productObj;
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.CC_Order__c = null;
        //orderObj.ccrz__Contact__c = contactObj.Id;
       // orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Shipped';
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_Is_Returned__c = false;
        orderItemObj.dbu_Reason_for_Return__c = 'Incorrect part was received'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        insert orderItemObj;
        
        CC_Tax__c taxObj = new CC_Tax__c();
        taxObj.ImpositionValue__c = 'GST';
        taxObj.CalculatedTax__c = '5.0';
        taxObj.EffectiveRate__c = '0.13';//INC3004994
        taxObj.CC_Order_Item__c  = orderItemObj.id;
        insert taxObj; 

        Test.startTest();
        dbu_TaxSummaryCtrl.getOderTax(orderObj.Id);
        Test.stopTest();
        
    }
}
//UAT Deployments