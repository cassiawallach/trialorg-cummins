@IsTest
Public Class CSS_WS_J2A_GetPartsData_Test{
    
    Static TestMethod Void testParse(){
        String json = '{' +
        '    \"Header\":{' +
        '        \"Status\": \"success\",' +
        '        \"ReturnCodeDescription\": \"Message if any..\"' +
        '    },' +
        '    \"DataArea\":{' +
        '        \"PartNumberLong\": \"FB05456\",' +
        '        \"PartInService\": \"Y\",' +
        '        \"PartDescription\": \"FILTER AUX\",' +
        '        \"KitPartFlag\": \"Y\",' +
        '        \"PartProductCode\": \"ABC\",' +
        '        \"SupersededPartNumber\": \"FB05456-1\"' +
        '    }' +
        '}';
        CSS_WS_J2A_GetPartsData obj = CSS_WS_J2A_GetPartsData.parse(json);
        System.assert(obj != null);
    }
}