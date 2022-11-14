/**********************************************************************
Name:CSS_SRTAccessWebService_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:  Test Class for CSS_SRTAccessWebService class.                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION AUTHOR              DATE                    DETAIL                                
1.0     Rajesh P         11/11/2016         INITIAL DEVELOPMENT                      
***********************************************************************/
@isTest
public class CSS_SRTAccessWebService_Test{
       
 static testMethod void testAccessSRT1(){      

     		Decimal iSRTime;
     		List<CSS_JobEventTemporary__c> srtempList= new List<CSS_JobEventTemporary__c >();
             CSS_SRTAccessWebService.srtIntegrationError('Test Error Msg');
             css_JobEventTemporary__c obj = new css_JobEventTemporary__c();
     		obj = CSS_TestData.createJobEventTempObj(false);
       		System.assert(obj != null);
       	Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_SRTAccessWebService_Mock());
     		CSS_SRTAccessWebService.receiveToken();
     		CSS_SRTAccessWebService.splreceiveToken('test');
            srtempList = CSS_SRTAccessWebService.accessSRT(obj.Id,'EQ7667','ISL9 CM2250','TestCode');
      		Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
            iSRTime = CSS_SRTAccessWebService.accessSRTStepDetails('EQ7667','ISL9 CM2250');
        Test.stopTest();       

  }

}