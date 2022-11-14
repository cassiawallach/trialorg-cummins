@IsTest
public class CSS_WPR_TG_GetAssessDataResV3_Test {

    static testMethod void testParse() {
        
        String json = '{'+
        '  \"Header\": {'+
		'    \"ServiceName\"    : \"ServiceName\",'+
		'    \"ServiceVersion\" : \"ServiceName\",'+
		'    \"Status\"    : \"ServiceName\",'+
        '    \"ReturnCodeDescription\": \"CSS02-Service Name is missing in input\",'+
        '    \"TxnCodeDescription\": \"CSS02-Service Name is missing in input\"'+    
        '  },'+
        '  \"DataArea\": {'+
		'    \"PSN\"      : \"psn\",'+  
        '    \"algorithm\": \"algorithm\",'+
		'    \"IASNumber\": \"IASNumber\",'+
		'    \"CSSEnabled\": \"CSSEnabled\",'+
        '    \"prioritizedData \":[],' +   
        '    \"unPrioritizedData\": []'+
        '  }'+
		'}'; 
        
        CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 obj = CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.parse(json);
        System.assert(obj != null);
	}
        
}