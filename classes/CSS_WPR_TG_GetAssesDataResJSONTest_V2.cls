@IsTest
public class CSS_WPR_TG_GetAssesDataResJSONTest_V2 {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Error\",'+
		'    \"ServiceVersion\": null,'+
		'    \"ServiceName\": \"GetAssessData\",'+
		'    \"ReturnCodeDescription\": \"CSS03-ToolID is invalid\"'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"unPrioritizedData\": [],'+
		'    \"PSN\": null,'+
		'    \"prioritizedData\": [],'+
		'    \"IASNumber\": null,'+
		'    \"CSSEnabled\": null,'+
		'    \"algorithm\": null'+
		'  }'+
		'}';
		CSS_WPR_TG_GetAssessDataResJSON2Apex_V2 obj = CSS_WPR_TG_GetAssessDataResJSON2Apex_V2.parse(json);
		System.assert(obj != null);
	}
}