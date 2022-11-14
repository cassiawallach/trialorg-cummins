/**********************************************************************
Name: CSS_WOCommentInboundJson2Apex_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for the wrapper class CSS_WOCommentInboundJson2Apex
======================================================
======================================================
History                                                            
-------                                                            
VERSION			AUTHOR			DATE			DETAIL                                 
1.0			Nisha Mendiratta	05/09/2016		INITIAL DEVELOPMENT                    

***********************************************************************/

@IsTest
public class CSS_WOCommentInboundJson2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{ '+
		'\"Header\": { '+
		'  \"Status\": \"success\", '+
		'  \"ReturnCodeDescription\": \"message_ifany\", '+
		'  \"Location\": { \"LocationID\": \"02400-02394\" } '+
		'} '+
		'}';
		CSS_WOCommentInboundJson2Apex obj = CSS_WOCommentInboundJson2Apex.parse(json);
		System.assert(obj != null);
	}
}