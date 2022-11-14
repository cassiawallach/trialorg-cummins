/**********************************************************************
Name: FSL_SPTechCertificationSchedular
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSL_SPTechCertificationBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  	AUTHOR                 DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         04/02/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSL_SPTechCertificationSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSL_SPTechCertificationBatch SPTechCertBatch = new FSL_SPTechCertificationBatch(); 
        Database.executeBatch(SPTechCertBatch);
    }
}