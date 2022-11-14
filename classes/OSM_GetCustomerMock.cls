@isTest
global class OSM_GetCustomerMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"DataArea":[{"LocationAddressline3":"","RequirePO":"Y","AmountDue":"88469.17","CustomerCode":"183600","CreditLimit":"1000000","QuoteCustomer":"N","City":"PHOENIX","AvailableCredit":"911530.83","State":"AZ","Country":"US","AreaCode":"800","PhoneNumber":"467-6017","PaymentType":"CHARGE","CustomerName":"SWIFT LEASING","Postalcode1":"85043","LocationAddressline1":"2200 SOUTH 75TH AVENUE","LocationAddressline2":"","Postalcode2":""}],"Header":{"Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"Location":{"LocationID":"02850-02024"}}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}