/******************************************************************************************************
Name : EVL_RestrictDeleteNoteOnClosedSOTrigger 
Description : Note object Trigger.
Description2 : using this trigger to put restriction on delete when closed service order 

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   02/18/2021               Sai Pisupati                         Trigger created
*********************************************************************************************************/
trigger EVL_RestrictDeleteNoteOnClosedSOTrigger on Note (before delete) {
    
    if(trigger.isBefore && trigger.IsDelete) {
            EVL_RestrictDelOnClSONoteTriggerHandle.restricNoteOnClosedSOBeforeDelete(Trigger.old);
    }
}