@IsTest
public class CG_IP_CampaignsReqJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"Header\": {'+
		'        \"Sender\": {'+
		'            \"MessageID\": \"UniqueID\",'+
		'            \"ServiceName\": \"GetCampaign\",'+
		'            \"SenderID\": \"CSS\"'+
		'        },'+
		'        \"Target\": \"CSSWarranty\"'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"Esn\": \"33186363\",'+
        '        \"Region\": \"NORTH AMERICA\",'+
        '        \"Territory\": \"\",'+
		'        \"FailureDate\": \"24-AUG-16\"'+
		'    }'+
		'}';
		CG_IP_CampaignsReqJSON obj = CG_IP_CampaignsReqJSON.parse(json);
		System.assert(obj != null);
	}
}