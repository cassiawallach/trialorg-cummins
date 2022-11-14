/**********************************************************************************
***********************************************************************************
Trigger Name: IAM_User_Trigger
Description : This Trigger is used to share records when a user with 
profile IAM_Distributor is created. 
**************************************************************************************
**************************************************************************************/

trigger IAM_User_Trigger on User (after insert,after Update) {
    
List<IAM_Trigger_Switches__mdt> triggerSwitch=[select id,IAM_Active__c,Label from IAM_Trigger_Switches__mdt where Label='IAM_User_Trigger_Switch']; 
    if(triggerSwitch[0].IAM_Active__c){
        if(Trigger.isAfter) {
                       
            if(Trigger.isInsert||Trigger.isUpdate){
                IAM_User_Trigger_Helper.userTriggerHandler(Trigger.New);
                
                if(Trigger.isInsert) {
                    IAM_Internal_User_Record_Sharing.shareAccountRecords(Trigger.new[0]);
                }
                else {
                    IAM_Internal_User_Record_Sharing.shareAccountRecordsOnUpdate(Trigger.new[0], Trigger.old[0]);
                    FSL_PortalUser_Trigger_Helper.LangContactUpdate(Trigger.oldMap, Trigger.New); //Added by Guidanz Track 4 to update Contact Language from User
                }
            }
        }
    }
}