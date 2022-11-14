@IsTest
public class CG_SendNotesSiebelResponseWrapper_Test {
    static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'      \"SiebelClaimNumber\": \"54289\",'+
		'      \"Status\": \"draft\",'+
		'      \"ReturnCodeDescription\": \"56270-56255\"'+
		
		'  }'+
        '}';
           CG_SendNotesSiebelResponseWrapper obj = CG_SendNotesSiebelResponseWrapper.parse(json);
            System.assert(obj != null);
	
}
}