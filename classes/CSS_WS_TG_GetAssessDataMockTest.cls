@isTest
global class CSS_WS_TG_GetAssessDataMockTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"Status":"Success","ServiceVersion":"1.0","ServiceName":"GetPrioritizedFC","ReturnCodeDescription":"Prioritized FCs sent successfully"},"DataArea":{"unPrioritizedData":[{"upfcdesc":"Power Supply Lost With Ignition On - Data Erratic, Intermittent, or Incorrect","upfc":"1117","rc":"6"},{"upfcdesc":"Aftertreatment 1 Diesel Exhaust Fluid Pressure - Data Valid But Below Normal Operating Range - Moderately Severe Level","upfc":"3574","rc":"6"}],"PSN":"79634249","prioritizedData":[{"relfc":[],"prifcdesc":null,"prifc":"2636"},{"relfc":[],"prifcdesc":"Aftertreatment 1 Diesel Exhaust Fluid Dosing Valve 1 - Mechanical System Not Responding or Out of Adjustment","prifc":"3568"},{"relfc":[{"rfcdesc":"Aftertreatment 1 Diesel Exhaust Fluid Dosing Unit Input Lines - Condition Exists","rfc":"1682"},{"rfcdesc":"Engine Protection Torque Derate - Condition Exists","rfc":"3714"}],"prifcdesc":"Aftertreatment 1 Diesel Exhaust Fluid Pressure - Data Erratic, Intermittent, or Incorrect","prifc":"3596"}],"algorithm":"Advanced"}}');
        res.setStatusCode(200);
        return res;
    }
}