@IsTest
public class CSS_WPR_SBL_GetTechInfoReqJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"Header\": {'+
		'        \"Sender\": {'+
		'            \"ServiceName\": \"GetTechInfo\",'+
		'            \"SenderID\": \"CSS\"'+
		'        },'+
		'        \"Target\": {'+
		'            \"TargetID\": \"SIEBEL\"'+
		'        }'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"LAST_PROCESSED_DATE\": \"2017-06-04\",'+
		'        \"SP_CODE\": ['+
		'            \"23456\",'+
		'            \"12343\"'+
		'        ]'+
		'    }'+
		'}';
        
		CSS_WPR_SBL_GetTechInfoReqJSON obj = CSS_WPR_SBL_GetTechInfoReqJSON.parse(json);
		System.assert(obj != null);
	}
}