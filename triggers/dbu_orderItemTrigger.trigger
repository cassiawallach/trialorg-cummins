trigger dbu_orderItemTrigger on ccrz__E_OrderItem__c (after insert, after update) {
try{
    if(!System.isFuture() )
    {
         if(!dbu_paypalPayment.isTriggerFire)
        {
            if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
            {
                //START CECI-777
                List<Id> lstIds = new List<Id>();
                Set<id> orderidset=new set<id>();
                Map<Id,Boolean> returnmap=new Map<Id,Boolean>();
                List<ccrz__E_OrderItem__c> orderitemlist=[select id,ccrz__Order__c from ccrz__E_OrderItem__c where id IN: Trigger.new];

                for(ccrz__E_OrderItem__c orderitemvar: orderitemlist)
                {
                    orderidset.add(orderitemvar.ccrz__Order__c);
                }
             
               
                List<ccrz__E_Order__c> orderlist=[select id,dbu_Is_Cloned__c from ccrz__E_Order__c where id IN: orderidset];

                for(ccrz__E_Order__c ordervar:orderlist)
                {
                    returnmap.put(ordervar.id,ordervar.dbu_Is_Cloned__c);
                }
                
                
                for(ccrz__E_OrderItem__c orderItemObj : Trigger.new)
                {  
                    if(orderItemObj.ccrz__OrderItemStatus__c == 'Return approved' && orderItemObj.ccrz__StoreId__c == 'CSSNAStore'&& Trigger.isInsert )
                    { 
                        lstIds.add(orderItemObj.Id);
                        
                    }
                    
                    if(Trigger.isUpdate)
                    {
                    ccrz__E_OrderItem__c oldorderitem = Trigger.oldMap.get(orderItemObj.ID);
                   
                    if(orderItemObj.ccrz__OrderItemStatus__c == 'Return approved' && orderItemObj.ccrz__StoreId__c == 'CSSNAStore' && oldorderitem.ccrz__OrderItemStatus__c!='Refunded'  && returnmap.get(orderItemObj.ccrz__Order__c)==true)
                    {
                        lstIds.add(orderItemObj.Id);
                    }
                    
                    else if(oldorderitem.ccrz__OrderItemStatus__c=='Refunded' && Trigger.isUpdate &&  returnmap.get(orderItemObj.ccrz__Order__c)==true)
                   
                    {
                        orderItemObj.adderror('You cannot change the status of a Refunded Order');
                    }
                    }
                    //END CECI-777
                    
                }
                
                if(lstIds.size() > 0)
                {
                    dbu_paypalPayment.getRefund(lstIds);
                }
               
            }
            dbu_paypalPayment.isTriggerFire = true;
        }
    }
}
    catch(Exception E){
        system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
    }
}