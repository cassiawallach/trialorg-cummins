/**********************************************************************
Name: FSL_SPCertificationInfoScheduler_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSL_SPCertificationInfoScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                		 DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         04/02/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
@istest
public class FSL_SPCertificationInfoScheduler_Test 
{
	static testmethod void testSPCertScheduledJob() {
    	Test.startTest();
		FSL_SPCertificationInfoScheduler spCert = new FSL_SPCertificationInfoScheduler();
		String spCertCornExp = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Certification Info Scheduler', spCertCornExp, spCert); 
    	Test.stoptest();
    }
}