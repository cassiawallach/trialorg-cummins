/**********************************************************************
Name: CSS_ServiceHistoryOutboundJSON2Apex_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for the wrapper class CSS_ServiceHistoryOutboundJSON2Apex
======================================================
======================================================
History                                                            
-------                                                            
VERSION			AUTHOR			DATE			DETAIL                                 
1.0			Nisha Mendiratta	05/09/2016		INITIAL DEVELOPMENT                    

***********************************************************************/

@IsTest
public class CSS_ServiceHistoryOutboundJSON2Apex_Test {
    
    static testMethod void testParse() {
        String json = '{ '+
            '\"Header\": { '+
            '  \"Status\": \"success\", '+
            '  \"ReturnCodeDescription\": \"message_ifany\", '+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [ '+
            '  { '+
            '   \"CustomerName\": \"NYPD\", '+
            '   \"BMSWOreference\": \"AB23456\", '+
            '   \"ReceivedDate\": \"\", '+
            '   \"ProductModel\": \"\", '+
            '   \"Location\": \"12345-23456\", '+
            '   \"WorkSummaryCAUSE\": \"1XFFERR2344REWS\", '+
            '   \"WorkSummaryCOMPLAINT\": \"KENWORTH\", '+
            '   \"FaultcodesCORRECTION\": \"\", '+
            '   \"DistanceType\": \"\", '+
            '   \"Distance\": 0, '+
            '   \"UnitHours\": 0, '+
            '   \"BMS Link\": \"\" '+
            '  }, '+
            '  { '+
            '   \"CustomerName\": \"NYPD1\", '+
            '   \"BMSWOreference\": \"AB234561\", '+
            '   \"ReceivedDate\": \"\", '+
            '   \"ProductModel\": \"\", '+
            '   \"Location\": \"12345-23456\", '+
            '   \"WorkSummaryCAUSE\": \"1XFFERR2344REWS\", '+
            '   \"WorkSummaryCOMPLAINT\": \"KENWORTH\", '+
            '   \"FaultcodesCORRECTION\": \"\", '+
            '   \"DistanceType\": \"\", '+
            '   \"Distance\": 0, '+
            '   \"UnitHours\": 0, '+
            '   \"BMSLink\": \"\" '+
            '  } '+
            '] '+
            '}';
        CSS_ServiceHistoryOutboundJSON2Apex obj = CSS_ServiceHistoryOutboundJSON2Apex.parse(json);
        System.assert(obj != null);
    }
}