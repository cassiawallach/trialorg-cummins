@isTest (SeeAllData = false)
public class CSS_GetSubTypesUnitTypesService_Test {

/**********************************************************************
Name:css_intake_job
Copyright © 2011  Cummins
======================================================
======================================================
Purpose: Test Class for ServiceHistory job                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish           30/3/2016      INITIAL DEVELOPMENT                    

***********************************************************************/
    static testMethod void test(){            
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        
        
        CSS_GetSubTypesUnitTypesService unittypeservice = new CSS_GetSubTypesUnitTypesService();
        CSS_GetSubTypUnitTypResJ2A response;
        response = unittypeservice.getSubTypesUnitTypesService();        
        unittypeservice.insertJobEvent(response);
        Test.stopTest();    
               
               
    }

}