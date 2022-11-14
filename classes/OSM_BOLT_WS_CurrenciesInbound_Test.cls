/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInbound_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BOLT_WS_CurrenciesInbound class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Moulika G         10/04/2018     INITIAL DEVELOPMENT          

*************************************************************/

@isTest
global class OSM_BOLT_WS_CurrenciesInbound_Test
{
    //Positive Test
    static testMethod void testPostCurrenciesInbound()
    {
        Test.startTest();
        //Input JSON Request
        String JSONReq = '{'+
                            '   \"DataArea\": {'+
                            '      \"CURR_RATE_STG_ROW\": ['+
                            '         {'+
                            '            \"TO_CONVERSION_DATE\": \"11-MAY-2018\",'+
                            '            \"TO_CURRENCY\": \"GBP\",'+
                            '            \"MODE_FLAG\": \"I\",'+
                            '            \"CONVERSION_RATE\": \".108420358741293902439024390243902439024\",'+
                            '            \"FROM_CURRENCY\": \"CNY\",'+
                            '            \"FROM_CONVERSION_DATE\": \"11-MAY-2018\",'+
                            '            \"CONVERSION_TYPE\": \"corporate\"'+
                            '         },'+
                            '         {'+
                            '            \"TO_CONVERSION_DATE\": \"11-MAY-2018\",'+
                            '            \"TO_CURRENCY\": \"GBP\",'+
                            '            \"MODE_FLAG\": \"I\",'+
                            '            \"CONVERSION_RATE\": \".00646527738264645363984\",'+
                            '            \"FROM_CURRENCY\": \"JPY\",'+
                            '            \"FROM_CONVERSION_DATE\": \"11-MAY-2018\",'+
                            '            \"CONVERSION_TYPE\": \"corporate\"'+
                            '         }'+
                            '      ]'+
                            '   }'+
                            '}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCurrenciesInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CurrenciesInbound.CurrenciesInboundService(); //Invoke the service
        Test.stopTest();
    
    }
    
    //Negative Test
    static testMethod void testPostCurrenciesInbound2()
    {
        Test.startTest();
        //Input JSON Request
        String JSONReq = '{'+
                            '   \"DataArea\": {'+
                            '      \"CURR_RATE_STG_ROW\": ['+
                            '      ]'+
                            '   }'+
                            '}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCurrenciesInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CurrenciesInbound.CurrenciesInboundService(); //Invoke the service
        Test.stopTest();  
    }
    
    static testMethod void testPostCurrenciesInbound3()
    {
        Test.startTest();
        //Input JSON Request
        String JSONReq = '{'+
                        '   \"DataArea\": {'+
                        '      \"CURR_RATE_STG_ROW\": ['+
                        '         {'+
                        '            \"TO_CONVERSION_DATE\": \"11-MAY-2018\",'+
                        '            \"TO_CURRENCY\": \"\",'+
                        '            \"MODE_FLAG\": \"I\",'+
                        '            \"CONVERSION_RATE\": \".108420358741293902439024390243902439024\",'+
                        '            \"FROM_CURRENCY\": \"CNY\",'+
                        '            \"FROM_CONVERSION_DATE\": \"11-MAY-2018\",'+
                        '            \"CONVERSION_TYPE\": \"corporate\"'+
                        '         },'+
                        '         {'+
                        '            \"TO_CONVERSION_DATE\": \"11-MAY-2018\",'+
                        '            \"TO_CURRENCY\": \"GBP\",'+
                        '            \"MODE_FLAG\": \"I\",'+
                        '            \"CONVERSION_RATE\": \".00646527738264645363984\",'+
                        '            \"FROM_CURRENCY\": \"\",'+
                        '            \"FROM_CONVERSION_DATE\": \"11-MAY-2018\",'+
                        '            \"CONVERSION_TYPE\": \"corporate\"'+
                        '         }'+
                        '      ]'+
                        '   }'+
                        '}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCurrenciesInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CurrenciesInbound.CurrenciesInboundService(); //Invoke the service
        Test.stopTest();  
    }
}