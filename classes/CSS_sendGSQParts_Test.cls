/**********************************************************************
Name: CSS_sendGSQParts_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_sendGSQParts
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           Venkat                    10/26/2016    INITIAL dEVELOPMENT

***********************************************************************/
@isTest
public class CSS_sendGSQParts_Test {
    static testmethod void sendGSQPartsServicetest(){
        //CSS_sendGSQParts ClsGSQ = new CSS_sendGSQParts();
        CSS_getPartsListBMSRequestJ2A sendGSQPartsreq = new CSS_getPartsListBMSRequestJ2A();
         CSS_getPartsListBMSResponseJ2A sendGSQPartsResp = new  CSS_getPartsListBMSResponseJ2A();
        String accessToken;
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_SendGSQPartsMockup_Test());
        Test.startTest();
       sendGSQPartsResp = CSS_sendGSQParts.sendGSQParts(sendGSQPartsreq);
        accessToken = CSS_sendGSQParts.getAccessTokenFromBMSOrg();
        Test.stopTest();
    }
}