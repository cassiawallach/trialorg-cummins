/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInboundReq_Test 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex test class for Currencies interface 
request class
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         10/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

@IsTest
public class OSM_BOLT_WS_CurrenciesInboundReq_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  '+
        '  \"Header\": {'+
        ''+
        '    \"Sender\": {'+
        ''+
        '      \"ServiceName\": \"CustomerMasterOutbound\",'+
        ''+
        '      \"SenderID\": \"BOLT\"'+
        ''+
        '    },'+
        ''+
        '    \"Target\": {'+
        ''+
        '      \"TargetID\": \"OSM\"'+
        ''+
        '    }'+
        ''+
        '  },'+
        ''+
        '  \"DataArea\": {'+
        '    \"CURR_RATE_STG_ROW\": ['+
        '      {'+
        '        \"FROM_CURRENCY\": \"MZN\",'+
        '        \"TO_CURRENCY\": \"RON\",'+
        '        \"FROM_CONVERSION_DATE\": \"05-FEB-2018\",'+
        '        \"TO_CONVERSION_DATE\": \"04-MAR-2018\",'+
        '        \"CONVERSION_TYPE\": \"Corporate\",'+
        '        \"CONVERSION_RATE\": \".061095890410958967368273972602772297924\",'+
        '        \"MODE_FLAG\": \"I\"'+
        '      },'+
        '      {'+
        '        \"FROM_CURRENCY\": \"NOK\",'+
        '        \"TO_CURRENCY\": \"GHS\",'+
        '        \"FROM_CONVERSION_DATE\": \"05-FEB-2018\",'+
        '        \"TO_CONVERSION_DATE\": \"04-MAR-2018\",'+
        '        \"CONVERSION_TYPE\": \"Corporate\",'+
        '        \"CONVERSION_RATE\": \".585626711882092951437328811790704856267\",'+
        '        \"MODE_FLAG\": \"I\"'+
        '      }'+
        '    ]'+
        '  }'+
        '}';
        OSM_BOLT_WS_CurrenciesInboundReq obj = OSM_BOLT_WS_CurrenciesInboundReq.parse(json);
        System.assert(obj != null);
    }
}