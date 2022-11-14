/*
 * Class Name :CSS_getFailureCodesSRTReqJ2A_Test
 * Purpose : Class to cover the unit test cases
 * Developer : Rajesh Pasupuleti
 * Created Date : 11/02/2016
 * 
 */
@istest
public class CSS_getFailureCodesSRTReqJ2A_Test {
    
    //Test Method to cover the request wrapper class
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"GetPartsListSRT\",'+
		'			\"SenderID\": \"CSS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"SRT\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"ServiceModelName\": \"CSS-000001234\",'+
		'		\"Languagecode\": \"C100002045\",'+
		'		\"EngineFamilyCode\": \"en\"'+
		'	}'+
		'}';
		CSS_getFailureCodesSRTReqJ2A obj = CSS_getFailureCodesSRTReqJ2A.parse(json);
		System.assert(obj != null);
	}
}