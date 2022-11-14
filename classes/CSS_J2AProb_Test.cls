@isTest
public class CSS_J2AProb_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"status\": \"success\"'+
		'}';
		CSS_J2AProblem_EDS obj = CSS_J2AProblem_EDS.parse(json);
		System.assert(obj != null);
	}
}