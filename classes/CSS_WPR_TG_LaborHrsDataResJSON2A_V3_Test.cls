@isTest
public class CSS_WPR_TG_LaborHrsDataResJSON2A_V3_Test {
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Error\",'+
		'    \"ServiceVersion\": null,'+
		'    \"ServiceName\": null,'+
		'    \"ReturnCodeDescription\": \"CSS02-Service Name is missing in input\"'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"unPrioritizedData\": [],'+
		'    \"PSN\": null,'+
		'    \"prioritizedData\": [],'+
		'    \"algorithm\": null'+
		'  }'+
		'}';
        
		CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 obj = CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.parse(json);
		System.assert(obj != null);
	}	
}