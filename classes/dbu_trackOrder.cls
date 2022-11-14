public without sharing class dbu_trackOrder {
    /**
* Author : Mounika V
* Created on 7th September 2020
* Description : This class will do all the order related search operation
*/
    public dbu_trackOrder() {}
     
// This method is to pass the Ordername and Email   
  	@AuraEnabled(cacheable=true)
    public static List<dbu_CCOrderAPIResponseWrapper> getOrderList(string orderName, string email) {
        system.debug('orderName=>'+orderName);
        system.debug('email=>'+email);
        List<string>orderidset = new List<string>();
        list<ccrz__E_Order__c> getorderList = new list<ccrz__E_Order__c>();
        List<dbu_CCOrderAPIResponseWrapper> finalresult = new List<dbu_CCOrderAPIResponseWrapper>();
        
        try{
            
            getorderList=[select id,name,ccrz__BuyerEmail__c from ccrz__E_Order__c where name=:orderName and ccrz__BuyerEmail__c=:email];
            // added by Ranadip, security
            if(!dbu_UserValidation.validateUser(getorderList[0].Id)){
                return finalresult;
            }
            // end here
            system.debug('getorderList==>'+getorderList);
                
                if(getorderList!=null && getorderList.size()>0)
            {
                for(ccrz__E_Order__c order:getorderList)
                {
                    orderidset.add(order.id);
                }
                
               // finalresult = dbu_OrderCtrl.fetchLstOrderDetails_Name(orderidset);
              //   finalresult = dbu_CallCCOrderApi.fetchOrderDetailsbyNameandEmail(orderidset);
             finalresult = dbu_CallCCOrderApi.fetchOrderDetailsOnClick(orderidset[0]);
                system.debug('finalresult'+Json.serialize(finalresult));
                
            }
        }
        catch(Exception E)
        {
            system.debug('Exception Message '+E.getMessage()+''+'getlinenumber'+e.getLinenumber());
        }
        
        return finalresult;
    }
    }