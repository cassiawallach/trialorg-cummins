/******************************************************************************************************
Name : EVL_RestrictDeletionOnClosedSOTrigger 
Description : Built as part of CT1-93
Description2 : using this trigger to put restriction on delete when closed service order 

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   02/18/2021               Sai Pisupati                         Trigger created
*********************************************************************************************************/
trigger EVL_RestrictDeletionOnClosedSOTrigger on ContentDocument (before delete) {
    
    if(trigger.isBefore && trigger.IsDelete) {
        EVL_RestrictDelOnSOContentTriggerHandler.restricContentOnClosedSOBeforeDelete(Trigger.old);
    }
}