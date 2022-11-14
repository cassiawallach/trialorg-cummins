@IsTest
public class CSS_WPR_TG_GetAssesDataReqJSONTest_V3 {
  static testMethod void testParse() {
    String json = '{'+
    '  \"Header\": {'+
    '    \"ServiceName\": \"GetAssessData\",'+
    '    \"ServiceVersion\": \"1.0\",'+
    '    \"ToolID\": \"ATLASMOBILE\",'+
    '    \"SenderID\": \"nt321\",'+
    '    \"TargetID\": \"CSS\"'+
    '  },'+
    '  \"DataArea\": {'+
    '    \"PSN\": \"79541769\",'+
    '    \"SERVICEMODELNAME\": \"ISX15 CM3350\",'+
    '    \"ERT\": \"20090003\",'+
    '    \"MAKE\": \"UNLISTED\",'+
    '    \"MODEL\": \"ALL\",'+
    '    \"ACCESS\": \"C\",'+
    '    \"UserLocation\": \"56270-56255\",'+
    '    \"CustomerName\": \"TEST\",'+
    '    \"ComplaintText\": \"Oil Leak \",'+
    '    \"IASNumber\": \"IAS-0000000133\",'+
    '    \"FAULTLIST\": ['+
    '      {'+
    '        \"fc\": \"1118\",'+
    '        \"occurenceTime\": 0,'+
    '        \"status\": \"active\",'+
    '        \"count\": 1'+
    '      }'+
    '      '+
    '    ]'+
    '  }'+
    '}';
    CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj = CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json);
    System.assert(obj != null);
  }
}