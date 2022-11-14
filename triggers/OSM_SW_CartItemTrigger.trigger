/**
 *      @author             Vineet 
 *      @date               17/05/2018
 *      @description        Trigger on the CartItem object

        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet Srivastava               17/05/2018          Initial development
        

 */

trigger OSM_SW_CartItemTrigger on ccrz__E_CartItem__c (before update, before insert, after update, after insert, after delete) {
    // filter for not CSSNAStore cart item
    List<ccrz__E_CartItem__c> listNewTriggerRecord = new List<ccrz__E_CartItem__c>();
    List<ccrz__E_CartItem__c> listoldTriggerRecord = new List<ccrz__E_CartItem__c>();
    Map<Id,ccrz__E_CartItem__c> mapoldTriggerRecord = new Map<Id,ccrz__E_CartItem__c>();
    if((Trigger.isInsert && Trigger.isAfter) || (Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {
    for(ccrz__E_CartItem__c newRecords : Trigger.new)
    {
        if(newRecords.ccrz__StoreId__c != 'CSSNAStore')
            listNewTriggerRecord.add(newRecords);
    }
    }
    
    if(trigger.isDelete && trigger.isAfter){
    for(ccrz__E_CartItem__c oldRecords : Trigger.old)
    {
        if(oldRecords.ccrz__StoreId__c != 'CSSNAStore')
            listoldTriggerRecord.add(oldRecords);
    }
    }
    if((Trigger.isUpdate && Trigger.isBefore) || (Trigger.isDelete && Trigger.isAfter))
    {
    for(Id objId : Trigger.oldMap.keySet())
    {
        mapoldTriggerRecord.put(objId,Trigger.oldMap.get(objId));
    }
    }
    
    
    
    
   if(Trigger.isInsert && Trigger.isAfter)
    {
        OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItem(listNewTriggerRecord);
        OSM_SW_CartLineTriggerHelper.updatedAddOnFieldOnCartLineItemBefore(listNewTriggerRecord);
    }
       if(trigger.isDelete && trigger.isAfter){
           {
               OSM_SW_CartLineTriggerHelper.deleteAddonProduct(listoldTriggerRecord);
           }
           
       }
      if(Trigger.isInsert && Trigger.isBefore)
    {
        OSM_SW_CartLineTriggerHelper.removeoldPowerGeneratorProduct(listNewTriggerRecord);
        OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItemBefore(listNewTriggerRecord);
        
    }
   
   if(Trigger.isUpdate && Trigger.isBefore)
    {
        try{
        for(ccrz__E_CartItem__c newCartItem : listNewTriggerRecord){
            //ccrz.ccLogicCartAddTo.setSubAmount(true);
            //ccrz.ccApiCart.ISREPRICE = 'TRUE';
                 ccrz__E_CartItem__c oldCartItem = mapoldTriggerRecord.get(newCartItem.Id);
                 if(newCartItem.ccrz__PricingType__c == 'external'){
                         newCartItem.ccrz__OriginalQuantity__c = newCartItem.ccrz__Quantity__c;
                         system.debug('inside If=='+newCartItem.ccrz__OriginalQuantity__c);
                 }
                
             }
             }catch(exception ex){system.debug(ex);}
    }
       
   if(Trigger.isDelete && Trigger.isAfter)
    {
        system.debug('After Cart Item Delete is called');
        OSM_SW_CartLineTriggerHelper.updateRemoveAccountPreferredBillFre(mapoldTriggerRecord);
    }    
    }