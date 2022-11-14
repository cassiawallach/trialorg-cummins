global class dbu_UpdateExternalIdBatch implements Database.Batchable<sObject>
{
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        
         
        String query = 'Select Id,Name,dbu_ESNNumber__c, Number_Z__c, DBU_Parts_Response_ID__c from dbu_partsresponse__c where dbu_ESNNumber__c!= null and Number_Z__c!=null and DBU_Parts_Response_ID__c=null';
        system.debug('queryresult'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
     
    global void execute(Database.BatchableContext BC, List<dbu_partsresponse__c> Partresponse) 
    {
        
        List<dbu_partsresponse__c> partsToUpdate = new List<dbu_partsresponse__c>();        

        for(dbu_partsresponse__c part :Partresponse)
        {
            string partExtId = part.dbu_ESNNumber__c + '_' + part.Number_Z__c;
        
                part.DBU_Parts_Response_ID__c = partExtId;
                partsToUpdate.add(part);
                system.debug('UPDATEDVALUESinloop'+partsToUpdate);
                
            
        }
        
         Database.update(partsToUpdate, false);
         
        
        
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        
    }

}