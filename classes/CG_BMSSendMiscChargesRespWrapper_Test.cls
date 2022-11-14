@IsTest
public class CG_BMSSendMiscChargesRespWrapper_Test {
	
	static testMethod void CG_BMSSendMiscChargesRespWrapper() {
		String json = '{\"Header\": {'+
		'   \"ReturnCodeDescription\": \"Message If Any\",'+
		'   \"Status\": \"SUCCESS\",'+
		'   \"Sender\":    {'+
		'      \"ServiceName\": \"sendMiscCharges \",'+
		'      \"MessageID\": \"bac053ab-5b99-4301-8895-aeb67c10a2c9\",'+
		'      \"SenderID\": \"CSS\"'+
		'   },'+
		'   \"Target\": {\"TargetID\": \"BMS\"},'+
		'   \"Location\": {\"LocationID\": \"56270-56255\"}'+
		'}}';
		CG_BMSSendMiscChargesRespWrapper obj = CG_BMSSendMiscChargesRespWrapper.parse(json);
		System.assert(obj != null);
	}
}