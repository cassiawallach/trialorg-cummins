@IsTest
public class CSS_WS_J2A_GetSRTOverlap_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '   \"Header\":{  '+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"Message if any..\"'+
        '   },'+
        '   \"DataArea\":{  '+
        '      \"Details\":[  '+
        '         {  '+
        '            \"Name\": \"\",'+
        '            \"OverlapHours\": \"0.00\",'+
        '            \"SrtQty\": \"0\",'+
        '            \"Claim\": \"\",'+
        '            \"SrtCode\": \"01-03H-00\",'+
        '            \"EngineFamilyCode\": \"46\",'+
        '            \"SrtAccessCode\": \"A\",'+
        '            \"FailureLine\": \"\"'+
        '         },'+
        '         {  '+
        '            \"Name\": \"\",'+
        '            \"OverlapHours\": \"0.00\",'+
        '            \"SrtQty\": \"0\",'+
        '            \"Claim\": \"\",'+
        '            \"SrtCode\": \"01-03H-00\",'+
        '            \"EngineFamilyCode\": \"46\",'+
        '            \"SrtAccessCode\": \"A\",'+
        '            \"FailureLine\": \"\"'+
        '         },'+
        '         {  '+
        '            \"Name\": \"\",'+
        '            \"OverlapHours\": \"0.70\",'+
        '            \"SrtQty\": \"0\",'+
        '            \"Claim\": \"\",'+
        '            \"SrtCode\": \"01-03H-00\",'+
        '            \"EngineFamilyCode\": \"46\",'+
        '            \"SrtAccessCode\": \"A\",'+
        '            \"FailureLine\": \"\"'+
        '         }'+
        '      ]'+
        '   }'+
        '}';
        
        CSS_WS_J2A_GetSRTOverlap obj = CSS_WS_J2A_GetSRTOverlap.parse(json);
        System.assert(obj != null);
    }
}