@IsTest
public class CSS_WS_J2A_GetEngineData_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"Message if any..\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"Esn\": \"79384192\",'+
        '       \"ServiceModelName\": \"ISX CM871\",'+
        '       \"EngineFamilyCode\": \"31\",'+
        '       \"EngineAppCode\": \"130\",'+
        '       \"ProdAppCode\": \" \",'+
        '       \"ProdAppDesc\": \" \",'+
        '       \"BuildDate\": \" \",'+
        '       \"EngineBillToCode\": \" \",'+
        '       \"MarineAppFlag\": \" \",'+
        '       \"AutomotiveAppFlag\": \" \",'+
        '       \"EngineAppDesc\": \"AUTOMOTIVE\",'+
        '       \"CustomerName\": \"Castores\",'+
        '       \"Manufacturer\": \"KENWORTH\",'+
        '       \"Model\": \"T800\",'+
        '       \"WarrantyStartDate\": \"1/10/2016  12:00:00 AM\",'+
        '       \"EtoConversionDate\": \" \",'+
        '       \"EquipmentId\": \"F14\",'+
        '       \"AccessCode\": \" \"'+
        '   }'+
        '}';

        CSS_WS_J2A_GetEngineData obj = CSS_WS_J2A_GetEngineData.parse(json);
        System.assert(obj != null);
    }
}