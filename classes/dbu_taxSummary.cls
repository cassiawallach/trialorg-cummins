public without sharing class dbu_taxSummary {
    
    public string orderId {get;set;}
    
    public List<TaxSummery> taxSummeryList {get;set;}
    
    public dbu_taxSummary(){
        
            taxSummeryList = new list<TaxSummery>();
        
    }
    
    public  List<TaxSummery> getOrderTax(){
        
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        Map<String,Decimal> taxMapping = new Map<String,Decimal>();
        Map<String,Decimal> taxMapping1 = new Map<String,Decimal>();
        //List<TaxSummery> taxSummeryList = new list<TaxSummery>();
        Set<String> taxTypeSet = new Set<String>();
        List<ccrz__E_Order__c> orderObj = new List<ccrz__E_Order__c>();
        String query;
        String CountryCurrency;
        
        orderObj = [SELECT ID,CC_Order__c,ccrz__CurrencyISOCode__c FROM ccrz__E_Order__c WHERE Id =: orderId];
        if(!orderObj.isEmpty()){
            CountryCurrency = orderObj[0].ccrz__CurrencyISOCode__c;
        }
        
        if(orderObj[0].CC_Order__c == Null){
            query = 'SELECT Id,dbu_CC_Order_Item__c,(SELECT ID,ImpositionValue__c,EffectiveRate__c,CalculatedTax__c,dbu_Is_Shipping_Tax__c FROM CC_Tax__r) FROM ccrz__E_OrderItem__c where dbu_Is_Returned__c = false AND ccrz__Order__c =: orderId';
        }else if(orderObj[0].CC_Order__c != Null){
            query = 'SELECT Id,dbu_CC_Order_Item__c,(SELECT ID,ImpositionValue__c,EffectiveRate__c,CalculatedTax__c,dbu_Is_Shipping_Tax__c FROM CC_Tax__r) FROM ccrz__E_OrderItem__c where ccrz__Order__c =: orderId';
        }
        orderItemList =  Database.query(query); 
        //orderItemList = [SELECT Id,ccrz__OrderItemStatus__c,(SELECT ID,ImpositionValue__c,EffectiveRate__c,CalculatedTax__c FROM CC_Tax__r) FROM ccrz__E_OrderItem__c where  ccrz__Order__c =: orderId];
        for(ccrz__E_OrderItem__c orderItem : orderItemList){
            
            for(CC_Tax__c taxObj : orderItem.CC_Tax__r){
                taxTypeSet.add(taxObj.ImpositionValue__c);
                if(taxMapping.containsKey(taxObj.ImpositionValue__c)){
                    taxMapping.put(taxObj.ImpositionValue__c,Decimal.valueOf(taxObj.CalculatedTax__c) + taxMapping.get(taxObj.ImpositionValue__c));
                    if(taxObj.dbu_Is_Shipping_Tax__c == false){
                        if(taxMapping1.containsKey(taxObj.ImpositionValue__c)) taxMapping1.put(taxObj.ImpositionValue__c, Decimal.valueOf(taxObj.EffectiveRate__c) + taxMapping1.get(taxObj.ImpositionValue__c));//INC3004994
                        else taxMapping1.put(taxObj.ImpositionValue__c, Decimal.valueOf(taxObj.EffectiveRate__c));//INC3004994
                    }
                }else{
                    if(taxObj.CalculatedTax__c == Null || taxObj.CalculatedTax__c == '0.0' || taxObj.CalculatedTax__c == '0.00' || taxObj.CalculatedTax__c == '0'){
                    }else {
                         taxMapping.put(taxObj.ImpositionValue__c,Decimal.valueOf(taxObj.CalculatedTax__c));
                         if(taxObj.dbu_Is_Shipping_Tax__c == false) taxMapping1.put(taxObj.ImpositionValue__c,Decimal.valueOf(taxObj.EffectiveRate__c));//INC3004994
                    }
                }
            }
        }
        
        for(String str : taxTypeSet){
            if(taxMapping.containsKey(str) && taxMapping1.containsKey(str)){
                    Decimal rate = (taxMapping1.get(str)/orderItemList.size())*100;//INC3004994
                	decimal taxAmnt = taxMapping.get(str);
                    TaxSummery taxSummeryObj = new TaxSummery();
                    taxSummeryObj.TaxType = str;
                    taxSummeryObj.calculatedTax = taxAmnt.setScale(2);
                    taxSummeryObj.taxPercentage = String.valueOf(rate.setScale(2));
                    taxSummeryObj.countryCurrency = CountryCurrency;
                    taxSummeryList.add(taxSummeryObj); 
            }
        }
        system.debug('taxMapping ' + taxMapping);
        system.debug('taxMapping1 ' + taxMapping1);
        system.debug('taxSummeryList ' + taxSummeryList);
        return taxSummeryList;
    }
    
    
    public class TaxSummery{
        
        public String TaxType {set;get;}
       
        public Decimal calculatedTax {set;get;}
        
        public String taxPercentage {set;get;} 
        
        public String countryCurrency {set;get;}
        
         public TaxSummery(){}
    }
}