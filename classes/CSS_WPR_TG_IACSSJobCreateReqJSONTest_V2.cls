@IsTest
public class CSS_WPR_TG_IACSSJobCreateReqJSONTest_V2 {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"ServiceName\": \"IACSSJobCreation\",'+
        '       \"ServiceVersion\": \"1.0\",'+
        '       \"ToolID\": \"ATLASMOBILE\",'+
        '       \"SenderID\": \"oh559\",'+
        '       \"TargetID\": \"CSS\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"IASNumber\": \"IAS-0000000309\"'+
        '   }'+
        '}';
        CSS_WPR_TG_IACSSJobCreationReqJSON_V2 obj = CSS_WPR_TG_IACSSJobCreationReqJSON_V2.parse(json);
        System.assert(obj != null);
    }
}