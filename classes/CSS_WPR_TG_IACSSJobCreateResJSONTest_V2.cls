@IsTest
public class CSS_WPR_TG_IACSSJobCreateResJSONTest_V2 {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"Success\",'+
        '       \"ServiceVersion\": \"2.0\",'+
        '       \"ServiceName\": \"IACSSJobCreation\",'+
        '       \"ReturnCodeDescription\": \"CSS Job Number is generated successfully\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"IASNumber\": \"IAS-0000000310\",'+
        '       \"CSSJobNumber\": \"CSS-00039424\"'+
        '   }'+
        '}';
        CSS_WPR_TG_IACSSJobCreationResJSON_V2 obj = CSS_WPR_TG_IACSSJobCreationResJSON_V2.parse(json);
        System.assert(obj != null);
    }
}