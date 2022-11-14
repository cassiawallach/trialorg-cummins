/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInboundRes_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex test class for Currencies interface 
response class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         10/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

@IsTest
public class OSM_BOLT_WS_CurrenciesInboundRes_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '\"String\" : \"Success\",'+
        '\"ReturnCodeDescription\": \"Currencies Information received successfully\"'+
        '}';
        OSM_BOLT_WS_CurrenciesInboundRes obj = OSM_BOLT_WS_CurrenciesInboundRes.parse(json);
        System.assert(obj != null);
    }
}