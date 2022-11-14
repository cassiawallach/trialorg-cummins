/*
 * Block comments with details of changes
 */
@IsTest
public class CSS_GetServiceProviderRequest_Test {
	
	static testMethod void testParse() {
		String json = '{ '+
		'\"Header\":{ '+
		'\"Sender\":{ '+
		'\"MessageID\":\"UniqueID\", '+
		'\"ServiceName\":\"SPDataLookup\", '+
		'\"SenderID\":\"CSS\" '+
		'}, '+
		'\"Target\":\"CSSWarranty\" '+
		'}, '+
		'\"DataArea\":{ '+
		'\"SPCode\":\"26788\", '+
		'\"ServiceModelName\":\"ASERIES ONAN\", '+
		'\"FailureDate\":\"01-AUG-14\" '+
		'} '+
		'}';
		CSS_GetServiceProviderRequest obj = CSS_GetServiceProviderRequest.parse(json);
		System.assert(obj != null);
	}
}