global class dbu_mostPopularPartsBatch implements Database.Batchable<AggregateResult>
{
      // The batch job starts
      global Iterable<AggregateResult> start(Database.BatchableContext bc)
      {
        //String query = 'select ccrz__Product__c,Sum(ccrz__Quantity__c) FROM ccrz__E_OrderItem__c WHERE ccrz__Product__c  != NULL GROUP BY ccrz__Product__c Limit 10';
        String query = 'select ccrz__Product__c,Sum(ccrz__Quantity__c) FROM ccrz__E_OrderItem__c WHERE  ccrz__Product__r.dbu_Has_Core_Child__c = false AND Group_Name__c = \'Ecom\' AND CreatedDate = LAST_N_DAYS:7 AND ccrz__Product__c  != NULL GROUP BY ccrz__Product__c order by Sum(ccrz__Quantity__c)  DESC Limit 10';
          return new AggregateResultIterable(query);
      }
      // The batch job executes and operates on one batch of records
      global void execute(Database.BatchableContext bc, List<sObject> scope)
      { 
          Set<Id> setProductId = new Set<Id>();
          List<ccrz__E_Product__c> lstProduct = new List<ccrz__E_Product__c>();
          List<ccrz__E_Product__c> lstMostPopularPartsProductValue = new List<ccrz__E_Product__c>();
          
          for(sObject sObj : scope) 
          {
              AggregateResult ar = (AggregateResult)sObj;
              setProductId.add((Id)ar.get('ccrz__Product__c'));
              //System.debug('>>>> COUNT : ' + ar.get('quan'));
              //System.debug('>>>> AccountId : ' + ar.get('AccountId'));  
          }
          System.debug('>>>> setProductId.size() : ' + setProductId.size());
          System.debug('>>>> setProductId : ' + setProductId);
          
          lstProduct = [SELECT Id,dbu_mostPopularParts__c FROM ccrz__E_Product__c WHERE Id IN : setProductId];
          System.debug('lstProduct.size()+++ ' + lstProduct.size());
          System.debug('lstProduct+++ ' + lstProduct);
          
          for(ccrz__E_Product__c eachProductValue : lstProduct)
          {
              If(eachProductValue.dbu_mostPopularParts__c != true)
              {
                  eachProductValue.dbu_mostPopularParts__c = true;
                  lstMostPopularPartsProductValue.add(eachProductValue);
              }
          }
          System.debug('lstMostPopularPartsProductValue.size()+++ ' + lstMostPopularPartsProductValue.size());
          System.debug('lstMostPopularPartsProductValue+++ ' + lstMostPopularPartsProductValue);
          update lstMostPopularPartsProductValue; 
      }
      // The batch job finishes
      global void finish(Database.BatchableContext bc){ }
}









    /*
    String query;
    global Iterable<AggregateResult> start(Database.BatchableContext bc)
    { 
        query = 'select ccrz__Product__c,Sum(ccrz__Quantity__c) FROM ccrz__E_OrderItem__c WHERE ccrz__Product__c  != NULL GROUP BY ccrz__Product__c';
        System.debug('query' +query);
        return new AggregateResultIterable(query);
    }
 
    global void execute(Database.BatchableContext bc, List<ccrz__E_OrderItem__c> orderItem)
    {
        System.debug('orderItem+++ ' + orderItem);
        Set<ID> setProductId = new Set<ID>();
        List<ccrz__E_Product__c> lstProduct = new List<ccrz__E_Product__c>();
        List<ccrz__E_Product__c> lstMostPopularPartsProductValue = new List<ccrz__E_Product__c>();
        if(orderItem != null)
        {
            for(ccrz__E_OrderItem__c eachOrdertem : orderItem)
            {   
                setProductId.add(eachOrdertem.Id);
            }
        } 
        System.debug('setProductId+++ ' + setProductId);
        
        lstProduct = [SELECT Id,dbu_mostPopularParts__c FROM ccrz__E_Product__c WHERE Id IN : setProductId];
        
        System.debug('lstProduct+++ ' + lstProduct);
        
        for(ccrz__E_Product__c eachProductValue : lstProduct)
        {
            If(eachProductValue.dbu_mostPopularParts__c != true)
            {
                eachProductValue.dbu_mostPopularParts__c = true;
                lstMostPopularPartsProductValue.add(eachProductValue);
            }
        }
        System.debug('lstMostPopularPartsProductValue+++ ' + lstMostPopularPartsProductValue);
        update lstMostPopularPartsProductValue; 
    }
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
    }
*/