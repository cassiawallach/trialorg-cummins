@isTest
global class FSLSiebelCodeMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Id": "bcaac389-cc86-e811-a965-000d3a1c5096","Published in CES 14602": true,"Cummins Fault Code": 221,"Revision": 191,"PID": "108","SID": "Not Mapped","MID": "Not Mapped","J1587 FMI": null,"SPN": null,"J1939FMI": "3","J2012 Pcode": null,"Lamp Color": "Amber","Lamp Device": "Warning","Cummins Description": "Barometric Pressure Sensor Circuit - Voltage Above Normal or Shorted to High Source","Special Instructions": "Default P-code mapping. Can be overridden in C2ST if needed.", "Algorithm Description": "High signal voltage detected at barometric pressure circuit.","Information": null,"AWL_Suppression": "Suppress","AWL_Suppression_Reserved_2": "Suppress","AWL_Suppression_Reserved_3": "None","AWL_Suppression_Reserved_4": "None","AWL_Suppression_Reserved_5": "None","AWL_Suppression_Reserved_6": "None","AWL_Suppression_Reserved_7": "None","AWL_Suppression_Reserved_8": "None","LanguageKey": "en"}');
        res.setStatusCode(200);
        return res;
    }
}