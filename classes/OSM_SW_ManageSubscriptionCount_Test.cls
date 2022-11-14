//Adding this class for Mar-1587
@isTest
public class OSM_SW_ManageSubscriptionCount_Test {

    @testSetup static void testData() {

        ccrz__E_Order__c order = new ccrz__E_Order__c();
        insert order;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c       = order.id;
        orderItem.Revocation_Status__c = 'Revoked';
        orderItem.ccrz__Quantity__c    = 55;
        orderItem.ccrz__Price__c       = 500;
        orderItem.ccrz__SubAmount__c   = 250;
        insert orderItem;

        ccrz__E_Subscription__c  subscription       = new ccrz__E_Subscription__c();
        subscription.ccrz__Quantity__c              = 55;
        subscription.ccrz__Sequence__c              = 1;
        subscription.ccrz__SubscriptionStartDate__c = System.now();
        subscription.ccrz__SubscriptionStatus__c    = 'test';
        subscription.ccrz__Storefront__c            = 'testStoreFront';
        insert subscription;
        
        OSM_Order_Subscription__c orderSub = new OSM_Order_Subscription__c();
        orderSub.OSM_CCSubscription__c     = subscription.id;
        orderSub.CCQuantity__c             = 55;
        orderSub.OSM_CCOrder__c            = order.id;
        orderSub.CC_Order_Item__c          = orderItem.id;
        orderSub.Billing_Frequency__c      = 'Monthly';
        insert orderSub;
    }

    @isTest static void testMethod1() {
        
        List<Id> lstorderItemId = new List<Id>();
        for(ccrz__E_OrderItem__c objOI : [SELECT Id,OSM_SW_Subsc_Qty_Reduce_Counter__c FROM ccrz__E_OrderItem__c]){
            lstorderItemId.add(objOI.Id);
        }
        
        OSM_SW_ManageSubscriptionCount.updateSubscription(lstorderItemId);
        
    }
}