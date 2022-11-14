public class dbu_myOrders {

    /**
* Author : Mounika V
* Created on 22nd September 2020
* Description : This class will do all the order related search operation
*/
    public dbu_myOrders() {}
     public class dbu_MyOrderWrapper{
public dbu_MyOrderWrapper(){}

@AuraEnabled public string orderDate;
@AuraEnabled public ccrz__E_Order__c orderRecord;
}



    @AuraEnabled(cacheable=true)
    // To fetch the list of order when clicked on the Tab - My Orders
    public static list<dbu_MyOrderWrapper> fetchOrders(){
        
        list<ccrz__E_Order__c> getOrders = new list<ccrz__E_Order__c>();
        list<dbu_MyOrderWrapper> wrapperList = new list<dbu_MyOrderWrapper>();
        
        Id loggedUserId = UserInfo.getUserId();
        if(loggedUserId != NULL){
        getOrders = [select Id,ccrz__CurrencyISOCode__c,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c,dbu_Is_Cloned__c  from ccrz__E_Order__c WHERE ccrz__User__c =:loggedUserId  AND dbu_Is_Cloned__c = false ORDER BY Name DESC];
        }
        System.debug('OrderList===================>'+getOrders);
        if(getOrders.size() > 0){
        for(ccrz__E_Order__c orderObj : getOrders){
        dbu_MyOrderWrapper wrapperObj = new dbu_MyOrderWrapper();
        wrapperObj.orderRecord = orderObj;
         Date dt = orderObj.ccrz__OrderDate__c;
        wrapperObj.orderDate = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMMM dd, yyyy');
        wrapperList.add(wrapperObj);
        }
        }
        return wrapperList;
    } 
    
// To fetch the Details of each order
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCOrderAPIResponseWrapper> fetchOrderDetail(String orderId){
        List<dbu_CCOrderAPIResponseWrapper> ccOrderWrapLst = new List<dbu_CCOrderAPIResponseWrapper>();
        if(orderId != ''){
            ccOrderWrapLst =  dbu_CallCCOrderApi.fetchOrderDetailsOnClick(orderId);
        }
        return ccOrderWrapLst;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<ccrz__E_OrderItem__c> fetchOrderItemsBasedonInput(string searchval){
        string searchinput ='%'+searchval+'%';
        list<ccrz__E_OrderItem__c > orderitem= [select id,name ,ccrz__Order__r.name,ccrz__Product__r.name from ccrz__E_OrderItem__c where ccrz__Product__r.name like :searchinput];
        
        return orderitem;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<dbu_MyOrderWrapper > orderFilter(string orderSearchText,string orderStatus,string orderTimeInterval){
        System.debug('orderStatus: '+orderStatus);
        list<ccrz__E_Order__c> order = new list<ccrz__E_Order__c>();
        list<dbu_MyOrderWrapper> wrapperList = new list<dbu_MyOrderWrapper>();
        Map<String, ccrz__E_Order__c> orderFileterdByProductName = new Map<String,ccrz__E_Order__c>();
        
        string neworderSearchText;
        if(String.isNotBlank(orderSearchText)){
            neworderSearchText ='%'+orderSearchText+'%';
        }
        Id loggedUserId = UserInfo.getUserId();
        date myDate =date.today();
        date newDate = mydate.addMonths(-integer.valueof(orderTimeInterval));
        System.debug('neworderSearchText====>'+neworderSearchText);
        System.debug('newDate====>'+newDate);
        if(newDate < date.today()){
            System.debug('newDate < date.today()\t');
        }else if(newDate > date.today()){
            System.debug('newDate > date.today()\t');
        }
        if (orderstatus=='allorderstatus' && String.isBlank(neworderSearchText)){
            order= [select Id,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c from ccrz__E_Order__c where
                    (ccrz__OrderDate__c>:newDate) AND ccrz__User__c =:loggedUserId ];
        }
        else if(orderstatus=='allorderstatus' && String.isNotBlank(neworderSearchText)){
            list<ccrz__E_OrderItem__c > orderitem= [select id,name ,ccrz__Order__c,ccrz__Product__r.name from ccrz__E_OrderItem__c where ccrz__Product__r.name like :neworderSearchText];
            Set<String> orderIds = new Set<String>();
            for(ccrz__E_OrderItem__c obj : orderitem){
                orderIds.add(obj.ccrz__Order__c);
            }
            order = [select Id,ccrz__CurrencyISOCode__c,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c,(select id,name ,ccrz__Order__c,ccrz__Product__r.name from ccrz__E_OrderItems__r where ccrz__Product__r.name like :neworderSearchText )  from ccrz__E_Order__c where
                     (name like :neworderSearchText OR Id =:orderSearchText OR id IN : orderIds) AND (ccrz__OrderDate__c>:newDate)
                     AND ccrz__User__c =:loggedUserId];
        }else if(orderstatus != 'allorderstatus' && String.isBlank(neworderSearchText)){
            order= [select Id,ccrz__CurrencyISOCode__c,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c from ccrz__E_Order__c where
                    ccrz__OrderStatus__c =: orderstatus AND ccrz__OrderDate__c>:newDate
                    AND ccrz__User__c =:loggedUserId ];
        }else if(orderstatus != 'allorderstatus' && String.isBlank(neworderSearchText)){
            order= [select Id,ccrz__CurrencyISOCode__c,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c from ccrz__E_Order__c where
                    (ccrz__OrderDate__c>:newDate
                     AND ccrz__OrderStatus__c =: orderstatus) AND ccrz__User__c =:loggedUserId];
        }
        
        if(order.size() > 0){
            for(ccrz__E_Order__c orderObj : order){
                dbu_MyOrderWrapper wrapperObj = new dbu_MyOrderWrapper();
                wrapperObj.orderRecord = orderObj;
                Date dt = orderObj.ccrz__OrderDate__c;
                wrapperObj.orderDate = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMMM dd, yyyy');
                wrapperList.add(wrapperObj);
            }
        }
        
        //order= [select Id,name,ccrz__OrderDate__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,ccrz__User__c from ccrz__E_Order__c WHERE ccrz__User__c =:loggedUserId];
        return wrapperList;
    }
    
}