@IsTest
public class CSS_WPR_FCA_FaultDetailsResJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"faultDetailsList\": ['+
		'    {'+
		'      \"faultCode\": \"1682\",'+
		'      \"rootCause1\": \"Aftertreatment Fuel System Malfunction\",'+
		'      \"likelihood1\": \"43%\",'+
		'      \"rootCause2\": \"OEM Component \",'+
		'      \"likelihood2\": \"25%\",'+
		'      \"rootCause3\": \"OEM Component \",'+
		'      \"likelihood3\": \"13%\",'+
		'      \"rootCause4\": \"\",'+
		'      \"likelihood4\": \"\",'+
		'      \"faultCodeDescription\": \"Aftertreatment 1 Diesel Exhaust Fluid Dosing Unit Input Lines - Condition Exists\"'+
		'    },'+
		'    {'+
		'      \"faultCode\": \"1117\",'+
		'      \"rootCause1\": \"OEM Component \",'+
		'      \"likelihood1\": \"84%\",'+
		'      \"rootCause2\": \"Engine Wiring Harness \",'+
		'      \"likelihood2\": \"12%\",'+
		'      \"rootCause3\": \"\",'+
		'      \"likelihood3\": \"\",'+
		'      \"rootCause4\": \"\",'+
		'      \"likelihood4\": \"\",'+
		'      \"faultCodeDescription\": \"Power Supply Lost With Ignition On - Data Erratic, Intermittent, or Incorrect\"'+
		'    }'+
		'  ]'+
		'}';
        
		CSS_WPR_FCA_FaultDetailsResJSON2Apex obj = CSS_WPR_FCA_FaultDetailsResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}