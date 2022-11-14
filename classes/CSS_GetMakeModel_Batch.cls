/*
 * Block comments with details of changes
 */

global class CSS_GetMakeModel_Batch implements Database.Batchable<sObject>,Database.allowscallouts{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT id FROM CSS_Make_Model_Access__c';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_Make_Model_Access__c> scope){
        CSS_FN_SRT.getMakeModalEquipmentIdList('2000-08-08');
    }
 
   global void finish(Database.BatchableContext BC){}

}