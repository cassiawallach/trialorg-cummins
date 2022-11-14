@isTest
public class CSS_J2ADsid_Test {	
	static testMethod void testParse() {
		String json = '{\"dsid\":\"DSBDT4759\"}';
		CSS_J2ADsid_EDS obj = CSS_J2ADsid_EDS.parse(json);
		System.assert(obj != null);
	}
}