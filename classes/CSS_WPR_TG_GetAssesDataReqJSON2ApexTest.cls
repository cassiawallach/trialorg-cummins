@IsTest
public class CSS_WPR_TG_GetAssesDataReqJSON2ApexTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"GetPrioritizedFC\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ToolID\": \"ATLASMOBILE\",'+
		'		\"SenderID\": \"nt321\",'+
		'		\"TargetID\": \"CSS\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"PSN\": \"79634249\",'+
		'		\"SERVICEMODELNAME\": \"ISX15 CM2350 X101\",'+
		'		\"ERT\": \"0\",'+
		'		\"MAKE\": \"FREIGHTLINER\",'+
		'		\"MODEL\": \"CASCADIA\",'+
		'		\"ACCESS\": \"\",'+
		'		\"FAULTLIST\": ['+
		'			{'+
		'				\"fc\": \"1117\",'+
		'				\"occurenceTime\": 21319736,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"1682\",'+
		'				\"occurenceTime\": 21530503,'+
		'				\"status\": \"active\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3574\",'+
		'				\"occurenceTime\": 21536057,'+
		'				\"status\": \"inactive\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3596\",'+
		'				\"occurenceTime\": 21536057,'+
		'				\"status\": \"active\",'+
		'				\"count\": 2'+
		'			},'+
		'			{'+
		'				\"fc\": \"2636\",'+
		'				\"occurenceTime\": 21536560,'+
		'				\"status\": \"active\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3568\",'+
		'				\"occurenceTime\": 21535417,'+
		'				\"status\": \"active\",'+
		'				\"count\": 1'+
		'			},'+
		'			{'+
		'				\"fc\": \"3714\",'+
		'				\"occurenceTime\": 21535417,'+
		'				\"status\": \"active\",'+
		'				\"count\": 20'+
		'			}'+
		'		]'+
		'	}'+
		'}';
        
		CSS_WPR_TG_GetAssesDataReqJSON2Apex obj = CSS_WPR_TG_GetAssesDataReqJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}