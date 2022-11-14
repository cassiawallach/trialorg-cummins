@isTest
global class CSS_WS_SRT_MakeModelEquipIdMock_Test implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"DataArea":{"EquipmentData":[{"ServiceModelDetails":[{"SMN":"B6.7S","EF":"83"}],"Status":"ACTIVE","ApplicationCategory":"A","Model":"SC7000","EngineFamilyCode":"83","Configuration":"Cab Over Engine","EquipmentId":"EQ5335","AccessCode":"B","Make":"STERLING"},{"ServiceModelDetails":[{"SMN":"ISC CM554","EF":"41"},{"SMN":"ISC CM850","EF":"41"},{"SMN":"ISC CM2150","EF":"41"},{"SMN":"ISC8.3 CM2250","EF":"41"}],"Status":"ACTIVE","ApplicationCategory":"A","Model":"108SD","EngineFamilyCode":"41","Configuration":"Medium Conventional","EquipmentId":"EQ6860","AccessCode":"C","Make":"FREIGHTLINER"},{"ServiceModelDetails":[{"SMN":"6B5.9","EF":"40"}],"Status":"ACTIVE","ApplicationCategory":"I","Model":"BH123T","EngineFamilyCode":"40","Configuration":"Tractor","EquipmentId":"EQ10779","AccessCode":"B","Make":"DEZZI"}]},"Header":{"ReturnCodeDescription":"Normal, Successful completion.","Status":"SUCCESS"}}');
        res.setStatusCode(200);
        return res;
    }
}