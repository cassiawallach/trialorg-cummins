@IsTest
public class CSS_WS_J2A_ValidateMultiESN_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '   \"Header\":{  '+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"Message if any..\"'+
        '   },'+
        '   \"DataArea\":{  '+
        '      \"Details\":[  '+
        '         {  '+
        '            \"Esn\":\"79384192\",'+
        '            \"ValidationFlag\":\"Y\",'+
        '            \"WarrantyStartDate\":\"10/01/2016  12:00:00 a. m.\"'+
        '         },'+
        '         {  '+
        '            \"Esn\":\"35089518\",'+
        '            \"ValidationFlag\":\"N\",'+
        '            \"WarrantyStartDate\":\"10/01/2016  12:00:00 a. m.\"'+
        '         }'+
        '      ]'+
        '   }'+
        '}';
        
        CSS_WS_J2A_ValidateMultiESN obj = CSS_WS_J2A_ValidateMultiESN.parse(json);
        System.assert(obj != null);
    }
}