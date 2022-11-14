/* This trigger was created by the Youreka package and is integral to it. 
Please do not delete */
trigger Youreka_Case_trigger on Case (after update){
    if(Trigger.isAfter && Trigger.isUpdate && RecursiveTriggerHandler.isYourekaCaseAfterUpdate){
        RecursiveTriggerHandler.isYourekaCaseAfterUpdate = false;
        disco.Util.updateObjectsFieldLinkAnswers(trigger.new,'Case');
    }
}