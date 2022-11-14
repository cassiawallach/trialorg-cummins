trigger FSL_AbsenceResuorceTrigger on ResourceAbsence (before insert,before delete) {
    
    private static Boolean avoidMultipleBeforeInsert=false;
    private static Boolean avoidMultipleAfterInsert=false;
    private static Boolean avoidMultipleBeforeUpdate=false;
    private static Boolean avoidMultipleAfterUpdate=false;
    if(Trigger.isBefore && Trigger.isInsert){
        FSL_AbsenceResuorceTriggerHandler.beforeInsert(Trigger.New);
    }
       if(Trigger.isbefore && Trigger.isDelete){ //Added by ravi for CT2-201
        FSL_AbsenceResuorceTriggerHandler.afterresourceDelete(Trigger.oldmap);
    }
}