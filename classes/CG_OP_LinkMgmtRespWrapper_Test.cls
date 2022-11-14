@IsTest
public class CG_OP_LinkMgmtRespWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"qsolLink\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/145/145-fc1682.html\",'+
		'    \"language\": \"en\"'+
		'}';
		CG_OP_LinkMgmtRespWrapper obj = CG_OP_LinkMgmtRespWrapper.ParseData(json);
		System.assert(obj != null);
	}
}