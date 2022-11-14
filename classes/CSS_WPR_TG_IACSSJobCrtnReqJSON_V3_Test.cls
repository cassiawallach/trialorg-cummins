@isTest
public class CSS_WPR_TG_IACSSJobCrtnReqJSON_V3_Test {
    static testMethod void testParse() {
        	String json = '{'+
		'  \"Header\": {'+
		'    \"ToolID\": \"Error\",'+
		'    \"ServiceVersion\": \"Error\",'+
		'    \"ServiceName\": \"Error\",'+
		'    \"SenderID\": \"CSS02-Service Name is missing in input\",'+
        '    \"TargetID\": \"CSS02-Service Name is missing in input\"'+      
		'  },'+
        '  \"DataArea\": {'+
		'    \"IASNumber\": \"Error\",'+
		'    \"CSSJobNumber\": \"Error\"'+
        '}'+
        ' }';
	CSS_WPR_TG_IACSSJobCreationReqJSON_V3 obj = CSS_WPR_TG_IACSSJobCreationReqJSON_V3.parse(json);
		System.assert(obj != null);
    }
}