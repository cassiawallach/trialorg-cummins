//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class OSM_WS_GeneralizedInputWrapper_Test {
    
    static testMethod void testParse() {
    
        String json = '{'+
        '  \"messageID\": \"MSG1\",'+
        '  \"timeStamp\": \"2018-03-23T13:14:00.000Z\",'+
        '  \"initiator\": \"eCommerce\",'+
        '  \"customerId\": \"65885\",'+
        '  \"orderId\": \"ORD75\",'+
        '  \"createdDate\": \"2018-03-23T13:14:00.000Z\",'+
        '  \"cancelDate\": \"2018-03-24T13:14:00.000Z\",'+
        '  \"orderLineItems\": ['+
        '    {'+
        '      \"productID\": \"2345678\",'+
        '      \"freeTrial\": \"No\",'+
        '      \"subscriptionQuantity\": \"1\",'+
        '      \"subscriptionType\": \"New\",'+
        '      \"startDate\": \"2018-03-23T13:14:00.000Z\",'+
        '      \"expirationDate\": \"2019-03-23T13:14:00.000Z\",'+
        '      \"equipmentGroups\": []'+
        '    },'+
        '    {'+
        '      \"productID\": \"4567890\",'+
        '      \"freeTrial\": \"Yes\",'+
        '      \"subscriptionQuantity\": \"1\",'+
        '      \"subscriptionType\": \"New\",'+
        '       \"startDate\": \"2018-03-23T13:14:00.000Z\",'+
        '      \"expirationDate\": \"2019-03-23T13:14:00.000Z\",'+
        '      \"equipmentGroups\": []'+
        '    }'+
        '  ]'+
        '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        System.assert(obj != null);
    }
}