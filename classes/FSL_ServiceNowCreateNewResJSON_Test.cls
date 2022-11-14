@isTest
public class FSL_ServiceNowCreateNewResJSON_Test {
     static testMethod void testparse(){
        
        String json = '{'+
		'    \"result\": {'+
		'        \"Message\": \"Incident has been created successfully.\",'+
		'        \"IncidentNumber\": \"INC0778666\",'+
		'        \"Priority\": \"2 - High\",'+
		'        \"IncidentSysID\": \"c91ba8371bff28d4a97e65386e4bcb96\",'+
		'        \"Thirdparty\": \"\",'+
		'        \"TicketNumber\": \"\",'+
		'        \"TicketURL\": \"\",'+
		'        \"URL\": \"https://cumminsdev.service-now.com/incident.do?sys_id=c91ba8371bff28d4a97e65386e4bcb96\"'+
		'    }'+
		'}';
		FSL_ServiceNowCreateNewResJSON obj = FSL_ServiceNowCreateNewResJSON.parse(json);
		System.assert(obj != null);
    }

	
///this comments use for Deployment Purpose Set missing comp
}