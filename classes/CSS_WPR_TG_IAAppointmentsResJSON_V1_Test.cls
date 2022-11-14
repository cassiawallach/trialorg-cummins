@IsTest
public class CSS_WPR_TG_IAAppointmentsResJSON_V1_Test{

	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Status\": \"Success\",'+
		'		\"ServiceName\": \"IAAppointments\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"ReturnCodeDescription\": \"IA Appointment data as Response\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CustomerName\": \"Tom Curise\",'+
		'		\"ContactFirstName\": \"Tom\",'+
		'		\"ContactLastName\": \"Curise\",'+
		'		\"CSSJobNumber\": \"CSS00012345\",'+
		'		\"UnitNumber\": \"10548795612\",'+
		'		\"ComplaintText\": \"Curise control is not working\",'+
		'		\"AvailableForService\": \"1\"'+
		'	}'+
		'}';
		CSS_WPR_TG_IAAppointmentsResJSON_V1 obj = CSS_WPR_TG_IAAppointmentsResJSON_V1.parse(json);
		System.assert(obj != null);	
	}
}