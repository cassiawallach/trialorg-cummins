@IsTest
public class CSS_WS_J2A_GetSPData_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '   \"Header\":{  '+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"Message if any..\"'+
        '   },'+
        '   \"DataArea\":{  '+
        '      \"Region\":\"MEXICO\",'+
        '      \"Territory\":\"201\",'+
        '      \"ChannelOfDistribution\":\"Fleet\",'+
        '      \"ChannelCode\":\"013\",'+
        '      \"FieldServiceLaborRate\":\"54.3\",'+
        '      \"InShopLaborRate\":\"23.4\",'+
        '      \"TravelRate\":\"35.4\",'+
        '      \"Details\":[  '+
        '         {  '+
        '            \"PromotionId\":\"1066534\",'+
        '            \"FstName\":\"Luis\",'+
        '            \"LastName\":\"Lopez\"'+
        '         },'+
        '         {  '+
        '            \"PromotionId\":\"B971342\",'+
        '            \"FstName\":\"Mario\",'+
        '            \"LastName\":\"Salazar\"'+
        '         }'+
        '      ]'+
        '   }'+
        '}';
        
        CSS_WS_J2A_GetSPData obj = CSS_WS_J2A_GetSPData.parse(json);
        System.assert(obj != null);
        system.debug(obj);
    }
}