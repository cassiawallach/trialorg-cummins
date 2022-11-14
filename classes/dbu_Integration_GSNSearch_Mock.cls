@isTest
global class dbu_Integration_GSNSearch_Mock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        // response.setBody(JSON.serialize(edqResposeWrapper));
        response.setBody('{"Header": {"MessageIdentifier": "1-8124c200-3b7e-11eb-9c51-02bd531db0d8","ReturnCode": "PARTLIST001","ReturnCodeDescription": "PartsList retrievedsuccessfully","Status": "SUCCESS","MessageType": "S"},"DataArea": {"PartLists": [{"ESN": "79464646","Parts": [{"Number": "3687580", "Description": "Studded Flange Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},{ "Number": "3171713","Description": "Hexagon Flange Head Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},],"Kits": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},],"Gaskets": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},{"Number": "4376104","Description": "KIT,UPPER ENGINE GASKET"}]}]}}');
        return response;
    }
}