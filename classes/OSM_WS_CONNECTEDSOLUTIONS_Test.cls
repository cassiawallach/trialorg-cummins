@isTest
public class OSM_WS_CONNECTEDSOLUTIONS_Test
{
    static testMethod void testGetAccessToken() {
        //test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        //CSS_WS_OAG.getAccessToken();
                   String json = '{'+
           '    \"messageID\": \"MSG1234\",'+
           '        \"timeStamp\": \"2018-03-20T19:47:00.000Z\", '+
           '            \"initiator\": \"ECommerce\",'+
           '            \"customerID\": \"65885\"'+
           '}';
        CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='DA',Key__c='appSubscription-api-key',Passcode__c='OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=');
        insert itgDetails;

       // OSM_WS_CONNECTEDSOLUTIONS.executeRESTWebservice(json, 'https://connectedsolutions-stg.cummins.com/appSubscriptionInternal/v1/subscription/products');
    } 


}