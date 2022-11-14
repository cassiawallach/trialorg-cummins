@IsTest
public class CSS_WPR_TG_MakeModlAcsReqJSON2ApexTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"GetMakeModelAccessList\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ToolID\": \"ATLASMOBILE\",'+
		'		\"SenderID\": \"oh559\",'+
		'		\"TargetID\": \"CSS\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"PSN\": \"79484646\"'+
		'	}'+
		'}';
        
		CSS_WPR_TG_MakeModlAcsReqJSON2Apex obj = CSS_WPR_TG_MakeModlAcsReqJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}