/**********************************************************************
Name:  OSM_SW_SalesRepInActiveTriggerhandler
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to serve as a handler class to  OSM_SW_SalesRepInActiveTrigger                              
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                                
 1.0 -    Adarsh Pidaparthy           4/19/2018     INITIAL DEVELOPMENT           


*****************************************************/
public class OSM_SW_SalesRepInActiveTriggerhandler {

 /*----------------------------------------------------------------------------------
1. onAfterInsert
Description:works on after Insertion of CC Orde rItems
Param: Orderitemlist
Output: 
------------------------------------------------------------------------------------*/ 
       
    public static void onAfterInsert(list<ccrz__E_OrderItem__c>Orderitemlist){
        set<Id> orderitemIdSet = new set<Id>();
        for(ccrz__E_OrderItem__c oirec : Orderitemlist){
          orderitemIdSet.add(oirec.id);
        }  
        //System.debug('****No. of orderitems received: ' + orderitemIdSet);
        if(!Test.isRunningTest())
       OSM_SW_SalesRepInActiveTriggerhandler.quoteUpdate(orderitemIdSet);
    }

  /*----------------------------------------------------------------------------------
1. quoteUpdate
Description:works as helper method for onAfterInsert method
Param: OrderitemId Set
Output: 
------------------------------------------------------------------------------------*/    
   
    public static void quoteUpdate(set<Id>OrderitemId){
        
          List<ccrz__E_OrderItem__c> OirecordsToProcessList = [select Id,name,Contact__c,ccrz__Product__c from ccrz__E_OrderItem__c where Id IN : OrderitemId];
         set<Id> contactIDS =new Set<Id>();
          set<Id> productIDS  =new Set<Id>();     
        
          for(ccrz__E_OrderItem__c oi : OirecordsToProcessList){
              contactIDS.add(oi.Contact__c);
              productIDS.add(oi.ccrz__Product__c);
                       
          }//end for
        
        System.debug('****contactIDS: ' + contactIDS);
        System.debug('****productIDS: ' + productIDS);
        System.debug('****OirecordsToProcessList: ' + OirecordsToProcessList);

        
        List<ccrz__E_RequestForQuote__c> specificquoteList = [Select ID,CC_Product__r.id,CC_Product__r.name,ccrz__Contact__r.name,ccrz__Contact__r.id from ccrz__E_RequestForQuote__c where 
                                                      (Status__c ='Requested' or Status__c ='In Progress' or Status__c ='Sent' )
                                                       and ccrz__Contact__r.id in :contactIDS and CC_Product__r.id in :productIDS];
        System.debug('****specificquoteList: ' + specificquoteList);
        
        List<ccrz__E_RequestForQuote__c> QuotesToUpdateList = new List<ccrz__E_RequestForQuote__c>();
      
        for(ccrz__E_OrderItem__c oirecord : OirecordsToProcessList){
            if(specificquoteList.size() >0 && specificquoteList != null){
                   for(ccrz__E_RequestForQuote__c quoterecord : specificquoteList){
                      //system.debug('COntact name: ' +oirecord.contact__c +quoterecord.ccrz__Contact__r.id);
                      // system.debug('Product name: ' +oirecord.ccrz__Product__c +quoterecord.CC_Product__r.id);
                         if(oirecord.contact__c == quoterecord.ccrz__Contact__r.id && oirecord.ccrz__Product__c == quoterecord.CC_Product__r.id){
                                quoterecord.Status__c = 'InActive';
                                quoterecord.Operation__c = 'InActive';
                                quoterecord.Discounted_Percentage__c = quoterecord.Discounted_Percentage__c!=null?quoterecord.Discounted_Percentage__c:null;
                                quoterecord.Discounted_Price__c = quoterecord.Discounted_Price__c!=null?quoterecord.Discounted_Price__c: null;
                                quoterecord.CCOrderItem__c = oirecord.id; 
                                QuotesToUpdateList.add(quoterecord);
                         }                          
                   }                       
                   System.debug('****QuotesToUpdateList: ' + QuotesToUpdateList);
            }
        }
        if(!Test.isRunningTest() && QuotesToUpdateList.size()>0){
            update QuotesToUpdateList; 
        }
      } 
}