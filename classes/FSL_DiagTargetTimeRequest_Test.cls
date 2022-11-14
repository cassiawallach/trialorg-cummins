//Adding comment for deployment -- Akansha MV_688 8/25/2022

@IsTest
public class FSL_DiagTargetTimeRequest_Test {
        static testMethod void testParse() {
       String json = '{'+
        ' \"Header\": {'+
        '  \"Sender\": {'+
        '   \"MessageID\": \"MessageID\",'+
        '   \"ServiceName\": \"SendGSQParts\",'+
        '   \"SenderID\": \"CSS\"'+
        '  },'+
        '  \"Target\": {'+
        '   \"TargetID\": \"BMS\"'+
        '  }'+
        
        ' },'+
        ' \"DataArea\": {'+
        '   \"SolutionIds\":[\"S00005779\", \"S00001271\"],'+
        '    \"EquipmentId\": \"02400\",'+
        '    \"ServiceModelName\": \"02394\",'+
        '    \"EngineFamily\": \"WOQT\",'+
        '    \"EffectiveDateTime\": \"123456\",'+
        '    \"LanguageCode\": \"123456\"'+
    
        '}'+
        '}';
        FSL_DiagTargetTimeRequest obj = FSL_DiagTargetTimeRequest.parse(json);
        System.assert(obj != null);
    }
}