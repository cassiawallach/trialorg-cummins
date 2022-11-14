@IsTest
public class CSS_WPR_TG_MakeModlAcsResJSON2ApexTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Status\": \"Success\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ServiceName\": \"GetMakeModelAccessList\",'+
		'		\"ReturnCodeDescription\": \"MakeModelAccess list sent successfully\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"SERVICEMODELNAME\": \"ISX15 CM2250\",'+
		'		\"SELECTMODEL\": \"\",'+
		'		\"SELECTMAKE\": \"\",'+
		'		\"SELECTACCESS\": \"\",'+
		'		\"PSN\": \"79484646\",'+
		'		\"MAKEMODELACCESS\": ['+
		'			{'+
		'				\"MODEL\": \"T660\",'+
		'				\"MAKE\": \"KENWORTH\",'+
		'				\"ACCESS\": \"\"'+
		'			},'+
		'			{'+
		'				\"MODEL\": \"T-800B\",'+
		'				\"MAKE\": \"KENWORTH\",'+
		'				\"ACCESS\": \"\"'+
		'			}'+
		'		]'+
		'	}'+
		'}';
        
		CSS_WPR_TG_MakeModlAcsResJSON2Apex obj = CSS_WPR_TG_MakeModlAcsResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}