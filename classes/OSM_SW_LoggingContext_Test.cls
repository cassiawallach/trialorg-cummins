/* =============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Moulika M        23/04/2018       Test Class        

*************************************************************/
@isTest
public class OSM_SW_LoggingContext_Test {
    Static TestMethod Void integrationLog_Test(){
        //OSM Integration Log
        OSM_Integration_Log__c om=new OSM_Integration_Log__c();
        Insert om;
        Test.startTest();
        OSM_SW_LoggingContext.saveIntegrationLog(om);
        OSM_SW_LoggingContext.saveIntegrationLog(null);
        Test.stopTest();
        }
}