/**
* Name : dbu_AddressCalloutMockTest 
* Description: Mock Class
* @Date 05/05/2022
*/
@isTest
public class dbu_AddressCalloutMockTest implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Create a Mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "results" : [{ "geometry" : { "location" : {"lat" : 37.7787937,"lng" : -122.4216864} } }], "result" :  { "address_components" : [ { "long_name" : "404", "short_name" : "404", "types" : [ "street_number" ] }, { "long_name" : "Frankfort Avenue", "short_name" : "Frankfort Ave", "types" : [ "route" ] }, { "long_name" : "Butchertown", "short_name" : "Butchertown", "types" : [ "neighborhood", "political" ] }, { "long_name" : "Louisville", "short_name" : "Louisville", "types" : [ "locality", "political" ] }, { "long_name" : "Jefferson County", "short_name" : "Jefferson County", "types" : [ "administrative_area_level_2", "political" ] }, { "long_name" : "Kentucky", "short_name" : "KY", "types" : [ "administrative_area_level_1", "political" ] }, { "long_name" : "United States", "short_name" : "US", "types" : [ "country", "political" ] }, { "long_name" : "40206", "short_name" : "40206", "types" : [ "postal_code" ] } ], "formatted_address" : "404 Frankfort Ave, Louisville, KY 40206, USA", "geometry" : { "location" : { "lat" : 38.2644825, "lng" : -85.72534570000001 }, "location_type" : "RANGE_INTERPOLATED", "viewport" : { "northeast" : { "lat" : 38.2658314802915, "lng" : -85.72399671970851 }, "southwest" : { "lat" : 38.2631335197085, "lng" : -85.72669468029152 } } }, "partial_match" : true, "place_id" : "", "types" : [ "street_address" ] } , "status" : "OK" }');
        res.setStatusCode(200);
        return res;
    }
}