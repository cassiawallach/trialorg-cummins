public class FSL_CustomPartTriggerHandler {
    public static void handleAfterUpdate(List<FSL_Custom_Part__c> newList,Map<Id,FSL_Custom_Part__c> oldMapList){
        set<Id> customPartIds = new set<Id>();
        List<FSL_Custom_Part__c> customPartList = new List<FSL_Custom_Part__c>();
        for(FSL_Custom_Part__c custompart:newList){
            if(custompart.Quantity_Used__c != oldMapList.get(custompart.Id).Quantity_Used__c && custompart.Quantity_Edited__c == false ){
                customPartIds.add(custompart.Id);
            }
        }
        List<FSL_Custom_Part__c> editedCustompart = [SELECT Id,Quantity_Edited__c FROM FSL_Custom_Part__c WHERE Id=:customPartIds];
        for(FSL_Custom_Part__c custompart:editedCustompart){
                custompart.Quantity_Edited__c = true;
                customPartList.add(custompart);
        }
        update customPartList;
    }
}