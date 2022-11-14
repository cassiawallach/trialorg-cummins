@isTest
global class CSS_WS_TG_IACSSJobMockTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"Status":"Success","ServiceVersion":"2.0","ServiceName":"IACSSJobCreation","ReturnCodeDescription":"CG01-CSS Job Number is generated successfully"},"DataArea":{"IASNumber":"IAS-0000004220","CSSJobNumber":"CSS-00003948"}}');
        //res.setBody('{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"1.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"PSN":"79634249","prioritizedData":[{"rootCause4":"","rootCause3":"Engine Wiring Harness","rootCause2":"Engine Control Module","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"9%","rc2Likelihood":"10%","rc1Likelihood":"76%","prifc":"1117","lhrs":"2.50"}],"IASNumber":"IAS-0000004220","CSSEnabled":"Y","algorithm":"Advanced"}}');
        res.setStatusCode(200);
        return res;
    }
}