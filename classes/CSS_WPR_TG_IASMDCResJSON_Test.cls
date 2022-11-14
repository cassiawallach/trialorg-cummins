@IsTest
public class CSS_WPR_TG_IASMDCResJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"Header\": {'+
		'        \"Status\": \"Success\",'+
		'        \"ReturnCode\": \"CG-01\",'+
		'        \"ReturnCodeDescription\": \"Successfully placed file in SFTP\"'+
		'    }'+
		'}';
        
		CSS_WPR_TG_IASMDCResJSON obj = CSS_WPR_TG_IASMDCResJSON.parse(json);
		System.assert(obj != null);
	}
}