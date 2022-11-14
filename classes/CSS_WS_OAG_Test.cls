/**********************************************************************
Name: CSS_WS_OAG_Test
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    Test class
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rakesh Kumar   23/05/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class CSS_WS_OAG_Test {
	static testMethod void testGetAccessToken() {
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CSS_WS_OAG.getAccessToken();
                   String json = '{'+
           '    \"Header\": '+
           '    {'+
           '        \"Sender\": '+
           '        {'+
           '            \"ServiceName\": \"GetContactInfo\",'+
           '            \"SenderID\": \"CSS\"'+
           '        },'+
           '        \"Target\": { \"TargetID\": \"BMS\" },'+
           '        \"Location\": { \"LocationID\": \"56270-56255\" }'+
           '    },'+
           '    \"DataArea\": '+
           '    {'+
           '        \"CustomerCode\": \"409727\"'+
           '    }'+
           '}';
        CSS_WS_OAG.executeRESTWebservice(json, 'https://services-stg.cummins.com/css/claiminformation123', 'YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS');
    }
    
    static testMethod void testGetAccessToken2() {
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CSS_WS_OAG.getAccessTokenTest();
                   String json = '{'+
           '    \"Header\": '+
           '    {'+
           '        \"Sender\": '+
           '        {'+
           '            \"ServiceName\": \"GetContactInfo\",'+
           '            \"SenderID\": \"CSS\"'+
           '        },'+
           '        \"Target\": { \"TargetID\": \"BMS\" },'+
           '        \"Location\": { \"LocationID\": \"56270-56255\" }'+
           '    },'+
           '    \"DataArea\": '+
           '    {'+
           '        \"CustomerCode\": \"409727\"'+
           '    }'+
           '}';
        CSS_WS_OAG.executeRESTWebservice(json, 'https://services-stg.cummins.com/css/claiminformation123', 'YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS');
    }
    
}