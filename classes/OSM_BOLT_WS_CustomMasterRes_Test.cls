/************************************************************
Name:  OSM_BOLT_WS_CustomMasterRes_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BOLT_WS_CustomMasterRes                                
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka            05/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

@IsTest
public class OSM_BOLT_WS_CustomMasterRes_Test {
    
/*----------------------------------------------------------------------------------
1. testParse
Description: Pass JSON String
Input: None
Output: sObejct
Returntype:OSM_BOLT_WS_CustomMasterRes
------------------------------------------------------------------------------------*/  
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"Status\": \"success\",'+
        '    \"ReturnCodeDescription\": \"Customer Information received successfully\"'+
        '}';
        OSM_BOLT_WS_CustomMasterRes obj = OSM_BOLT_WS_CustomMasterRes.parse(json);
        System.assert(obj != null);
    }
}