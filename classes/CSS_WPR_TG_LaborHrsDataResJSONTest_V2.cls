@IsTest
public class CSS_WPR_TG_LaborHrsDataResJSONTest_V2 {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ServiceVersion\": \"1.0\",'+
		'    \"ServiceName\": \"GetLaborHrsData\",'+
		'    \"ReturnCodeDescription\": \"Labor Hours Data sent successfully\"'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"unPrioritizedData\": ['+
		'      {'+
		'        \"upfc\": \"1116\",'+
		'        \"rc\": \"4\"'+
		'      },'+
		'      {'+
		'        \"upfc\": \"1118\",'+
		'        \"rc\": \"4\"'+
		'      },'+
		'      {'+
		'        \"upfc\": \"1119\",'+
		'        \"rc\": \"4\"'+
		'      }'+
		'    ],'+
		'    \"PSN\": \"79541769\",'+
		'    \"prioritizedData\": ['+
		'      {'+
		'        \"relfc\": [],'+
		'        \"prifc\": \"1117\",'+
		'        \"lhrs\": \"5.65\"'+
		'      }'+
		'    ],'+
		'    \"IASNumber\": \"IAS-0000001280\",'+
		'    \"CSSEnabled\": null,'+
		'    \"algorithm\": \"Advanced\"'+
		'  }'+
		'}';
		CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 obj = CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.parse(json);
		System.assert(obj != null);
	}
}