/*
 * Block comments with details of changes
 */
global class CSS_GetMakeModel_Schedule implements Schedulable{

      global void execute(SchedulableContext sc){ 
        //CSS_GetMakeModel_Batch insBatch = new CSS_GetMakeModel_Batch();
        //Id batchProcessId = Database.ExecuteBatch(insBatch);
        getMakeModelFromSRT();
    }
    
    
    @future(callout = true)
    static void getMakeModelFromSRT(){
        CSS_FN_SRT.getMakeModalEquipmentIdList('2000-08-08');
    }
}