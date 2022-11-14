@IsTest
public class OSM_WS_AccessTokenOPWrapper_Test {


    static testmethod void testParse(){
             String json = '{'+
        '\"access_token\" : \"string\",'+
        '\"exceptionFlag\" : false,'+
        '\"totalAuthCallTime\" : 100,'+
        '\"errorMessage\" : \"Error Message\"'+
        '}';
        OSM_WS_AccessTokenOPWrapper obj = OSM_WS_AccessTokenOPWrapper.parse(json);
         System.assert(obj != null);
    }
}