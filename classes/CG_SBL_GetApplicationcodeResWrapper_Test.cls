@IsTest
public class CG_SBL_GetApplicationcodeResWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"ReturnCodeDescription\": \"<Message from Siebel>\",'+
		'    \"Status\": \"Success\",'+
		'    \"ReturnCode\": \"<MessageCode from Siebel>\",'+
		'    \"MessageIdentifier\": \"<Identifier from MW>\"'+
		'  },'+
		'  \"DataArea\": ['+
		'    {'+
		'      \"MarketingApplicationCode\": \"BW\",'+
		'      \"MarketingApplicationDescription\": \"AUTOMOTIVE (X15)\",'+
		'      \"ProductApplicationCode\": \"120\",'+
		'      \"ProductApplicationDescription\": \"AUTOMOTIVE (C-OVER 225 HP)\",'+
		'      \"ProductFamilyCode\": \"09\"'+
		'    },'+
		'    {'+
		'      \"MarketingApplicationCode\": \"UX\",'+
		'      \"MarketingApplicationDescription\": \"BUS\",'+
		'      \"ProductApplicationCode\": \"210\",'+
		'      \"ProductApplicationDescription\": \"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS\",'+
		'      \"ProductFamilyCode\": \"OE\"'+
		'    }'+
		'  ]'+
		'}';
		CG_SBL_GetApplicationcodeResWrapper obj = CG_SBL_GetApplicationcodeResWrapper.parse(json);
		System.assert(obj != null);
	}
}