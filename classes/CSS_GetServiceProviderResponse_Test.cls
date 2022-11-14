/*
 * Block comments with details of changes
 */
@IsTest
public class CSS_GetServiceProviderResponse_Test {
	
	static testMethod void testParse() {
		String json = '{ '+
		'\"DataArea\": { '+
		'\"InShopLaborRate\": \"19.06\", '+
		'\"FieldServiceLaborRate\": \"19.06\", '+
		'\"Region\": \"INTERNATIONAL\", '+
		'\"ChannelCode\": \"110\", '+
		'\"TravelRate\": \"0.37\", '+
		'\"Territory\": \"CHINA\", '+
		'\"ChannelOfDistribution\": \"110-DEALER\" '+
		'}, '+
		'\"Header\": {\"Status\": \"Success\"} '+
		'}';
		CSS_GetServiceProviderResponse obj = CSS_GetServiceProviderResponse.parse(json);
		System.assert(obj != null);
	}
}