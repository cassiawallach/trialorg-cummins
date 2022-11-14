/**********************************************************************
Name: CSS_WPR_BMS_WOQTOutboundQuoteResJSONTest
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper Test class
            of WOQT Outbound Quote PDF of BMS Rest Service
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/19/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class CSS_WPR_BMS_WOQTOutboundQuoteResJSONTest {
    
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ReturnCodeDescription\": \"Quote is updated successfully\",'+
		'    \"Location\": {'+
		'      \"LocationID\": \"03742-03750\"'+
		'    }'+
		'  }'+
		'}';
		CSS_WPR_BMS_WOQTOutboundQuoteResJSON obj = CSS_WPR_BMS_WOQTOutboundQuoteResJSON.parse(json);
		System.assert(obj != null);
	}
}