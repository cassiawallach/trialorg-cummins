trigger FSL_smnTrigger on FSL_Failure__c (before insert, before update) {
    
    FSL_SMNTriggerHandler handler = new FSL_SMNTriggerHandler();   

    if(Trigger.isInsert && Trigger.isBefore){
        handler.BeforeInsert(Trigger.new);
    }
   
    if(Trigger.isUpdate && Trigger.isBefore){
       handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap); 
    }     

   /* if(Trigger.isInsert && Trigger.isAfter){
       // handler.AfterInsert(Trigger.new, Trigger.newMap);
    }*
    
     if(Trigger.isUpdate && Trigger.isAfter){
        handler.AfterUpdate() Trigger.newMap, Trigger.oldMap); 
    }*/
    
}