/*
@ Author Name: Dinesh Yadav / Harsha Ragam
@ Created Date: Dec 2020
@ Purpose: Schedule Batch Send INSITE image names to MW API(FSL_BatchSendInsitImgNamesToMWLastWeek) and update related WO Insite recods based on response
@ Test Class:
@ Last Modified Date: 
@ CT3-248.
*/
global class FSL_schBatchSendInsitImgNamesToMWLW implements Schedulable {
   global void execute(SchedulableContext sc) {
        Integer scope = 6; //default should be 6 only.
        scope = Integer.valueOf(system.Label.FSL_MW_APICALL_SCOPE);
        FSL_BatchSendInsitImgNamesToMWLastWeek b = new FSL_BatchSendInsitImgNamesToMWLastWeek(); 
        database.executebatch(b,scope);
   }
}