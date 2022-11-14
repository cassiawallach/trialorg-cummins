@IsTest
public class CG_IP_BMSPrivateSRTsReqJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"getBMSPrivateSRTs\",'+
		'      \"SenderID\": \"CSS\"'+
		'    },'+
		'    \"Target\": {'+
		'      \"TargetID\": \"BMS\"'+
		'    },'+
		'    \"Location\": {'+
		'      \"LocationID\": \"56270-56255\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": {'+
		'    \" DistributorCode\": \"56270\",'+
		'    \" BranchCode\": \"56255\",'+
		'    \" EngineFamily\": \"10\"'+
		'  }'+
		'}';
		CG_IP_BMSPrivateSRTsReqJSON obj = CG_IP_BMSPrivateSRTsReqJSON.parse(json);
		System.assert(obj != null);
	}
}