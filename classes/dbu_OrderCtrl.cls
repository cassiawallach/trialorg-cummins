public without sharing class dbu_OrderCtrl {
    
    public dbu_OrderCtrl() { }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCOrderAPIResponseWrapper> fetchLstOrderDetails(String urlParam){
        //String orderID = 'a2V1F0000030RyZUAU';
        System.debug('url>>>>>>>>>>>>>>>>>'+urlParam);
        string cartId;
        List<dbu_CCOrderAPIResponseWrapper> objCCOrderApiResponseWrapper = new List<dbu_CCOrderAPIResponseWrapper>();
        try{
            
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('cartId')){
                    cartId = params.get('cartId');
                    //cartId=cartId.substring(0,15);
                    System.debug('cartId>>>>>>>>>>>>>>>>>\t'+cartId);
                }
                
                
                List<ccrz__E_Order__c > orderlist = [select id,name,ccrz__OriginatedCart__c from ccrz__E_Order__c where ccrz__OriginatedCart__c=:cartId];
                system.debug('orderlist'+orderlist);
                if(!dbu_UserValidation.validateUser(orderlist[0].Id)){
                    return objCCOrderApiResponseWrapper;
                }
                
                if(orderlist!=null && orderlist.size()>0){
                    string fetchedOrderId = orderlist[0].Id;
                    system.debug('fetchedOrderId'+fetchedOrderId);
                    objCCOrderApiResponseWrapper = dbu_CallCCOrderApi.fetchOrderDetails(fetchedOrderId);
                    
                    
                    if(objCCOrderApiResponseWrapper != null && objCCOrderApiResponseWrapper.size() > 0)
                    {
                        List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
                        lstTP = [Select Id,ccrz__AccountNumber__c, ccrz__TransactionType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: fetchedOrderId];
                        if(lstTP.size() > 0)
                        {
                            String accountNumber = lstTP[0].ccrz__AccountNumber__c;
                            if(lstTP[0].ccrz__TransactionType__c.toUpperCase() == 'PAYPAL' && lstTP[0].ccrz__AccountNumber__c != null && lstTP[0].ccrz__AccountNumber__c != '')
                            {
                                String cardNumber= lstTP[0].ccrz__AccountNumber__c;
                                String lastDigit = cardNumber.right(4);
                                for(Integer i = 0;i<cardNumber.length()-4;i++)
                                    lastDigit = 'x'+lastDigit;
                                accountNumber = lastDigit;
                            }
                            objCCOrderApiResponseWrapper[0].paymentMethod = lstTP[0].ccrz__TransactionType__c+' '+accountNumber;
                        }
                    }
                }
                
            }
            
            system.debug('objCCOrderApiResponseWrapper'+objCCOrderApiResponseWrapper);
            
            
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCOrderApiResponseWrapper;
    }
    
    /*@AuraEnabled(cacheable=true)
public static List<dbu_CCApiOrderRelatedResponseWrapper> getAddress(String a2719000000OrOtAAK){
List<dbu_CCApiOrderRelatedResponseWrapper> listObj = dbu_callCCOrderApiRelatedAddress.getAddressList('a2719000000OrOtAAK');
return listObj;
}
@AuraEnabled(cacheable=true)
public static List<dbu_CCApiOrderShipRelatedResponseWrapper> getShippingAddress(String a2719000000OrNPAA0){
List<dbu_CCApiOrderShipRelatedResponseWrapper> listObj1 = dbu_callCCOrderApiShipAddress.getShippingAddressList('a2719000000OrNPAA0');
return listObj1;
}
@AuraEnabled(cacheable=true)
public static List<dbu_CCApiOrderItemsResponseWrapper> getProduct(String a2V19000001ANhqEAG){
List<dbu_CCApiOrderItemsResponseWrapper> listObj2 = dbu_callCCOrderApiItems.getProductList('a2V19000001ANhqEAG');
return listObj2;
}*/
}