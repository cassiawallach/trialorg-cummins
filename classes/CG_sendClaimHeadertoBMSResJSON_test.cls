@IsTest
public class CG_sendClaimHeadertoBMSResJSON_test {
	
	static testMethod void testParse() {
		String json = '{\"Header\": {'+
		'   \"ReturnCodeDescription\": \"Message If Any\",'+
		'   \"Status\": \"SUCCESS\",'+
		'   \"Sender\":    {'+
		'      \"ServiceName\": \"sendWCHeader\",'+
		'      \"MessageID\": \"bac053ab-5b99-4301-8895-aeb67c10a2c9\",'+
		'      \"SenderID\": \"CSS\"'+
		'   },'+
		'   \"Target\": {\"TargetID\": \"BMS\"},'+
		'   \"Location\": {\"LocationID\": \"56270-56255\"}'+
		'}}';
		CG_sendClaimHeadertoBMSResJSON obj = CG_sendClaimHeadertoBMSResJSON.parse(json);
		System.assert(obj != null);
	}
}