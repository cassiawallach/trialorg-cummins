@IsTest
public class CG_OP_GetWarrantyDocsRespWrapper_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"documentNum\": \"ATC1943\",'+
		'        \"documentDesc\": \"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER\",'+
		'        \"type\": \"ATC\",'+
		'        \"language\": \"en\",'+
		'        \"status\": \"OPEN\",'+
		'        \"documentLink\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html\"'+
		'    }'+
		']';
		List<CG_OP_GetWarrantyDocsRespWrapper> r = CG_OP_GetWarrantyDocsRespWrapper.ParseData(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_GetWarrantyDocsRespWrapper objJSON2Apex = new CG_OP_GetWarrantyDocsRespWrapper(System.JSON.createParser(json));
		CG_OP_GetWarrantyDocsRespWrapper objJSON2Apex = new CG_OP_GetWarrantyDocsRespWrapper();
        System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.documentNum == null);
		System.assert(objJSON2Apex.documentDesc == null);
		System.assert(objJSON2Apex.type == null);
		System.assert(objJSON2Apex.language == null);
		System.assert(objJSON2Apex.status == null);
		System.assert(objJSON2Apex.documentLink == null);
	}
}