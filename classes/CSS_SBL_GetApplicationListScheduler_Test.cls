/**********************************************************************
Name: CSS_SBL_GetApplicationListScheduler_Test
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for CSS_SBL_GetApplicationListScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajkumar BT        05/24/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_SBL_GetApplicationListScheduler_Test {
	
    static TestMethod void testScheduler() {
         
    CSS_SBL_GetApplicationListScheduler schClass = new CSS_SBL_GetApplicationListScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
        
    }
}