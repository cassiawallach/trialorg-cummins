@isTest
public class FSL_SnowUpdateIncidentReqJson_Test {
    static testMethod void testParse() {
        
        String json = '{'+
		'\"comments\":\"Testing additional comments\",'+
		'\"work_notes\":\"Testing Work Notes\",'+
		'\"impact\":\"3\",'+
		'\"urgency\":\"4\",'+
		'\"category\":\"Application\",'+
		'\"subcategory\":\"Repair/Fix\"'+
		'}';
		FSL_SnowUpdateIncidentReqJson obj = FSL_SnowUpdateIncidentReqJson.parse(json);
		System.assert(obj != null);
    }

//this comments use for Deployment Purpose Set missing comp   
//Rahul for deployment
}