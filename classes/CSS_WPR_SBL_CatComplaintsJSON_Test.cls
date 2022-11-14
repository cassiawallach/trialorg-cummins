@IsTest
public class CSS_WPR_SBL_CatComplaintsJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+    
		'  \"Header\": {'+		
		'    \"ReturnCodeDescription\": \"test\",'+
		'    \"Status\": \"completed\"'+
		'      },'+
		'	\"DataArea\": {'+
		'		\"Details\": ['+
		'			{'+
		'				\"ComplaintCode\": \"1117\",'+
		'				\"Description\": \"21319736\",'+
				
        '				\"BusinessUnit\": \"inactive\",'+
		'				\"Category\": \"1\"'+
		'			},'+
		'			{'+
		'				\"ComplaintCode\": \"1117\",'+
		'				\"Description\": \"21319736\",'+
		'				\"BusinessUnit\": \"inactive\",'+
        			
		'				\"Category\"    : \"1\"'+
		'			},'+
        '			{'+
		'				\"ComplaintCode\": \"1117\",'+
		'				\"Description\": \"21319736\",'+
	
        '				\"BusinessUnit\": \"inactive\",'+
		'				\"Category\"    : \"1\"'+
		'			},'+
        '			{'+
		'				\"ComplaintCode\": \"1117\",'+
		'				\"Description\": \"21319736\",'+

        '				\"BusinessUnit\": \"inactive\",'+
		'				\"Category\"    : \"1\"'+
		'			}'+
            
		'		]'+
        '	}'+
	'}';
        
		CSS_WPR_SBL_CatComplaintsListResJSON obj = CSS_WPR_SBL_CatComplaintsListResJSON.parse(json);
		System.assert(obj != null);
	}
}