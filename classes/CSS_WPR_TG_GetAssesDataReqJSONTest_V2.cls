@IsTest
public class CSS_WPR_TG_GetAssesDataReqJSONTest_V2 {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"GetAssessData\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ToolID\": \"ATLASMOBILE\",'+
		'		\"SenderID\": \"nt321\",'+
		'		\"TargetID\": \"CSS\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"PSN\": \"79541769\",'+
		'		\"SERVICEMODELNAME\": \"ISX15 CM2250\",'+
		'		\"ERT\": \"20090001\",'+
		'		\"MAKE\": \"UNLISTED\",'+
		'		\"MODEL\": \"ALL\",'+
		'		\"ACCESS\": \"B\",'+
		'		\"UserLocation\": \"56270-56255\",'+
		'		\"CustomerName\": \"TEST\",'+
		'		\"ComplaintText\": \"Oil Leak \",'+
		'		\"IASNumber\": \"IAS-0000000130\",'+
		'		\"FAULTLIST\": ['+
		'			{'+
		'				\"fc\": \"1117\",'+
		'				\"occurenceTime\": 0,'+
		'				\"status\": \"active\",'+
		'				\"count\": 1'+
		'			}'+
		'			'+
		'		]'+
		'	}'+
		'}';
		CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 obj = CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.parse(json);
		System.assert(obj != null);
	}
}