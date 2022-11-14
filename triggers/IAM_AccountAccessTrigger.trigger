/********************************************************************************
***********************************************************************************
Trigger Name: IAM_AccountAccessTrigger
Description : This Trigger is used to update Fields on Contact Provisioning record on before insert. Also this trigger invoke LDAP call like add application group and     
              and remove application group and update user on LDAP contact when inserting/updating record and having status Active/Inactive. also it assigned/remove 
              permission set when contact provision got Acitve/Inactive. There are CST API calls also trgger.
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          ----------        INITIAL DEVELOPMENT
1.1 -    Karthik Golakaram          03/21/2021      Added changes to skip trigger execution when contact 
                                                    is getting created or getting updated from JIT partner.
**************************************************************************************
***************************************************************************************/
trigger IAM_AccountAccessTrigger on IAM_Application__c (before insert,before update,after update,After insert) {

    System.debug('Prinitng Account Access trigger context is before'+Trigger.isBefore);
    System.debug('Prinitng Account Access trigger context is After'+Trigger.isAfter);
    System.debug('Prinitng Account Access trigger context is insert'+Trigger.isInsert);
    System.debug('Prinitng Account Access trigger context is Update'+Trigger.isUpdate);
    new IAM_AccountAccessTriggerHndlrNew().run();
/* List<IAM_Trigger_Switches__mdt> triggerSwitch=[select id,IAM_Active__c,Label from IAM_Trigger_Switches__mdt where Label='IAM_Application_Access_Switch']; 
    
    Boolean fromJITNew=false;
    Boolean fromJITOld=false;
    if(Trigger.New[0].IAM_From_JIT_Execution__c){
        fromJITNew=True;
    }

   if(Trigger.isUpdate){
        if(!Trigger.old.isEmpty()){
            if(Trigger.old[0].IAM_From_JIT_Execution__c){
                fromJITOld=True;
            }
        }
   }

  if(triggerSwitch[0].IAM_Active__c&&!(fromJITNew||fromJITOld)){
      System.debug('Printing inside account access');
    if((Trigger.isInsert||Trigger.isUpdate)&&(Trigger.isBefore)){
        IAM_AccountAccessTriggerHandler.onBeforeInsertAndUpdate(trigger.new,trigger.old,trigger.oldMap,trigger.newMap,Trigger.isBefore,Trigger.isInsert);
    }
    
    if(Trigger.isUpdate &&Trigger.isAfter){
        IAM_AccountAccessTriggerHandler.onAfterUpdate(trigger.new,trigger.old,trigger.oldMap,trigger.newMap);
    }
    
    if(Trigger.isUpdate &&Trigger.isAfter){
            OSM_SW_ContactAccessRoleUpdate.updateUserProvionsed(Trigger.oldMap, Trigger.newMap);
        }
        
   
   
   if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            IAM_AccountAccessTriggerHandler.AccountUpdateFields(Trigger.new);
        }
    } 
  } */
}