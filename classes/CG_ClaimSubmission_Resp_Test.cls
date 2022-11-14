@IsTest
public class CG_ClaimSubmission_Resp_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		''+
		'    \"DataArea\": {'+
		''+
		'        \"Status\": \"Success\",'+
		''+
		'        \"ErrorMessage\": \"\",'+
		''+
		'        \"ClaimNumber\": \"1-127827968\"'+
		''+
		'    },'+
		''+
		'    \"Header\": {'+
		''+
		'        \"ReturnCodeDescription\": \"\",'+
		''+
		'        \"Status\": \"Success\"'+
		''+
		'    }'+
		''+
		'}';
		CG_ClaimSubmission_Resp obj = CG_ClaimSubmission_Resp.parse(json);
		System.assert(obj != null);
	}
}