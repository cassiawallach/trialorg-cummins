/*
 * Written by Prashanthi on 21/06/2018
 */

@IsTest
public class CSS_WPR_TG_GetAssessDataResJSON2V3Test {
 
       static testMethod void testParse() {
		String json = '{ "Header": { "Status": "Status", "ServiceVersion": "ServiceVersion", "ServiceName": "ServiceName", "ReturnCodeDescription": "CSS02-Service Name is missing in input", "TxnCodeDescription": "CSS02-testing" }, "DataArea": { "unPrioritizedData": [ { "upfc": "testing", "rc": "testing" } ], "PSN": "65475436", "prioritizedData": [ { "relfc": [ { "rfc": "rfc" } ], "prifc": "prifc" } ], "algorithm": "algorithm", "IASNumber": "IASNumber", "CSSEnabled": "CSSEnabled" } }';
        
		CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 obj = CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.parse(json);
		System.assert(obj != null);
	}
}