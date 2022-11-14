/******************************************************************************************************
Name: FSL_RecommendationTrigger 
Description: Recommendation Trigger.

Version                 Date                    Author                      Summary Of Change
------------------------------------------------------------------------------------------------------- 
1.0                                             Cummins                     Trigger created          
1.0                   10/20/2020             Ravikanth             Trigger created for US-CT2-265
******************************************************************************************************/

trigger FSL_RecommendationTrigger on FSL_Recommendation__c (after insert, After Update) {
    if(trigger.isAfter && trigger.isUpdate){
        FSL_CL_RecommendationTriggerHandler.createServiceOrder(trigger.new,trigger.oldmap);
        FSL_CL_RecommendationTriggerHandler.postToChatterOnServiceOrder(Trigger.New,Trigger.oldMap);
        FSL_CL_RecommendationTriggerHandler.sendDatatoBMS(Trigger.new,Trigger.oldMap);
        FSL_CL_RecommendationTriggerHandler.updateRecordType(trigger.new,Trigger.oldMap);
        
    }
    if(trigger.isAfter && trigger.isInsert) {
        System.debug('::: After Insert Begin');
        FSL_CL_RecommendationTriggerHandler.updateRecommendationRecord(trigger.new);
        FSL_CL_RecommendationTriggerHandler.sendDatatoBMS(Trigger.new,null);
    }
    
}