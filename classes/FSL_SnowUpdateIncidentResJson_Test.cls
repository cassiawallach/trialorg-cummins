@isTest
public class FSL_SnowUpdateIncidentResJson_Test {
    
     static testMethod void testParse() {
        
        String json = '{'+
		'    \"result\": {'+
		'        \"Message\": \"Incident has been updated successfully.\",'+
		'        \"IncidentNumber\": \"INC0778666\",'+
		'        \"URL\": \"https://cumminsdev.service-now.com/incident.do?sys_id=c91ba8371bff28d4a97e65386e4bcb96\"'+
		'    }'+
		'}';
		FSL_SnowUpdateIncidentResJson obj = FSL_SnowUpdateIncidentResJson.parse(json);
		System.assert(obj != null);
    }
    
//this comments use for Deployment Purpose Set missing comp
}