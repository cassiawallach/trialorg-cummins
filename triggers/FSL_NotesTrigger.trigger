/******************************************************************************************************
Name: FSL_NotesTrigger 
Description: Note Trigger.

Version                 Date                    Author                      Summary Of Change
------------------------------------------------------------------------------------------------------- 
1.0                                             Cummins                       Trigger created          
******************************************************************************************************/
trigger FSL_NotesTrigger on Note (before insert, before update, after insert, after update) {
    
    if(trigger.isBefore && trigger.isInsert) {
        FSL_CL_NotesTriggerHandler.BeforeInsert(Trigger.New);
    }
    
    /* if(trigger.isBefore && trigger.isUpdate) {
        FSL_CL_NotesTriggerHandler.BeforeUpdate(Trigger.New, Trigger.oldMap);
    } */
}