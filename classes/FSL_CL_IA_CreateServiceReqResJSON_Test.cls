@IsTest
public class FSL_CL_IA_CreateServiceReqResJSON_Test {
	 //Rajashekar N ; 09/09/2020 ; CT2-146
	@isTest
    private static void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Status\": \"Success\",'+
		'		\"ServiceName\": \"IASerRequestCreation\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ReturnCodeDescription\": \"IASerRequestCreation data as Response\",'+
        '		\"toolId\": \"Guidanz\",'+
        '		\"SenderId\": \"rf671\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"WONumber\": \"123456\",'+
        '		\"IASNumber\": \"IAS-001\"'+
		'	}'+
		'}';
		//added for coverage
		FSL_CL_IA_CreateServiceRequestAPIResJSON obj = FSL_CL_IA_CreateServiceRequestAPIResJSON.parse(json);
		System.assert(obj != null);	
	}
}