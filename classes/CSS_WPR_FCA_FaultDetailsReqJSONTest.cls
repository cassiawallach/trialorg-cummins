@IsTest
public class CSS_WPR_FCA_FaultDetailsReqJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"serviceModelName\": \"ISX15 CM2350 X101\",'+
		'    \"faultList\": '+
		'     ['+
		'      \"1117\",\"1682\"        '+
		'     ]'+
		'}';
        
		CSS_WPR_FCA_FaultDetailsReqJSON2Apex obj = CSS_WPR_FCA_FaultDetailsReqJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}