@IsTest
public class CSS_WPR_FCA_PrioritizedFCsReqJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"token\": \"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS\",'+
		'	\"version\": 1,'+
		'	\"toolId\": \"15\",'+
		'	\"esn\": \"79634249 \",'+
		'	\"currentRunTime\": 11693,'+
		'	\"faultList\": {'+
		'		\"items\": ['+
		'			{'+
		'				\"fc\": \"1117\",'+
		'				\"occurenceTime\": 21319736,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"1682\",'+
		'				\"occurenceTime\": 21530503,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3574\",'+
		'				\"occurenceTime\": 21536057,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 35'+
		'			},'+
		'			{'+
		'				\"fc\": \"3596\",'+
		'				\"occurenceTime\": 21536057,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 15'+
		'			},'+
		'			{'+
		'				\"fc\": \"2636\",'+
		'				\"occurenceTime\": 21536560,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3568\",'+
		'				\"occurenceTime\": 21535417,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3714\",'+
		'				\"occurenceTime\": 21535417,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 20'+
		'			}'+
		'		]'+
		'	}'+
		'}';
        
		CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex obj = CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}