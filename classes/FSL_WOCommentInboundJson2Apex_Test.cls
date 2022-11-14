/**********************************************************************
Name: FSL_WOCommentInboundJson2Apex_Test
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:    Test Class for the wrapper class FSL_WOCommentInboundJson2Apex
======================================================
======================================================
History                                                            
-------                                                            
VERSION			AUTHOR			DATE			DETAIL                                 
1.0			    Harsha	          19-Feb-2020		INITIAL DEVELOPMENT                    

***********************************************************************/
//Added for Testclass coverage
@isTest
public class FSL_WOCommentInboundJson2Apex_Test {
    static testMethod void testParseInbound() {
        String json = '{ '+
            '\"Header\": { '+
            '  \"Status\": \"success\", '+
            '  \"ReturnCodeDescription\": \"message_ifany\", '+
            '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
            '} '+
            '}';
        FSL_WOCommentInboundJson2Apex obj = FSL_WOCommentInboundJson2Apex.parse(json);
        System.assert(obj != null);
    }
}