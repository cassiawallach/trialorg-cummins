/********************************************************************************
Name:FSL_CL_AdminSRTApi_Test
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class for Admin SRT Integrtion
======================================================
User story : CT2-345
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
V.1.0 	 Rajashekar N		11/13/2020		   Send Admin SRTs to ERP
*********************************************************************************/
@isTest
public class FSL_CL_AdminSRTApi_Test {
    
    static testMethod void testActiveMethod(){
		FSL_CL_AdminSRTApi testCont = new FSL_CL_AdminSRTApi();
        FSL_CL_AdminSRTApi.dummy();
	}
    
  /*@isTest
    public static void adminSRTApi_Test(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_AdminSRTApiMock_Test());
        WorkOrder objWorkOrder = FSL_TestDataUtility.createWorkOrder(1000,'Miles');FSL_SRT__c objsrt = new FSL_SRT__c();
        List<FSL_SRT__c> lstSRTs = new List<FSL_SRT__c>();
        
        FSL_SRT__c srt901 = new FSL_SRT__c(); 
        srt901.Type__c = 'Admin';
        srt901.Service_Order__c = objWorkOrder.Id;
        srt901.Non_SRTs__c = objWorkOrder.Id;
        srt901.SRT_Time__c = 6;
        srt901.Name = '00-901-00';
        lstSRTs.add(srt901);
        
        FSL_SRT__c srt902 = new FSL_SRT__c(); 
        srt902.Type__c = 'Admin';
        srt902.Service_Order__c = objWorkOrder.Id;
        srt902.Non_SRTs__c = objWorkOrder.Id;
        srt902.SRT_Time__c = 6;
        srt902.Name = '00-902-00';
        lstSRTs.add(srt902);
        
        FSL_SRT__c srt903 = new FSL_SRT__c(); 
        srt903.Type__c = 'Admin';
        srt903.Service_Order__c = objWorkOrder.Id;
        srt903.Non_SRTs__c = objWorkOrder.Id;
        srt903.SRT_Time__c = 6;
        srt903.Name = '00-903-00';
        lstSRTs.add(srt903);
        insert lstSRTs;
        
        //FSL_CL_AdminSRTApi.adminSRTApi(objWorkOrder.Id);
        
        Test.stopTest();
        
    } */
}