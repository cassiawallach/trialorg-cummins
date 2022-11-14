/**********************************************************************
Name:  CSS_receive30DayAlerts_Test
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to mock an HTTP response to test if we received the 30 day Alerts 
from Connected Diagnostics.                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 - Shruti            2/11/2016     INITIAL DEVELOPMENT          

Methods:
1. testRequestAlertsValidResponse() - 
This method tests the receipt of a valid JSON response from the HTTP mock response for the 
given ESN.

2. testRequestAlertsNonTelematicsESN()
This method tests the receipt of a valid JSON error response from the HTTP mock response for 
the given Non-telematics ESN.

***********************************************************************/

@isTest(SeeAllData=True)    
public class CSS_recieve30DayAlerts_Test 
{    
    static testmethod void testRequestAlertsValidResponse() 
    {
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        Test.stopTest();   
    }
    static testmethod void testRequestAlertsNonTelematicsESN() 
    {
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '11111111';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        
        Test.stopTest();   
    }
    static testmethod void testRemoveAlerts(){
        CSS_receive30DayAlerts.logIntegrationError('Error', 'Integration Error');
    }
    
    static testmethod void testIntegrationError(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        CSS_receive30DayAlerts.removeAlerts(obj.ID);    
        Test.stopTest();
    }
    static testmethod void testTelematics(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        CSS_receive30DayAlerts.Telematics(obj.ID);    
        Test.stopTest();
    }
    static testmethod void testTele(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = null;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        Test.stopTest();   
    }
    static testmethod void testTe(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Kilometers'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        Test.stopTest();   
    }
    static testmethod void testTel(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Hours'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        Test.stopTest();   
    }
    static testmethod void testTelem(){
        Test.startTest();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = null; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
        Test.stopTest();   
    }
}