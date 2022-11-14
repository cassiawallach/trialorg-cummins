global class FSL_Send_Communication_Nightly_MOVEX implements Database.Batchable<sObject>, Database.Stateful{

       global List<id> allSuccessId=new List<id>();
       
       global Database.QueryLocator start(Database.BatchableContext BC){        
        
          //return Database.getQueryLocator([SELECT Id,Nightly_Communications__c,Send_Nightly_Communication__c,(select id from Nightly_Communications__r where Active__c= true) FROM Contact where Email_Notification_Frequency__c='Nightly' AND Account.FSL_Source_ERP__c='MOVEX']); 
          return Database.getQueryLocator([SELECT Id,Name,Send_Nightly_Communication__c FROM Contact where Email_Notification_Frequency__c='Nightly' AND Account.FSL_Source_ERP__c='MOVEX' and ID IN (select contact__c from FSL_Nightly_Communications__c where Active__c= true)]);                                
        }
   
       global void execute(Database.BatchableContext BC, List<Contact> scope){
       
       List<Contact> Listcon = new List<Contact>();
       
            for(Contact con : scope) {                     
                con.Send_Nightly_Communication__c= true;
                 Listcon.add(con);
            }
            database.SaveResult[] myResult=database.update(scope,false);
            for(Integer i=0; i < myResult.size(); i++) {
        
                if(myResult.get(i).isSuccess()) {
                    System.debug('Records are updated Successfully');
                    allSuccessId.add(myResult.get(i).Id);
                } 
            } 
             
        
        }
        
        global void finish(Database.BatchableContext BC){
        
        FSL_Update_Send_Comm_field_MOVEX shn = new FSL_Update_Send_Comm_field_MOVEX(allSuccessId);
            
        database.executeBatch(shn,200);
        
        }
 }