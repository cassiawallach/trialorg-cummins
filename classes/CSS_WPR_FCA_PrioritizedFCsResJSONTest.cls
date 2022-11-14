@IsTest
public class CSS_WPR_FCA_PrioritizedFCsResJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"version\": 1,'+
		'  \"transactionId\": \"125371135557632\",'+
		'  \"algorithm\": \"Advanced\",'+
		'  \"prioritizedData\": ['+
		'    {'+
		'      \"pri\": \"3596\",'+
		'      \"rel\": ['+
		'        \"3574\",'+
		'        \"3714\"'+
		'      ]'+
		'    }'+
		'  ],'+
		'  \"unPrioritizedData\": ['+
		'    {'+
		'      \"fc\": \"1117\",'+
		'      \"rc\": \"6\"'+
		'    },'+
		'    {'+
		'      \"fc\": \"1682\",'+
		'      \"rc\": \"6\"'+
		'    },'+
		'    {'+
		'      \"fc\": \"2636\",'+
		'      \"rc\": \"6\"'+
		'    },'+
		'    {'+
		'      \"fc\": \"3568\",'+
		'      \"rc\": \"6\"'+
		'    }'+
		'  ]'+
		'}';
        
		CSS_WPR_FCA_PrioritizedFCsResJSON2Apex obj = CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}