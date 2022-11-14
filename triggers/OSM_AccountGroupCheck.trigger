//missing field added in query - Subbu 2/28
// Updated Changes for Mp-733.
trigger OSM_AccountGroupCheck on Account (after insert,before update, after update) {
    // Code Refactored as part MAR-1006 by Nandigam Sasi
    try{
        if(trigger.isInsert && trigger.isAfter){
            string iamstring='IAM';
            string wwspsstring ='wwsps'; 
            set<id> accountids=trigger.newmap.keyset();
            string query='Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where(RecordType.Name=:iamstring or RecordType.Name=:wwspsstring )and id IN:accountids';
            list<account> accounts =Database.query(query);
            OSM_AutoPopulateAccount.updateAccountGroup(accounts); 
        }else if (trigger.isUpdate && trigger.isBefore){
            for(Account acc :trigger.new){
               /* if(acc.OSM_HHP_Dealer__c != trigger.oldmap.get(acc.id).OSM_HHP_Dealer__c || acc.EBU_Channel_of_Distribution__c != trigger.oldmap.get(acc.id).EBU_Channel_of_Distribution__c
                   ||acc.PSBU_Channel_of_Distribution__c != trigger.oldmap.get(acc.id).PSBU_Channel_of_Distribution__c || acc.CMI_Account_Status__c != trigger.oldmap.get(acc.id).CMI_Account_Status__c
                   || acc.Type != trigger.oldmap.get(acc.id).Type
                   || acc.OSM_Service_Level__c != trigger.oldmap.get(acc.id).OSM_Service_Level__c  // Added for Mar-1008
                   || acc.DTNA__c != trigger.oldmap.get(acc.id).DTNA__c){ // Added for Mar-1454
                       acc.OSM_Accountgroupbatch__c=true;
                   }*/
                if(trigger.oldmap.get(acc.id).ccrz__E_AccountGroup__c != acc.ccrz__E_AccountGroup__c){
                    acc.OSM_Old_Account_Group_ID__c = trigger.oldmap.get(acc.id).ccrz__E_AccountGroup__c;
                }
            } 
        }// MAR-1617 Code Start 
        else if (trigger.isUpdate && trigger.isAfter){
            List<id> updatedAccIds = new List<id>();
            for(Account acc :trigger.new){
                if(acc.DTNA__c != trigger.oldmap.get(acc.id).DTNA__c || acc.EBU_Channel_of_Distribution__c != trigger.oldmap.get(acc.id).EBU_Channel_of_Distribution__c || acc.PSBU_Channel_of_Distribution__c != trigger.oldmap.get(acc.id).PSBU_Channel_of_Distribution__c || acc.ServiceLevel__c!= trigger.oldmap.get(acc.id).ServiceLevel__c || acc.CMI_Account_Status__c != trigger.oldmap.get(acc.id).CMI_Account_Status__c 
                || acc.EngineRangeDesc__c != trigger.oldmap.get(acc.id).EngineRangeDesc__c || acc.BillingCountry != trigger.oldmap.get(acc.id).BillingCountry){ //Added BillingCountry condition as part of MP-409
                    updatedAccIds.add(acc.id);
                }
            }
            if(OSM_CheckRecursive.runOnce()){ //MP-973 added IF condtion for stopping recursive
                OSM_AccountGroupMapping_Helper.updateAccountGroup(updatedAccIds);
            }
        }// MAR-1617 Code End
    }catch(system.Exception ex){
        system.debug('Eroor-------->>>>>>'+ex.getCause());
    }
}