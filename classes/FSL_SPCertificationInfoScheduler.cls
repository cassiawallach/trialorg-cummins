/**********************************************************************
Name: FSLSPAffilationsInfoScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSL_SPCertificationInfoBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  	AUTHOR                 DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         04/02/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSL_SPCertificationInfoScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSL_SPCertificationInfoBatch SPCertBatch = new FSL_SPCertificationInfoBatch(); 
        Database.executeBatch(SPCertBatch);
    }
}