trigger dbu_priceListItemTrigger on ccrz__E_PriceListItem__c (before update, before insert) 
{
    if(trigger.isBefore)
    {
        if(trigger.isUpdate)
        {
            dbu_discountPriceUpdate.updateDiscountPrice(trigger.new, trigger.oldMap);
        }
        if(trigger.isInsert){
            dbu_discountPriceUpdate.updateDiscountPrice(trigger.new, null);
        }
    }
}