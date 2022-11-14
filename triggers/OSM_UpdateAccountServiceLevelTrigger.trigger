trigger OSM_UpdateAccountServiceLevelTrigger on CSS_Accreditation__c (after insert, after update, before insert) 
{
    // Ravi added before insert 
    Boolean activateTrigger = true;
    
    if(activateTrigger)
    {
        // Ravi added before insert code start 08-22-2019
        if(Trigger.isBefore)
        {
            OSM_UpdateAccSerLevel_HelperDataloader.dobeforeinsertOpertions(Trigger.New);
        }
        // Ravi added before insert code end 
        if(Trigger.isAfter)
        {
            Set<ID> accountIDSet = new Set<ID>();
            
            if(Trigger.isInsert)
            {
                for(CSS_Accreditation__c accr : Trigger.New)
                {
                    accountIDSet.add(accr.Account__c);
                }
            }
            if(Trigger.isUpdate)
            {
                Map<ID, CSS_Accreditation__c> newAccreditationsMap = Trigger.NewMap;
                Map<ID, CSS_Accreditation__c> oldAccreditationsMap = Trigger.OldMap;
                
                for(ID accrID : newAccreditationsMap.keySet())
                {
                    CSS_Accreditation__c newAccr = newAccreditationsMap.get(accrID);
                    CSS_Accreditation__c oldAccr = oldAccreditationsMap.get(accrID);
                    
                    if((newAccr.Service_Level__c != oldAccr.Service_Level__c && null != newAccr.Account__c)
                      || (newAccr.Product_Details__c != oldAccr.Product_Details__c && null != newAccr.Account__c) )
                    {
                        accountIDSet.add(newAccr.Account__c);
                    }
                }
            }
            
            if(null != accountIDSet && accountIDSet.size() > 0)
            {
                OSM_UpdateAccountServiceLevel_Helper.updateAccountServiceLevel(accountIDSet);
            }
        }
    }
}