/************************************************************
Name:  OSM_BOLT_WS_JournalEntryOutboundRes_Test 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BOLT_WS_JournalEntryOutboundRes
class
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         08/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

@IsTest
public class OSM_BOLT_WS_JournalEntryOutboundRes_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"Status\": \"success\",'+
        '    \"ReturnCodeDescription\": \"Journal Entry Information received successfully\",'+
        '   \"totalServiceCallTime\": 100,'+
        '   \"totalAuthCallTime\": 100,'+
        '   \"exceptionFlag\": true,'+
        '   \"errorMessage\" :\"string\"'+
        '  }';
        OSM_BOLT_WS_JournalEntryOutboundRes obj = OSM_BOLT_WS_JournalEntryOutboundRes.parse(json);
        System.assert(obj != null);
    }
}