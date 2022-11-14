@IsTest
public class CSS_WPR_TG_GetAssessDataResJSON2ApexTest {
	
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
        
		CSS_WPR_TG_GetAssessDataResJSON2Apex obj = CSS_WPR_TG_GetAssessDataResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}