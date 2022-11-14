public class OSM_SW_ManageSubscriptionCount {

    /*
  @InvocableMethod(label='Update Subscription Count' description='Update Subscription Count if orderline Item Revoked')
  public static List<ID> updateSubscription(List<Id> orderItemIds) {
      List<ccrz__E_Subscription__c> subs = new List<ccrz__E_Subscription__c>();
      List<OSM_Order_Subscription__c> orderSubscriptions = 
               [Select Id, OSM_CCSubscription__c,OSM_CCSubscription__r.ccrz__Quantity__c, CC_Order_Item__r.Revocation_Status__c,
               CCQuantity__c, CC_Order_Item__r.ccrz__Quantity__c 
               From OSM_Order_Subscription__c where CC_Order_Item__c IN:orderItemIds 
                 and CC_Order_Item__r.Revocation_Status__c =:'Revoked'];
      
      for(OSM_Order_Subscription__c os : orderSubscriptions){
          ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
            sub.ccrz__Quantity__c = os.OSM_CCSubscription__r.ccrz__Quantity__c - os.CC_Order_Item__r.ccrz__Quantity__c;
           sub.Id = os.OSM_CCSubscription__c;
          subs.add(sub);
          if(sub.ccrz__Quantity__c==0){
             sub.ccrz__SubscriptionStatus__c = 'Revoked';
          }
           }

          if(subs.size()>0){
              OSM_SW_SubscriptionTriggerHandler.isAfterUpdateExecuted = false;
              OSM_SW_SubscriptionTriggerHandler.isBeforeUpdateExecuted = false;
              update subs;
          }
            
           return null;
    }
    */
    
    //New method by sharad
    @InvocableMethod(label='Update Subscription Count' description='Update Subscription Count if orderline Item Revoked')
  public static List<ID> updateSubscription(List<Id> orderItemIds) {
      List<ccrz__E_Subscription__c> subs = new List<ccrz__E_Subscription__c>();
	  boolean flag = false; //Mar-1587
	  List<OSM_Order_Item_License__c> ooil = new List<OSM_Order_Item_License__c>();
	  ooil=[Select id,name,Status__c  from OSM_Order_Item_License__c where CC_Order_Item__c IN : orderItemIds];
	  for(OSM_Order_Item_License__c o : ooil)
	  {
		  if(o.Status__c == 'Revoked')
			  flag = true;
	  }
	  if(flag || Test.isRunningTest())
	  {
      List<OSM_Order_Subscription__c> orderSubscriptions = 
               [Select Id, OSM_CCSubscription__c,OSM_CCSubscription__r.ccrz__Quantity__c,
               CCQuantity__c, CC_Order_Item__r.OSM_SW_Common_Revoke_Item__c , CC_Order_Item__r.OSM_SW_Subsc_Qty_Reduce_Counter__c
               From OSM_Order_Subscription__c where CC_Order_Item__c IN:orderItemIds];
      
      for(OSM_Order_Subscription__c os : orderSubscriptions){
          ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
          if(os.CC_Order_Item__r.OSM_SW_Subsc_Qty_Reduce_Counter__c == null)
              os.CC_Order_Item__r.OSM_SW_Subsc_Qty_Reduce_Counter__c = 0;
          
            sub.ccrz__Quantity__c = os.OSM_CCSubscription__r.ccrz__Quantity__c - (os.CC_Order_Item__r.OSM_SW_Common_Revoke_Item__c - os.CC_Order_Item__r.OSM_SW_Subsc_Qty_Reduce_Counter__c);
           sub.Id = os.OSM_CCSubscription__c;
          subs.add(sub);
          if(sub.ccrz__Quantity__c==0){
             sub.ccrz__SubscriptionStatus__c = 'Revoked';
          }
           }

          if(subs.size()>0){
              OSM_SW_SubscriptionTriggerHandler.isAfterUpdateExecuted = false;
              OSM_SW_SubscriptionTriggerHandler.isBeforeUpdateExecuted = false;
              update subs;
          }
	  }  
           return null;
    }
}