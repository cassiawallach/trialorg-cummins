@IsTest
Public Class CSS_WS_J2A_GetSRTData_Test{

    Static TestMethod Void testParse(){
        String json = '{' +
        '    \"Header\":{' +
        '        \"Status\": \"Success\",' +
        '        \"ReturnCodeDescription\": \"Message if any..\"' +
        '    },' +
        '    \"DataArea\":{' +
        '        \"Details\":[{' +
        '            \"SRTCode\":\"01-03H-00\",' +
        '            \"StepId\":\"12345\",' +
        '            \"SRTDescription\":\"Crankshaft - Remove and Install - QSF3.8 CM2350 F107\",' +
        '            \"HoursUnit\":\"11.5\"' +
        '        },' + 
        '        {' +
        '            \"SRTCode\":\"19-01F-00\",' +
        '            \"StepId\":\"67890\",' +
        '            \"SRTDescription\":\"EGR Temperature Sensor - Remove and Install - QSF3.8 CM2350 F107\",' +
        '            \"HrsUnit\":\"0.3\"' +
        '        }]' +
        '    }' +
        '}';
        CSS_WS_J2A_GetSRTData obj = CSS_WS_J2A_GetSRTData.parse(json);
        System.assert(obj != null);
    }
}