@IsTest
public class CSS_WPR_TG_IAAppointmentsReqJSON_V1_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"IAAppointments\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ToolID\": \"GUIDANZ\",'+
		'		\"SenderID\": \"oh559\",'+
		'		\"TargetID\": \"CSS\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"UserLocation\": \"56270-56255-P|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S\",'+
		'		\"CurrentDate\": \"11/26/2017\"'+
		'	}'+
		'}';
		CSS_WPR_TG_IAAppointmentsReqJSON_V1 obj = CSS_WPR_TG_IAAppointmentsReqJSON_V1.parse(json);
		System.assert(obj != null);
	}
}