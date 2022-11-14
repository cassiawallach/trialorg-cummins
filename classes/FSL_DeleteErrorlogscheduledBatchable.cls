/**********************************************************************
Name:FSL_DeleteErrorlogscheduledBatchable 
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: 
--------
This schedule batch class is used to delete success records from
FSL integration error object
======================================================
======================================================
History
-------
VERSION  AUTHOR                     DATE
1.0     Ravikanth Macherla         02/27/2020
***********************************************************************/	
global class FSL_DeleteErrorlogscheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      FSL_DeleteSuccessErrorLogs FSLDelete = new FSL_DeleteSuccessErrorLogs();
      Database.executeBatch(FSLDelete);
   }
}