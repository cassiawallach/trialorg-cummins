/*
@ Author Name: Dinesh Yadav
@ Created Date: Dec 2020
@ Purpose: Schedule Batch Send INSITE image names to MW API(FSL_BatchSendInsitImgNamesToMW) and update related WO Insite recods based on response
@ Test Class: FSL_schBatchSendInsitImgNamesToMW_Test
@ Last Modified Date: 
@ CT3-237.
*/
global class FSL_schBatchSendInsitImgNamesToMW implements Schedulable {
   global void execute(SchedulableContext sc) {
        Integer scope = 6; //default should be 6 only.
        scope = Integer.valueOf(system.Label.FSL_MW_APICALL_SCOPE);
        FSL_BatchSendInsitImgNamesToMW b = new FSL_BatchSendInsitImgNamesToMW(); 
        database.executebatch(b,scope);
   }
}