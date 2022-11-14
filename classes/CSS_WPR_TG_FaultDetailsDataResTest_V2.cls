@IsTest
public class CSS_WPR_TG_FaultDetailsDataResTest_V2 {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ServiceVersion\": \"1.0\",'+
		'    \"ServiceName\": \"GetAssessData\",'+
		'    \"ReturnCodeDescription\": \"Fault Details Data sent successfully\"'+
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
		'        \"rootCause4\": \"\",'+
		'        \"rootCause3\": \"\",'+
		'        \"rootCause2\": \"Engine Wiring Harness\",'+
		'        \"rootCause1\": \"OEM Component\",'+
		'        \"relfc\": [],'+
		'        \"rc4Likelihood\": \"\",'+
		'        \"rc3Likelihood\": \"\",'+
		'        \"rc2Likelihood\": \"11%\",'+
		'        \"rc1Likelihood\": \"82%\",'+
		'        \"prifc\": \"1117\",'+
		'        \"lhrs\": \"5.65\"'+
		'      }'+
		'    ],'+
		'    \"IASNumber\": \"IAS-0000001281\",'+
		'    \"CSSEnabled\": null,'+
		'    \"algorithm\": \"Advanced\"'+
		'  }'+
		'}';
		CSS_WPR_TG_FaultDetailsDataResJSON_V2 obj = CSS_WPR_TG_FaultDetailsDataResJSON_V2.parse(json);
		System.assert(obj != null);
	}
}