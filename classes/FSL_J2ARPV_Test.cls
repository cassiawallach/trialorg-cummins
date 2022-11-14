@isTest
public class FSL_J2ARPV_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'   \"DataArea\":    {'+
		'      \"NotificationMessage\": \"\",'+
		'      \"RepeatVisitFlag\": \"N\",'+
		'      \"NotificationFlag\": \"\",'+
		'      \"ErrorCode\": 0'+
		'   },'+
		'   \"Header\": {\"Status\": \"Success\"}'+
		'}';
		FSL_J2ARPV obj = FSL_J2ARPV.parse(json);
		System.assert(obj != null);
	}
}