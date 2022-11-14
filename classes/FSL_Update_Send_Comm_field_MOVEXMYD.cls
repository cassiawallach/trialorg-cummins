global class FSL_Update_Send_Comm_field_MOVEXMYD implements Database.Batchable<sObject> {
        
        List<id> lstconid= new List<id>();
        
        Public FSL_Update_Send_Comm_field_MOVEXMYD(List<id> conid){
        lstconid = conid;
        }
       
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Send_Nightly_Communication__c FROM Contact  where id IN:lstconid]); 
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> ContactRecords) {
        List<Contact> UpdatedContacts = new List<Contact>();
       
              
        for(Contact ContactRecord : ContactRecords){
            
            if(ContactRecord.Send_Nightly_Communication__c ){
                ContactRecord.Send_Nightly_Communication__c = FALSE;
                UpdatedContacts.add(ContactRecord);
            }
        }
        if(UpdatedContacts.size() > 0){
            try{
                update UpdatedContacts;
            }
            catch (exception e){
                system.debug('Exception Caused ---> '+e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
          FSL_NightlyComm_Active_MOVEXMYD Schedularbatch = new FSL_NightlyComm_Active_MOVEXMYD();
        database.executebatch(Schedularbatch);
    }
    
}