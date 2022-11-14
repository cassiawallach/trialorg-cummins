@IsTest
public class CSS_WPR_TG_PrioritizedFCsResJSONTest_V3 {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ServiceVersion\": \"1.0\",'+
		'    \"ServiceName\": \"GetPrioritizedFC\",'+
		'    \"ReturnCodeDescription\": \"Prioritized FCs sent successfully\"'+
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
		'        \"prifc\": \"1117\"'+
		'      }'+
		'    ],'+
		'    \"IASNumber\": \"IAS-0000001279\",'+
		'    \"CSSEnabled\": null,'+
		'    \"algorithm\": \"Advanced\"'+
		'  }'+
		'}';
		CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 obj = CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.parse(json);
		System.assert(obj != null);
	}
}